//
//  ProjectFile.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 03/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSString+Additions.h"
#import "ProjectFile.h"

#pragma mark Project File

@implementation ProjectFile

@dynamic icon, size;
@synthesize address = _address, path = _path;

#pragma mark Constructors

- (id)initWithAddress:(NSString *)address file:(NSString *)path size:(unsigned long long)size {
    
    if (self = [super init]) {
        _address = [address copy];
        _path = [path copy];
        _size = size;
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _address = [[aDecoder decodeObjectForKey:@"Address"] retain];
        _path = [[aDecoder decodeObjectForKey:@"Path"] retain];
        _size = [aDecoder decodeInt64ForKey:@"Size"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_address forKey:@"Address"];
    [aCoder encodeObject:_path forKey:@"Path"];
    [aCoder encodeInt64:_size forKey:@"Size"];
    
}

#pragma mark Properties

- (NSImage *)icon {
    
    return [[NSWorkspace sharedWorkspace] iconForFile:_path];
    
}

- (NSString *)size {
    
    return [NSString stringForByteCount:_size];
    
}

- (NSString *)fileName {
    
    return _path.lastPathComponent.lowercaseString;
    
}

#pragma mark Actions

- (void)revealInFinder:(id)sender {
        
    [[NSWorkspace sharedWorkspace] selectFile:self.path inFileViewerRootedAtPath:nil];
    
}

#pragma mark Logging

- (NSString *)description {
    
    return [NSString stringWithFormat:@"File from address (%@) saved to path (%@), size = %@", self.address, self.path, self.size];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_address release];
    [_path release];
    
    [super dealloc];
    
}

@end
