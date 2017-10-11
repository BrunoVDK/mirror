//
//  ColoredView.m
//  Designing
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import "ColoredView.h"

#pragma mark Colored View

@implementation ColoredView

@synthesize color = _color;

- (void)awakeFromNib {
    
    if (![self color])
        [self setColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
    
    [self setAlphaValue:1.0];
    
}

- (void)setColor:(NSColor *)color {
    
    if (_color != color) {
        [_color release];
        _color = [color copy];
        [self setNeedsDisplay:true];
    }
    
}

- (void)drawRect:(NSRect)dirtyRect {
    
    if (self.color) {
        [NSGraphicsContext saveGraphicsState];
        [[self color] setFill];
        NSRectFill(dirtyRect);
        [NSGraphicsContext restoreGraphicsState];
    }
    
}

- (void)dealloc {
        
    [_color release];
    
    [super dealloc];
    
}

@end
