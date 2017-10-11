//
//  CapsuleSegmentedControl.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSBezierPath+Additions.h"
#import "CapsuleSegmentedControl.h"

#pragma mark Capsule Segmented Control

@implementation CapsuleSegmentedControl

@synthesize overrideDrawing = _overrideDrawing;

#pragma mark Interface

- (void)awakeFromNib {
    
    // Force the frame/bounds height to be 23
    // [self setBoundsSize:NSMakeSize([self bounds].size.width, 23)];
    // [self setFrameSize:NSMakeSize([self frame].size.width, 23)];
    [[self cell] setTrackingMode:NSSegmentSwitchTrackingSelectAny];
    [self setOverrideDrawing:true];

}

- (void)setOverrideDrawing:(BOOL)overrideDrawing {
    
    _overrideDrawing = overrideDrawing;
    [self setNeedsDisplay:true];
    
}

#pragma mark Position

- (BOOL)acceptsFirstResponder {
    
    return true;
    
}

#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
    
    if (!self.overrideDrawing) {
        [super drawRect:dirtyRect];
        return;
    }
    
    NSRect rect = [self bounds];
	rect.size.height -= 1;
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [self drawBackground:rect];
    [self drawSegments:rect];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
}

- (void)drawBackground:(NSRect)rect {
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect
                                                         xRadius:3.5
                                                         yRadius:3.5];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.75 alpha:1.0]
                                                         endingColor:[NSColor colorWithCalibratedWhite:.6 alpha:1.0]];
    NSColor *frameColor = [NSColor colorWithCalibratedWhite:.17 alpha:1.0];
    
    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowOffset:NSMakeSize(0, -1.0)];
    [dropShadow setShadowBlurRadius:1.0];
    [dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:.863 alpha:.75]];
	[dropShadow set];
	[path fill];
    
	[gradient drawInBezierPath:path angle:-90];
    
    [frameColor setStroke];
	[path strokeInside];
    [gradient release];
    [dropShadow release];
    
    
    
}

- (void)drawSegments:(NSRect)rect {
    
    float segmentWidth = rect.size.width / [self segmentCount];
    float segmentHeight = rect.size.height;
    NSRect segmentRect = NSMakeRect(0, 0, segmentWidth, segmentHeight);
    
    for (int segment=0 ; segment<[self segmentCount] ; segment++) {
        [self drawSegment:segment inFrame:segmentRect withView:self];
        segmentRect.origin.x += segmentWidth;
    }
    
}

- (void)drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView {
    
    if (![self isSelectedForSegment:segment]) {
        
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.68 alpha:1.0]
                                                             endingColor:[NSColor colorWithCalibratedWhite:.91 alpha:1.0]];
        NSColor *frameColor = [NSColor colorWithCalibratedWhite:.17 alpha:1.0];
        
        NSBezierPath *path;
        if (segment == 0 && [self segmentCount] > 1)
            path = [NSBezierPath bezierPathWithLeftRoundedRect:frame radius:3]; // (=
        else if (segment == [self segmentCount] - 1 && [self segmentCount] > 1)
            path = [NSBezierPath bezierPathWithRightRoundedRect:frame radius:3]; // =)
        else if (segment != 0 && segment != [self segmentCount] - 1 && [self segmentCount] > 2)
            path = [NSBezierPath bezierPathWithRect:frame]; // |=|
        else
            path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:3 yRadius:3]; // ()
        
        [gradient drawInBezierPath:path angle:-90];
        [frameColor setStroke];
        [path strokeInside];
        [gradient release];
        
    }
    
    NSImage *image = [self imageForSegment:segment];
    [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
    [self drawCenteredImage:image inFrame:frame enabled:[self isEnabledForSegment:segment]];
    
}

- (void)drawCenteredImage:(NSImage *)image inFrame:(NSRect)frame enabled:(BOOL)enabled {
        
    // This code is for achieving an 'edged' effect
    // http://stackoverflow.com/questions/7137705/how-to-draw-a-nsimage-like-images-in-nsbuttons-with-a-deepness
    NSButtonCell *buttonCell = [[NSButtonCell alloc] initImageCell:image];
    buttonCell.imageScaling = NSImageScaleProportionallyDown;
    buttonCell.bordered = false;
    buttonCell.bezelStyle =  NSTexturedRoundedBezelStyle;
    [buttonCell setEnabled:enabled];
    [buttonCell drawInteriorWithFrame:frame inView:self];
    [buttonCell release];
    
}

@end