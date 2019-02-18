//
//  ScrollingTextView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `ScrollingTextView` class represents a text view that scrolls continuously.
 *  As the user hovers the text view, scrolling stops temporarily.
 */
@interface ScrollingTextView : NSTextView {
    
    NSTimer *timer;
    CGFloat offset;
    
}

/**
 * Stop this text view from scrolling.
 */
- (void)stick;

/**
 * Make this text view scroll.
 */
- (void)scroll;

@end
