//
//  BadgeView.h
//
//  Created by Bruno Vandekerkhove on 22/08/15.
//  Copyright (c) 2015 Bruno VDK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A `BadgeView` can be used to display a message in the dock.
 */
@interface BadgeView : NSView {
    
    BOOL _visible;
    NSString *_message;
    NSImage *badgeImage;
    
}

/**
 * A flag denoting whether or not this badge view is visible.
 */
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

/**
 * The message displayed by this badge view.
 */
@property (nonatomic, copy) NSString *message;

/**
 * A shared singleton to be used by the application.
 */
+ (id)sharedView;

@end
