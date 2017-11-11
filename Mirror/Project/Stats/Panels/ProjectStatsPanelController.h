//
//  ProjectStatsPanelController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AnimatedPanelControllerProtocol.h"

@class Project;

#pragma mark Project Stats Panel Controller

/**
 * The `ProjectStatsPanelController` class controls a panel of a project statistics window.
 *
 *  This is an abstract class.
 */
@interface ProjectStatsPanelController : NSViewController <AnimatedPanelControllerProtocol> {
    
    Project *_project;
    
}

/**
 * This panel's window controller.
 */
@property (nonatomic, assign) Project *project;

@end

#pragma mark - Custom Project Stats Panel Controllers

/**
 * The `ProjectStatsFilesPanelController` class controls a project statistics panel presenting files that are downloading/downloaded.
 */
@interface ProjectStatsFilesPanelController : ProjectStatsPanelController

@end

/**
 * The `ProjectStatsOverviewPanelController` class controls a project statistics panel presenting notifications.
 */
@interface ProjectStatsOverviewPanelController : ProjectStatsPanelController {
    
    NSOutlineView *_outlineView;
    
}

/**
 * The outlineview for this stats panel controller.
 */
@property (nonatomic, retain) IBOutlet NSOutlineView *outlineView;

@end