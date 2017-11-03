//
//  ProjectNotificationList.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_NOTIFICATIONS 1000

/**
 * A `ProjectNotificationList` keeps track of the notifications noted down by a `Project`.
 */
@interface ProjectNotificationList : NSArrayController <NSCoding> {
    
    NSUInteger maximumCapacity; // Maximum capacity of backing array
    
}

/**
 * Gives the status of the notification list.
 */
@property (nonatomic, readonly) NSString *status;

/**
 * Returns the size of this notification list.
 *
 * @return The number of notifications this list keeps track of.
 */
- (NSUInteger)count;

@end
