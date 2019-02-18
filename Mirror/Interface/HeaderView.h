//
//  HeaderView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 10/02/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A `HeaderView` is a custom subclass of the `NSTableHeaderView` with some minor adaptations, such as the ability to disable clicks.
 */
@interface HeaderView : NSTableHeaderView {
    
    BOOL _clickable;
    
}

@property (nonatomic, readwrite, getter=isClickable) BOOL clickable;

@end
