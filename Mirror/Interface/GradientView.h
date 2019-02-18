//
//  GradientView.h
//  Designing
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `GradientView` class represents a view with an alterable background gradient.
 */
@interface GradientView : NSView {
    
    NSGradient *_gradient;
    
}

/**
 * This instance's background gradient.
 */
@property (nonatomic, copy) NSGradient *gradient;

/**
 * Returns the default gradient of gradient views.
 * 
 * @return The default gradient used by gradient views before any custom gradient is set.
 */
+ (NSGradient *)defaultGradient;

/**
 * Returns the secondary gradient of gradient views.
 *
 * @return The secondary gradient used by gradient views, used when the parent window is not key.
 */
+ (NSGradient *)secondaryGradient;

@end
