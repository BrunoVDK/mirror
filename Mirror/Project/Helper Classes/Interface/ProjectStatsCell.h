//
//  ProjectStatsCell.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ProjectStatsCellBorder, ProjectURL;

/**
 * The `ProjectStatsCell` class represents a cell that can display the icon, title and statistics of a `ProjectURL`
 *  that a `Project` is supposed to mirror.
 */
@interface ProjectStatsCell : NSTextFieldCell <NSTextViewDelegate> {
    
    ProjectURL *_URL;
    BOOL _renderInCircles;
    NSString *_stats;
    NSColor *_color;
    ProjectStatsCellBorder *borderView;
    
}

/**
 * The `ProjectURL` associated with `ProjectStatsCell`.
 */
@property (nonatomic, assign) ProjectURL *URL;

/**
 * A flag denoting what color this cell uses for drawing a background while editing.
 */
@property (nonatomic, copy) NSColor *color;

/**
 * A flag denoting whether or not this cell displays the icon of a `ProjectURL` with a circular clip.
 */
@property (nonatomic, assign) BOOL renderInCircles;

/**
 * A custom string describing the associated URL status. This should be set by the cell's owner.
 */
@property (nonatomic, copy) NSString *stats;

@end
