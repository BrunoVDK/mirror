//
//  PointerButton.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 15/07/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//
//  A button that makes the hovering cursor point.
//

#import "PointerButton.h"

#pragma mark Pointer Button

@interface PointerButton(Private)

- (void)updateColor;

@end

@implementation PointerButton

@synthesize textColor = _textColor, hoverColor = _hoverColor;

#pragma mark Interface

- (void)awakeFromNib {
    
    cursor = [NSCursor pointingHandCursor];
    
    if ([[self title] isEqualToString:@"OK"]) {
        self.color = [NSColor colorWithCalibratedRed:0.0 green:0.4 blue:0.6 alpha:1.0];
        self.hoverColor = [NSColor colorWithCalibratedRed:0.0 green:0.2 blue:0.4 alpha:1.0];
    }
    else {
        self.color = [NSColor colorWithCalibratedWhite:0.2 alpha:1.0];
        self.hoverColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
    }
    
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    
    [newWindow invalidateCursorRectsForView:self];
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
                                                  owner:self
                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
    
}

#pragma mark Cursor

- (void)resetCursorRects {
    
    [self discardCursorRects];
    [self addCursorRect:self.bounds cursor:cursor];
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
    [super mouseEntered:theEvent];
    [cursor push];
    
    mouseInside = true;
    
    [self updateColor];
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    [super mouseExited:theEvent];
    [cursor pop];
    
    mouseInside = false;
    
    [self updateColor];
    
}

- (void)setTitleColor:(NSColor *)color {
    
    NSMutableAttributedString *colorTitle =  [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    
    [colorTitle addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:titleRange];
    
    [self setAttributedTitle:colorTitle];
    
    [colorTitle release];
    
}

#pragma mark Color

- (void)setColor:(NSColor *)color {
    
    if (_textColor != color) {
        [_textColor release];
        _textColor = [color copy];
    }
    
    [self updateColor];
    
}

- (void)setHoverColor:(NSColor *)hoverColor {
    
    if (_hoverColor != hoverColor) {
        [_hoverColor release];
        _hoverColor = [hoverColor copy];
    }
    
    [self updateColor];
    
}

- (void)updateColor {
    
    if ([self.window isKeyWindow]) {
        if (mouseInside)
            [self setTitleColor:self.hoverColor];
        else
            [self setTitleColor:self.textColor];
    }
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_textColor release];
    [_hoverColor release];
    
    [trackingArea release];
    
    [super dealloc];
    
}

@end
