//
//  FilterFieldCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "FilterFieldCell.h"

#pragma mark Filter Field Cell

@implementation FilterFieldCell

#pragma mark Interface

- (void)awakeFromNib {
    
    [self resetCancelButtonCell];
    [self resetSearchButtonCell];
    [self setFocusRingType:NSFocusRingTypeNone];
    
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    NSRect frame = NSInsetRect(self.controlView.bounds, 1, 0.5);
    NSBezierPath *roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:NSHeight(frame) / 2 yRadius:NSHeight(frame) / 2];
    [roundedRectanglePath closePath];
    [[NSColor colorWithDeviceWhite:0.80 alpha:1.0] setStroke];
    [roundedRectanglePath stroke];
    
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
}

- (void)resetSearchButtonCell {
    
    NSButtonCell *c = [[NSButtonCell alloc] init];
	[c setButtonType:NSMomentaryChangeButton];
	[c setBezelStyle:NSRegularSquareBezelStyle];
	[c setBordered:false];
	[c setBezeled:false];
	[c setEditable:false];
	[c setImagePosition:NSImageOnly];
	[c setImage:[NSImage imageNamed:@"SearchTemplate"]];
    [self setSearchButtonCell:c];
    [c release];
    
}

@end
