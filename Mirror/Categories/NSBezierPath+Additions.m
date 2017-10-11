//
//  NSBezierPath+Additions.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSBezierPath+Additions.h"

static void CGPathCallback(void *info, const CGPathElement *element) {
    
	NSBezierPath *path = info;
	CGPoint *points = element->points;
	
	switch (element->type) {
		case kCGPathElementMoveToPoint:
			[path moveToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		case kCGPathElementAddLineToPoint:
			[path lineToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		case kCGPathElementAddQuadCurveToPoint: {
			// NOTE: This is untested.
			NSPoint currentPoint = [path currentPoint];
			NSPoint interpolatedPoint = NSMakePoint((currentPoint.x + 2*points[0].x) / 3, (currentPoint.y + 2*points[0].y) / 3);
			[path curveToPoint:NSMakePoint(points[1].x, points[1].y) controlPoint1:interpolatedPoint controlPoint2:interpolatedPoint];
			break;
        }
		case kCGPathElementAddCurveToPoint:
			[path curveToPoint:NSMakePoint(points[2].x, points[2].y) controlPoint1:NSMakePoint(points[0].x, points[0].y) controlPoint2:NSMakePoint(points[1].x, points[1].y)];
			break;
		case kCGPathElementCloseSubpath:
			[path closePath];
			break;
	}
    
}

@implementation NSBezierPath (Additions)

+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef {
    
	NSBezierPath *path = [NSBezierPath bezierPath];
	CGPathApply(pathRef, path, CGPathCallback);
	
	return path;
    
}

- (CGPathRef)createCGPath {
    
	CGMutablePathRef thePath = CGPathCreateMutable();
	if (!thePath) return nil;
	
	unsigned int elementCount = (unsigned int)[self elementCount];
	
	// The maximum number of points is 3 for a NSCurveToBezierPathElement.
	// (controlPoint1, controlPoint2, and endPoint)
	NSPoint controlPoints[3];
	
	for (unsigned int i = 0; i < elementCount; i++) {
		switch ([self elementAtIndex:i associatedPoints:controlPoints]) {
			case NSMoveToBezierPathElement:
				CGPathMoveToPoint(thePath, &CGAffineTransformIdentity, 
								  controlPoints[0].x, controlPoints[0].y);
				break;
			case NSLineToBezierPathElement:
				CGPathAddLineToPoint(thePath, &CGAffineTransformIdentity, 
									 controlPoints[0].x, controlPoints[0].y);
				break;
			case NSCurveToBezierPathElement:
				CGPathAddCurveToPoint(thePath, &CGAffineTransformIdentity, 
									  controlPoints[0].x, controlPoints[0].y,
									  controlPoints[1].x, controlPoints[1].y,
									  controlPoints[2].x, controlPoints[2].y);
				break;
			case NSClosePathBezierPathElement:
				CGPathCloseSubpath(thePath);
				break;
			default:
				NSLog(@"Unknown element at [NSBezierPath (GTMBezierPathCGPathAdditions) cgPath]");
				break;
		};
	}
    
	return thePath;
    
}

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(float)radius {
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    radius = MIN(radius, 0.5f * MIN(NSWidth(rect), NSHeight(rect)));
    NSRect innerRect = NSInsetRect(rect, radius, radius);
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect), NSMinY(innerRect))
                                     radius:radius
                                 startAngle:180
                                   endAngle:270];
    
    [path lineToPoint:NSMakePoint(NSMinX(rect) + NSWidth(rect), NSMinY(rect))];
    [path lineToPoint:NSMakePoint(NSMinX(rect) + NSWidth(rect), NSMaxY(rect))];
    [path lineToPoint:NSMakePoint(NSMinX(innerRect), NSMaxY(rect))];
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect), NSMinY(innerRect) + NSHeight(innerRect))
                                     radius:radius
                                 startAngle:90
                                   endAngle:180];
    
    [path closePath];
    
    return path;
    
}

+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(float)radius {
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    radius = MIN(radius, 0.5f * MIN(NSWidth(rect), NSHeight(rect)));
    NSRect innerRect = NSInsetRect(rect, radius, radius);
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect) + NSWidth(innerRect), NSMinY(innerRect))
                                     radius:radius
                                 startAngle:270
                                   endAngle:360];
    
    [path lineToPoint:NSMakePoint(NSMinX(rect) + NSWidth(rect), NSMinY(innerRect) + NSHeight(innerRect))];
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect) + NSWidth(innerRect), NSMinY(innerRect) + NSHeight(innerRect))
                                     radius:radius
                                 startAngle:360
                                   endAngle:90];
    
    [path lineToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect) + NSHeight(rect))];
    [path lineToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect))];
    
    [path closePath];
    
    return path;
    
}

- (void)strokeInside {
    
    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];
    
    [thisContext saveGraphicsState];
    
    [self setLineWidth:(lineWidth * 1.0)];
    [self setClip];
    
    if (NSZeroRect.size.width > 0.0 && NSZeroRect.size.height > 0.0) {
        [NSBezierPath clipRect:NSZeroRect];
    }
    
    [self stroke];
    
    [thisContext restoreGraphicsState];
    [self setLineWidth:lineWidth];
    
}

@end
