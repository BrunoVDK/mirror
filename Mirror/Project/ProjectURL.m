//
//  ProjectURL.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 03/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "HTMLDocument.h"
#import "NSString+Additions.h"
#import "Project.h"
#import "ProjectURL.h"

#pragma mark Project URL

@implementation ProjectURL

@synthesize identifier = _identifier, title = _title, URL = _URL, icon = _icon, cancelled, failed, bytesScanned, bytesWritten, linksDetected;

#pragma mark Constructors

- (id)initWithURL:(NSURL *)url identifier:(NSUInteger)identifier {
    
    if (self = [super init]) {
        
        fetchingAttributes = true;
        fetchedTitle = fetchedIcon = false;
        
        _identifier = identifier;
        
        _URL = [url retain];
        _title = [[url absoluteString] copy];
        _icon = [[NSImage imageNamed:NSImageNameNetwork] retain];
        
        bytesScanned = bytesWritten = linksDetected = 0;
        
    }
    
    return self;
    
}

#pragma mark Coding

- (void)encodeWithCoder:(NSCoder *)enCoder {
    
    [enCoder encodeObject:[NSNumber numberWithBool:fetchedTitle] forKey:@"FetchedTitle"];
    [enCoder encodeObject:[NSNumber numberWithBool:fetchedIcon] forKey:@"FetchedIcon"];
    [enCoder encodeObject:[NSNumber numberWithBool:cancelled] forKey:@"Cancelled"];
    [enCoder encodeObject:[NSNumber numberWithBool:failed] forKey:@"Failed"];
    
    [enCoder encodeObject:_title forKey:@"Title"];
    [enCoder encodeObject:_icon forKey:@"Icon"];
    [enCoder encodeObject:_URL forKey:@"URL"];
    
    [enCoder encodeObject:[NSNumber numberWithUnsignedInteger:_identifier] forKey:@"Identifier"];
    [enCoder encodeObject:[NSNumber numberWithLongLong:bytesScanned] forKey:@"BytesScanned"];
    [enCoder encodeObject:[NSNumber numberWithLongLong:bytesWritten] forKey:@"BytesWritten"];
    [enCoder encodeObject:[NSNumber numberWithLongLong:linksDetected] forKey:@"LinksDetected"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        fetchedTitle = [[aDecoder decodeObjectForKey:@"FetchedTitle"] boolValue];
        fetchedIcon = [[aDecoder decodeObjectForKey:@"FetchedIcon"] boolValue];
        cancelled = [[aDecoder decodeObjectForKey:@"Cancelled"] boolValue];
        failed = [[aDecoder decodeObjectForKey:@"Failed"] boolValue];
        
        _title = [[aDecoder decodeObjectForKey:@"Title"] retain];
        _icon = [[aDecoder decodeObjectForKey:@"Icon"] retain];
        _URL = [[aDecoder decodeObjectForKey:@"URL"] retain];
        
        _identifier = [[aDecoder decodeObjectForKey:@"Identifier"] unsignedIntegerValue];
        bytesScanned = [[aDecoder decodeObjectForKey:@"BytesScanned"] longLongValue];
        bytesWritten = [[aDecoder decodeObjectForKey:@"BytesWritten"] longLongValue];
        linksDetected = [[aDecoder decodeObjectForKey:@"LinksDetected"] longLongValue];
        
    }
    
    return self;
    
}

#pragma mark Attribute Fetching

