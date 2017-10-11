//
//  TextView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSBezierPath+Additions.h"
#import "NSColor+Additions.h"
#import "TextView.h"

@implementation TextView

//
// NOTE :
//
//  From Apple Technical Support :
//
//  "NSTextFields and their counterpart NSTextFieldCell align their background areas to account for their focus frame,
//      even if the focus ring type is NSFocusRingTypeNone.  The cell-based APIs for NSTextFieldCell don’t offer the needed
//      hooks to affect the background’s frame, only the outer frame and selection frame.
//
//  If you want to eliminate the focus ring, and have it draw without the white frame around it, the only way is to
//      remove the background color and set “drawsBackground” to NO."
//
// NOTE 2 :
//
//  The code below has been moved to ProjectStatsCell.m, I left it here in case I need to remember what I tried to do.
//

- (void)drawRect:(NSRect)dirtyRect { // Draws over the white focus ring
        
    [super drawRect:dirtyRect];
    
    /*
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    if (dirtyRect.size.width < self.bounds.size.width)
        return; // Hackish solution to get rid of some whitening of characters by the code below
    
    [[self backgroundColor] setFill];
    
    NSRect outerRect = NSMakeRect(dirtyRect.origin.x - 3, dirtyRect.origin.y - 2, dirtyRect.size.width +  6, dirtyRect.size.height + 4);
    NSRect innerRect = NSInsetRect(outerRect, 3, 2);
    
    // CGContextRef contextRef = [[NSGraphicsContext currentContext] graphicsPort];
    // CGRect clip = CGContextGetClipBoundingBox(contextRef);
    // LOG_RECT(NSRectFromCGRect(clip));
    
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:outerRect];
    [clipPath appendBezierPathWithRect:innerRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    // The following is warned against by Apple, the effect is that the clipping bounding box goes beyond the bounds of this view,
    //  which makes it possible to draw over the strange white border (whose nature I don't grasp yet)
    [clipPath setClip];
    NSRectFill(outerRect);
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
     */
    
}

@end
