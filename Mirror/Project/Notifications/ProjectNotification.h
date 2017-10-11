//
//  ProjectNotification.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An enumeration for types of notifications noted by a `Project` instance.
 */
enum {
    /**
     * A error notification.
     */
    ProjectNotificationError = 0,
    /**
     * A warning notification.
     */
    ProjectNotificationWarning,
    /**
     * An update notification.
     */
    ProjectNotificationUpdate,
} typedef ProjectNotificationType;

/**
 * A `ProjectNotification` represents a project notification having the content of the notifcation as well as the date of occurence.
 */
@interface ProjectNotification : NSObject <NSCoding> {
    
    ProjectNotificationType _type;
    NSString *_content;
    NSDate *_date;
    
}

/**
 * The type of this notification.
 */
@property (nonatomic, readonly) ProjectNotificationType type;

/**
 * An icon representing this notification.
 */
@property (nonatomic, readonly) NSImage *icon;

/**
 * The content of this notification.
 */
@property (nonatomic, readonly) NSString *content;

/**
 * The date of occurence for this notification.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 * Create a notification of given type, with given content and given date of occurence.
 *
 * @param type The type of notification the new notification should be.
 * @param content The textual content for the new notification.
 * @param date The date of occurence for the new notification.
 * @return A new project notification of given type, with given content and given date of occurence,
 *          or nil if an error occured.
 */
+ (id)notificationOfType:(ProjectNotificationType)type content:(NSString *)content andDate:(NSDate *)date;

/**
 * Create a notification of given type, with given content and given date of occurence.
 *
 * @param type The type of notification the new notification should be.
 * @param content The textual content for the new notification.
 * @param date The date of occurence for the new notification.
 * @return A new project notification of given type, with given content and given date of occurence,
 *          or nil if an error occured.
 */
- (id)initWithType:(ProjectNotificationType)type content:(NSString *)content andDate:(NSDate *)date;

@end
