//
//  NSBezierPath+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A category for adding functionality to the `NSBezierPath` class.
 */
@interface NSBezierPath (Additions)

/**
 * Create a path using the given graphics path.
 *
 * @param pathRef The graphics path to transform.
 * @return A new bezier path based on the given path.
 */
+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef;

/**
 * Creates a new CGPath by transforming this bezier path into a graphics path.
 *
 * @return A new graphics path based on this bezier path.
 */
- (CGPathRef)createCGPath;

/**
 * Create a new bezier path within the given rectangle. The new path is a half-rounded rectangle,
 *  its left corners are both rounded.
 *
 * @param rect The rect to draw the new path in.
 * @param radius The radius of the new path's rounded corners.
 * @return A new bezier path in the form of a half-rounded rect (rounded on the left).
 */
+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(float)radius;

/**
 * Create a new bezier path within the given rectangle. The new path is a half-rounded rectangle,
 *  its right corners are both rounded.
 *
 * @param rect The rect to draw the new path in.
 * @param radius The radius of the new path's rounded corners.
 * @return A new bezier path in the form of a half-rounded rect (rounded on the right).
 */
+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(float)radius;

/**
 * Stroke inside this bezier path.
 */
- (void)strokeInside;

@end
