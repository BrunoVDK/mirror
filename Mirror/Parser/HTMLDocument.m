//
//  HTMLDocument.m
//  Mirror
//
//  Created by Ben Reeves on 09/03/2010. Slightly adapted by Bruno Vandekerkhove on 03/09/2016.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import "HTMLDocument.h"

#pragma mark HTML Document

@implementation HTMLDocument

#pragma mark Constructors

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error {
    
    NSData *_data = [[NSData alloc] initWithContentsOfURL:url options:0 error:error];
    
    if (_data == nil || *error)
        return nil;
    
    return [self initWithData:_data error:error];
    
}

- (id)initWithData:(NSData *)data error:(NSError **)error {
    
	if (self = [super init]) {
        
		_doc = NULL;

		if (data) {
            
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
			const char *enc = CFStringGetCStringPtr(cfencstr, 0);
			//_doc = htmlParseDoc((xmlChar*)[data bytes], enc);
			_doc = htmlReadDoc((xmlChar *)[data bytes], "", enc, XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
            
		}
		else if (error)
            *error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
        
	}
	
	return self;
    
}

- (id)initWithString:(NSString *)string error:(NSError **)error {
    
    if (self = [super init]) {
        
        _doc = NULL;
        
        if ([string length] > 0) {
            
            CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
            CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
            const char *enc = CFStringGetCStringPtr(cfencstr, 0);
            // _doc = htmlParseDoc((xmlChar*)[string UTF8String], enc);
            int optionsHtml = HTML_PARSE_RECOVER;
            optionsHtml = optionsHtml | HTML_PARSE_NOERROR;
            optionsHtml = optionsHtml | HTML_PARSE_NOWARNING;
            _doc = htmlReadDoc((xmlChar *)[string UTF8String], NULL, enc, optionsHtml);
            
        }
        else if (error)
            *error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
        
    }
    
    return self;
    
}

#pragma mark Getters

- (HTMLNode *)doc {
    
    if (_doc == NULL)
        return NULL;
    
    return [[HTMLNode alloc] initWithXMLNode:(xmlNode *)_doc];
    
}

- (HTMLNode *)html {
    
    if (_doc == NULL)
        return NULL;
    
    return [[self doc] findChildOfType:@"html"];
    
}

- (HTMLNode *)head {
    
    if (_doc == NULL)
        return NULL;
    
    return [[self doc] findChildOfType:@"head"];
    
}

- (HTMLNode *)body {
    
    if (_doc == NULL)
        return NULL;
    
    return [[self doc] findChildOfType:@"body"];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    if (_doc)
        xmlFreeDoc(_doc);
    
    [super dealloc];
	
}

@end
