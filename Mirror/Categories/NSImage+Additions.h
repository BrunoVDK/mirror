//
//  NSImage+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A category for adding functionality to the `NSImage` class.
 */
@interface NSImage (Additions)

/**
 * Returns a copy of this image, tinted with the given color.
 *
 * @param tint The color to tint with.
 * @return An appropriately tinted version of this image.
 */
- (NSImage *)copyWithTint:(NSColor *)tint;

@end
