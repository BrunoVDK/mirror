//
//  RoundedImageCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "RoundedImageCell.h"

#pragma mark Rounded Image Cell

@implementation RoundedImageCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    CGFloat side = MIN(cellFrame.size.width / 3, cellFrame.size.height / 3);
    
    [NSGraphicsContext saveGraphicsState];
    
    [[NSGraphicsContext currentContext] setShouldAntialias:true];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect((cellFrame.size.width - side) / 2, (cellFrame.size.height - side) / 2, side, side)];
    [path addClip];
    
    [[self image] drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    [[NSColor blackColor] set];
    [path setFlatness:0.001];
    
    [path setLineWidth:2.0];
    [[NSColor lightGrayColor] set];
    [path stroke];
    
    [path setLineWidth:0.5];
    [[NSColor blackColor] set];
    [path stroke];
    
    [NSGraphicsContext restoreGraphicsState];
    
}

@end