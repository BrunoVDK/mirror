//
//  WindowAdaptedCell.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/02/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A `WindowAdaptedCell` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedCell : NSCell

@end

#import "UnhighlightedTableView.h"
#import "VerticallyCenteredTextFieldCell.h"

/**
 * A `WindowAdaptedTextFieldCell` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedTextFieldCell : VerticallyCenteredTextFieldCell

@end

/**
 * A `WindowAdaptedImageCell` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedImageCell : NSImageCell

@end

/**
 * A `WindowAdaptedButtonCell` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedButtonCell : NSButtonCell

@end

/**
 * A `WindowAdaptedTableHeaderCell` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedTableHeaderCell : NSTableHeaderCell

@end

/**
 * A `WindowAdaptedTableView` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedTableView : UnhighlightedTableView

@end

/**
 * A `WindowAdaptedOutlineView` adapts its design to the state of the parent window.
 */
@interface WindowAdaptedOutlineView : NSOutlineView

@end
