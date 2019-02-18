//
//  NSShadow+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A category for adding functionality to the `NSShadow` class.
 */
@interface NSShadow (Additions)

/**
 * Initialize a new shadow with given color, offset and blur radius.
 *
 * @param color The color of the new shadow.
 * @param offset The offset of the new shadow.
 * @param blur The blur radius of the new shadow.
 */
- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur;

@end
