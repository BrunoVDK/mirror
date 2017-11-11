//
//  ProjectNotificationList.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "PreferencesConstants.h"
#import "ProjectNotification.h"
#import "ProjectNotificationList.h"

#pragma mark Project Notification List

@implementation ProjectNotificationList

@dynamic status;

#pragma mark Constructors

- (id)init {
    
    if (self = [super init]) {
        
        self.automaticallyRearrangesObjects = true;
        self.usesLazyFetching = false;
        self.clearsFilterPredicateOnInsertion = false;
        [self setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]]];

        // Set up backing array
        [self cleanArray];
        [PREFERENCES addObserver:self forKeyPath:MaxUpdates options:NSKeyValueObservingOptionNew context:NULL];
        
        /*
        for (int i=1 ; i<=120 ; i++)
            [self addObject:[ProjectNotification notificationOfType:ProjectNotificationWarning
                                                            content:[NSString stringWithFormat:@"Warning %i", i]
                                                            andDate:[NSDate dateWithTimeIntervalSince1970:100000*i]]];
         */
        
    }
    
    return self;
    
}

#pragma mark Coding

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.clearsFilterPredicateOnInsertion = false;
        
        // Read backing array
        NSMutableArray *backingArray = [[aDecoder decodeObjectForKey:@"BackingArray"] mutableCopy];
        [backingArray sortUsingSelector:@selector(compare:)]; // Precaution, remove earlier first
        self.content = backingArray;
        [backingArray release];
        
        // Prepare backing array
        [self cleanArray];
        [self setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]]];
        [PREFERENCES addObserver:self forKeyPath:MaxUpdates options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.content forKey:@"BackingArray"];
    
}

#pragma mark Properties

- (NSUInteger)count {
    
    return ((NSMutableArray *)self.content).count;
    
}

- (NSString *)status {
    
    NSInteger nbOfNotifications = [self.arrangedObjects count];
    return (nbOfNotifications == 0 ? @"No notifications." : [NSString stringWithFormat:(nbOfNotifications == 1 ? @"%li notification." : @"%li notifications."), (long)nbOfNotifications]);
    
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
#if DEBUG
    NSLog(@"MAX NOTIFICATIONS %li", (long)[PREFERENCES integerForKey:MaxUpdates]);
#endif
    
    [self cleanArray]; // Remove possible excess
    
}

#pragma mark Mutating

- (void)addObject:(id)object {
    
    if ([object isMemberOfClass:[ProjectNotification class]]) {
        
        if ([self count] >= maximumCapacity) {
            [self remove:[(NSMutableArray *)self.content firstObject]];
            [super addObject:object];
        }
        else {
            [self willChangeValueForKey:@"status"];
            [super addObject:object];
            [self didChangeValueForKey:@"status"];
        }
        
    }
    
}

- (BOOL)cleanArray { // Enforce maximum capacity
    
    maximumCapacity = MAX(10, MIN([PREFERENCES integerForKey:MaxUpdates], MAX_NOTIFICATIONS)); // Minimum of 10, maximum of MAX_NOTIFICATIONS
    
    if (!self.content) {
        self.content = [NSMutableArray arrayWithCapacity:MAX_NOTIFICATIONS];
        return false; // Newly created array is already clean
    }
    
    NSUInteger count = ((NSMutableArray *)self.content).count;
    if (count <= maximumCapacity)
        return false; // Array does not exceed maximum capacity
    
    [self willChangeValueForKey:@"status"];
    
    for (int i=0 ; i<(maximumCapacity-count) ; i++)
        [self removeObject:[(NSMutableArray *)self.content firstObject]];
    
    [self didChangeValueForKey:@"status"];
    
    return true;
    
}

#pragma mark Memory Management

- (void)dealloc {
        
    [PREFERENCES removeObserver:self forKeyPath:MaxUpdates];
    
    [super dealloc];
    
}

@end
