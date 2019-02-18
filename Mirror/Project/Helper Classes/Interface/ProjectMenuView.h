//
//  ProjectMenuView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 17/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VerticallyCenteredTextFieldCell.h"

/**
 * The `ProjectMenuView` class customizes the default interface of the `NSTableView` class.
 */
@interface ProjectMenuView : NSTableView {
    
    NSTrackingArea *trackingArea;
    NSInteger _hoveredRow;
    NSGradient *gradient;
    
}

@property (nonatomic, readonly) NSInteger hoveredRow;

@end

/**
 * The `ProjectMenuHoverCell` class represents a cell in a `ProjectMenuView`. It deals with mouse-overs.
 */
@interface ProjectMenuHoverCell : NSButtonCell

@end
