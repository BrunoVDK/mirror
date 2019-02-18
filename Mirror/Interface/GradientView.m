//
//  GradientView.m
//  Designing
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import "GradientView.h"

#pragma mark Gradient View

@implementation GradientView

@synthesize gradient = _gradient;

+ (NSGradient *)defaultGradient {
    
    return [[[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceRed:0.87 green:0.87 blue:0.87 alpha:1.0], 0.0,
            [NSColor colorWithDeviceRed:0.79 green:0.79 blue:0.79 alpha:1.0], 1.0,
            nil] autorelease];
    
}

+ (NSGradient *)secondaryGradient {
    
    return [[[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceRed:0.96 green:0.96 blue:0.96 alpha:1.0], 0.0,
            [NSColor colorWithDeviceRed:0.96 green:0.96 blue:0.96 alpha:1.0], 1.0,
            nil] autorelease];
    
}

#pragma mark Constructors

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect])
        [self setGradient:[GradientView defaultGradient]];
    
    return self;
    
}

#pragma mark Drawing

- (void)setGradient:(NSGradient *)gradient {
    
    if (_gradient != gradient) {
        [_gradient release];
        _gradient = [gradient copy];
        [self setNeedsDisplay:true];
    }
    
}

- (void)drawRect:(NSRect)dirtyRect {
    
    if (self.gradient) {
        NSBezierPath * path = [NSBezierPath bezierPathWithRect:dirtyRect];
        [[self gradient] drawInBezierPath:path angle:270];
    }
    
    [super drawRect:dirtyRect];    
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_gradient release];
    [super dealloc];
    
}

@end
