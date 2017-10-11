//
//  RoundedCornerTextField.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 15/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//
//  A text field with a rounded corner.
//

#import "RoundedCornerTextField.h"

#pragma mark Rounded Corner Text Field

@implementation RoundedCornerTextField

- (void)awakeFromNib {
    
    [[self cell] setBezelStyle: NSTextFieldRoundedBezel];
}


- (void)drawRect:(NSRect)dirtyRect {
    
    NSRect blackOutlineFrame = NSMakeRect(0.0, 0.0, [self bounds].size.width, [self bounds].size.height-1.0);
    NSGradient *gradient = nil;
    if ([NSApp isActive]) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    }
    else {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    }
    
    [gradient drawInBezierPath:[NSBezierPath bezierPathWithRoundedRect:blackOutlineFrame xRadius:5 yRadius:5] angle:90];
    [gradient release];
    
}

@end
