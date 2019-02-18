//
//  ProjectNotification.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "ProjectNotification.h"

#pragma mark Project Notification

@implementation ProjectNotification

@synthesize type = _type, content = _content, date = _date;

#pragma mark Class Methods 

+ (id)notificationOfType:(ProjectNotificationType)type content:(NSString *)content andDate:(NSDate *)date {
    
    return [[[self alloc] initWithType:type content:content andDate:date] autorelease];
    
}

#pragma mark Constructors

- (id)init {
    
    return [self initWithType:ProjectNotificationError content:@"No description available" andDate:[NSDate date]];
    
}

- (id)initWithType:(ProjectNotificationType)type content:(NSString *)content andDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _type = type;
        _content = [content retain];
        _date = [date retain];
        
    }
    
    return self;
    
}

#pragma mark Coding

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _type = (ProjectNotificationType)[aDecoder decodeIntegerForKey:@"Type"];
        _content = [[aDecoder decodeObjectForKey:@"Content"] retain];
        _date = [[aDecoder decodeObjectForKey:@"Date"] retain];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:_type forKey:@"Type"];
    [aCoder encodeObject:_content forKey:@"Content"];
    [aCoder encodeObject:_date forKey:@"Date"];
    
}

#pragma mark Getters

- (NSImage *)icon {
    
    if (_type == ProjectNotificationError)
        return [NSImage imageNamed:NSImageNameStatusUnavailable];
    else if (_type == ProjectNotificationWarning)
        return [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
    
    return [NSImage imageNamed:NSImageNameStatusAvailable];
    
}

- (NSString *)descriptionForType:(ProjectNotificationType)type {
    
    switch (type) {
        case ProjectNotificationError:
            return @"Error";
            break;
        case ProjectNotificationWarning:
            return @"Warning";
            break;
        default:
            break;
    }
    
    return @"Invalid Type";
    
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Project Notification (type = %@, description = %@, date = %@)", [self descriptionForType:_type], _content, _date];
    
}

#pragma mark Sorting

- (NSComparisonResult)compare:(ProjectNotification *)other {
    
    return [_date compare:other.date];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_content release];
    [_date release];
    
    [super dealloc];
    
}

@end
