//
//  LabeledProgressCell.m
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "LabeledProgressCell.h"

#pragma mark Labeled Progress Cell

@implementation LabeledProgressCell

- (void)setObjectValue:(id<NSCopying>)obj {
    
    if ([(NSObject *)obj isKindOfClass:[NSNumber class]])
        progress = [(NSNumber *)obj floatValue];
    
    [super setObjectValue:obj];
    
}

#pragma mark Drawing

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
#if CHANGE_NONKEY_WINDOW_DESIGN
    [([self.controlView.window isKeyWindow] ? self.backgroundColor : [NSColor colorWithCalibratedWhite:0.95 alpha:1.0]) setFill];
#endif
    NSRect fillRect = NSInsetRect(cellFrame, 0, 4);
    fillRect.size.width *= progress; // (double)(rand()) / (double)(RAND_MAX);
    NSRectFill(fillRect);
        
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
}

@end
