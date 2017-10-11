//
//  PointerButton.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 15/07/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `PointerButton` class represents a button that makes the cursor a pointer upon hovering.
 *  The (hover) text color of the button can be altered.
 */
@interface PointerButton : NSButton {
    
    NSTrackingArea *trackingArea;
    BOOL mouseInside;
    NSCursor *cursor;
    NSColor *_textColor, *_hoverColor;
    
}

/**
 * The button's text color.
 */
@property (nonatomic, copy) NSColor *textColor;

/**
 * The button's text color when it is hovered.
 */
@property (nonatomic, copy) NSColor *hoverColor;

@end