- (BOOL)fetchAttributes { // Fetch title and icon by parsing <link> and <title> tags in given URL
    
    if (!self.URL || (fetchedTitle && fetchedIcon))
        return false;
    
    fetchingAttributes = true;
    
    if ([[[NSFileManager defaultManager] attributesOfItemAtPath:[self.URL path] error:nil] fileSize] < 1024*1024*10) { // Don't get attributes of large URLs
        
        NSError *error = nil;
        NSURL *fetchURL = (self.URL.pathExtension == nil ? self.URL : [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", self.URL.scheme, self.URL.host]]);
        if (fetchURL == nil)
            fetchURL = self.URL;
        HTMLDocument *document = [[HTMLDocument alloc] initWithContentsOfURL:fetchURL error:&error];
        
        if (!error) {
            [self fetchTitleFromDocument:document];
            [self fetchIconFromDocument:document];
        }
        
        [document release];
        
    }
    
    fetchingAttributes = false;
    
    return (fetchedTitle && fetchedIcon);
    
}

- (void)fetchTitleFromDocument:(HTMLDocument *)document {
    
    if (fetchedTitle)
        return;
    
    HTMLNode *headNode = [document head];
    NSArray *titleNodes = [headNode findChildrenOfType:@"title"];
    
    if ([titleNodes count] > 0) {
        NSString *newTitle = [[titleNodes objectAtIndex:0] contents];
        if (newTitle && ![newTitle isEmpty]) {
            [self setTitle:newTitle];
            fetchedTitle = true;
        }
    }
    
}

- (void)fetchIconFromDocument:(HTMLDocument *)document {
    
    if (fetchedIcon)
        return;
    
    NSImage *icon = nil;
    
    if (!self.cancelled && self.URL) {
        NSImage *newIcon = [self searchURLForImages:self.URL withNames:[self iconNames]];
        if (newIcon && (!icon || icon.size.width < newIcon.size.width))
            icon = newIcon;
    }
    
    if (!self.cancelled && (!icon || (icon.size.width < PREFERRED_ICON_SIZE))) {
        
        HTMLNode *headNode = [document head];
        NSArray *linkNodes = [headNode findChildrenOfType:@"link"];
        
        for (HTMLNode *linkNode in linkNodes) {
            
            NSString *relativeValue = [linkNode getAttributeNamed:@"rel"];
            
            if (relativeValue && [self relativeValueIsIcon:relativeValue]) {
                
                NSString *hrefValue = [linkNode getAttributeNamed:@"href"];
                
                if (hrefValue) {
                    
                    NSURL *iconURL = [NSURL URLWithString:hrefValue relativeToURL:self.URL];
                    NSImage *newIcon = [self getIconFromURL:iconURL];
                    
                    if (newIcon && (!icon || (icon.size.width < PREFERRED_ICON_SIZE && icon.size.width < newIcon.size.width))) {
                        icon = newIcon;
                        if (icon.size.width >= PREFERRED_ICON_SIZE)
                            break;
                    }
                    
                }
                
            }
            
        }
        
    }
    
    if (icon) {
        [self setIcon:icon];
        fetchedIcon = true;
    }
    
}

- (NSImage *)getIconFromURL:(NSURL *)url {
    
    NSImage *icon = [[NSImage alloc] initWithContentsOfURL:url];
    
    if (icon && icon.size.width >= 10 && icon.size.height >= 10)
        return [icon autorelease];
    
    [icon release];
    
    return nil;
    
}

- (NSImage *)searchURLForImages:(NSURL *)url withNames:(NSArray *)names {
    
    __block NSImage *icon = nil;
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", [url scheme], [url host]]];
    
    [names enumerateObjectsUsingBlock:^(NSString *iconName, NSUInteger idx, BOOL *stop) {
        
        if (!self.cancelled) {
            
            NSURL *iconURL = [NSURL URLWithString:iconName relativeToURL:baseURL];
            NSImage *newIcon = [self getIconFromURL:iconURL];
            
            if (newIcon && (!icon || (icon.size.width < PREFERRED_ICON_SIZE && icon.size.width < newIcon.size.width))) {
                icon = [newIcon retain];
                if (icon.size.width >= PREFERRED_ICON_SIZE)
                    *stop = true;
            }
            
        } else
            *stop = true;
        
    }];
    
    return [icon autorelease];
    
}

- (NSArray *)iconNames {
    
    return @[@"favicon.ico", @"apple-touch-icon-precomposed.png", @"apple-touch-icon.png", @"touch-icon-iphone.png"];
    
}

- (NSArray *)linkRelativeValues {
    
    return @[@"icon", @"shortcut icon", @"apple-touch-icon"];
    
}

- (BOOL)relativeValueIsIcon:(NSString *)value {
    
    for (NSString *relativeValue in [self linkRelativeValues])
        if ([[value lowercaseString] isEqualToString:[relativeValue lowercaseString]])
            return true;
    
    return false;
    
}

- (NSString *)description { // Returns a description with statistics
        
    if (fetchingAttributes)
        return @"Fetching attributes";
    if (self.failed)
        return @"An error occured.";
    
    NSString *receivedString = [NSString stringForByteCount:bytesScanned];
    NSString *writtenString = [NSString stringForByteCount:bytesWritten];
    
    if (self.cancelled)
        return [NSString stringWithFormat:@"Cancelled (wrote %@s to %lli files).", writtenString, linksDetected];
    
    return [NSString stringWithFormat:@"Received %@, wrote %@ to %lli files", receivedString, writtenString, linksDetected];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_URL release];
    [_icon release];
    [_title release];
    
    [super dealloc];
    
}

@end