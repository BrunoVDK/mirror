//
//  ProjectStatsWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "AnimatedPanelsWindowController.h"

#define STATISTICS [ProjectStatsWindowController sharedStatistics]

@class Project, ProjectStatsFilesPanelController, ProjectStatsOverviewPanelController;

/**
 * The `ProjectStatsWindowController` class controls a window with project statistics.
 *
 *  It presents a window with panels through which the user can navigate, displaying progress of its associated project.
 */
@interface ProjectStatsWindowController : AnimatedPanelsWindowController {
    
    Project *_project;
    ProjectStatsFilesPanelController *filesPanel;
    ProjectStatsOverviewPanelController *overviewPanel;
    
}

/**
 * The project associated with this statistics window controller.
 */
@property (nonatomic, assign) Project *project;

/**
 * Get the shared project statistics window controller.
 *
 * @return A singleton, this application's project statistics window controller.
 */
+ (id)sharedStatistics;

/**
 * Initialize a new project statistics window controller for the given project.
 *
 * @param project The project to associate the new window controller with.
 */
- (id)initWithProject:(Project *)project;

@end