//
//  TexturedSegmentedControl.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `CapsuleSegmentedControl` class represents a capsule segmented control.
 *  Unlike the usual capsule control it is compatible with Snow Leopard.
 */
@interface CapsuleSegmentedControl : NSSegmentedControl <NSAnimationDelegate> {
    
    BOOL _overrideDrawing;
    
}

/**
 * A flag denoting whether or not this segmented control overrides its superclass's drawing.
 *  If not, then this subclass basically does nothing at all.
 */
@property (nonatomic) BOOL overrideDrawing;

@end