//
//  ProjectSocket.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 10/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "Project.h"
#import "ProjectSocket.h"

#pragma mark Project Socket

@implementation ProjectSocket

@synthesize type = _type, address = _address, file = _file, size = _size, totalSize = _totalSize;

#pragma mark Class Methods

+ (id)socketWithAddress:(NSString *)address file:(NSString *)file size:(unsigned long long)size totalSize:(unsigned long long)totalSize {
    
    return [[ProjectSocket alloc] initWithAddress:address file:file size:size totalSize:totalSize];
    
}

+ (NSString *)descriptionForSocketType:(ProjectSocketType)type {
    
    static NSString *socketDescriptions[] = {@"Parsing", @"Receiving", @"Requesting", @"Connecting to", @"Search :", @"Ready :", @"Error :", @""};
    
    return socketDescriptions[type];
    
}

#pragma mark Constructors

- (id)initWithAddress:(NSString *)address file:(NSString *)file size:(unsigned long long)size totalSize:(unsigned long long)totalSize {
    
    if (self = [super init]) {
        _address = [address copy];
        _file = [file copy];
        _size = size;
        _totalSize = totalSize;
    }
    
    return self;
    
}

- (id)copyWithZone:(NSZone *)zone {
    
    return [ProjectSocket socketWithAddress:_address file:_file size:_size totalSize:_totalSize];
    
}

#pragma mark Interaction

- (void)cancelInProject:(Project *)project {
    
    [project cancelSocket:self];
    
}

#pragma mark Properties

- (NSImage *)icon {
    
    return nil; //[NSImage imageNamed:NSImageNameNetwork];
    
}

- (NSString *)fileName {
    
    return _file.lastPathComponent.lowercaseString;
    
}

- (float)progress {
        
    return (_totalSize > 0 ? (float)(_size) / (float)(_totalSize) : 0); // Progress percentage
    
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Project Socket [address = %@, file = %@, size = %lli, total size = %lli]", _address, _file, _size, _totalSize];
    
}

- (NSString *)socketDescription {
    
    return [NSString stringWithFormat:@"%@ %@", [ProjectSocket descriptionForSocketType:_type], _address.lastPathComponent];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_address release];
    [_file release];
    
    [super dealloc];
    
}

@end
