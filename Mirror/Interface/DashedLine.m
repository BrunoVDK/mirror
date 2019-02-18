//
//  DashedLine.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 15/06/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//
//  A view representing a dashed line.
//

#import "DashedLine.h"

#pragma mark Dashed Line

@implementation DashedLine

#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
    [line lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect))];
    [line setLineWidth:2.0];
    [self addDashStyleToPath:line];
    [[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0] set];
    [line stroke];
    
}

- (void)addDashStyleToPath:(NSBezierPath*)thePath {
    
    CGFloat dash_pattern[]={4.,4.};
    NSInteger count = sizeof(dash_pattern)/sizeof(dash_pattern[0]);
    [thePath setLineDash:dash_pattern count:count phase:0.];
    
}

@end
