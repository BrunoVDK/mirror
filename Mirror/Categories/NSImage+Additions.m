//
//  NSImage+Additions.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSImage+Additions.h"

@implementation NSImage (Additions)

// From http://stackoverflow.com/questions/1413135/tinting-a-grayscale-nsimage-or-ciimage

- (NSImage *)copyWithTint:(NSColor *)tint {
    
    NSImage *image = [self copy];
    
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, [image size]};
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [image unlockFocus];
    }
    
    return image;
    
}

@end
