//
//  NSColor+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 02/07/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `ColoredView` category alters the behaviour of the `NSColor` class.
 */
@interface NSColor (Additions)

/**
 * Returns a color that has a darkish gray tint.
 */
+ (NSColor *)darkerGrayColor;

@end
