//
//  ProjectNotificationsWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NOTIFICATIONS [ProjectNotificationsWindowController sharedNotifations]

@class Project;

/**
 * A `ProjectNotificationsWindowController` controls a panel for displaying a project's notifications.
 */
@interface ProjectNotificationsWindowController : NSWindowController {
    
    Project *_project;
    NSTableView *_tableView;
    
}

/**
 * The project associated with this notifications window controller.
 */
@property (nonatomic, assign) Project *project;

/**
 * The table view for this notifications window controller.
 */
@property (nonatomic, retain) IBOutlet NSTableView *tableView;

/**
 * Get the shared project notifications window controller.
 *
 * @return A singleton, this application's project notifications window controller.
 */
+ (id)sharedNotifations;

/**
 * Copy the description of the notification in the selected row.
 *
 * @param sender The object sending this message.
 */
- (IBAction)copy:(id)sender;

@end
