//
//  ColoredView.h
//  Designing
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** 
 * The `ColoredView` class represents a view with an alterable background color.
 */
@interface ColoredView : NSView {
    
    NSColor *_color;
    
}

/**
 * This instance's background color.
 */
@property (nonatomic, copy) NSColor *color;

@end
