//
//  ListView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 01/07/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `ListView` class customizes the default interface of the `NSTableView` class.
 */
@interface ListView : NSTableView {
    
    BOOL _odd; // Flag denoting whether the alternate color is used on even or odd rows
    NSColor *_alternateColor;
    
}

/**
 * A flag denoting what color this table view uses as alternate row background color.
 */
@property (nonatomic, copy) NSColor *alternateColor;

/**
 * A flag denoting whether or not this table view uses the alternate color for odd rows.
 */
@property (nonatomic, readonly) BOOL odd;

/**
 * Reload the visible portion of this table view.
 */
- (void)reloadVisibleRect;

@end
