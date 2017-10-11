//
//  ProjectSocketList.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "Project.h"
#import "ProjectSocket.h"
#import "ProjectSocketList.h"

#pragma mark Project Socket List

@implementation ProjectSocketList

@dynamic status;
@synthesize project = _project;

#pragma mark Constructors

- (id)init {
    
    if (self = [super init]) {
        
        self.clearsFilterPredicateOnInsertion = false;
        self.content = [NSMutableArray array];
        
    }
    
    return self;
    
}

#pragma mark Properties

- (NSUInteger)size {
    
    return backingArray.count;
    
}

- (NSString *)status {
    
    NSInteger nbOfSockets = self.sockets.count;
    return (nbOfSockets == 0 ? @"No connections." : [NSString stringWithFormat:(nbOfSockets == 1 ? @"%li connection." : @"%li connections."), (long)nbOfSockets]);

}

#pragma mark Mutating

- (void)addObject:(id)object {
    
    if ([object isMemberOfClass:[ProjectFile class]]) {
        
        [self willChangeValueForKey:@"status"];
        
        [super addObject:object];
        
        [self didChangeValueForKey:@"status"];
        
    }
    
}

@end
