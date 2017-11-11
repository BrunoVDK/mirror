//
//  ProjectOptionsPanelController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AnimatedPanelControllerProtocol.h"
#import "Project.h"

#pragma mark Project Options Panel Controller

/**
 * The `ProjectOptionsPanelController` class represents a panel of a project options window. It is an abstract class.
 */
@interface ProjectOptionsPanelController : NSViewController <AnimatedPanelControllerProtocol> {
    
    Project *_project;
    
}

/**
 * This panel controller's window controller.
 */
@property (nonatomic, assign) Project *project;

/**
 * Update the panel's controls, disabling them if this panel's project is nil or if this panel's project
 *  has started and the control's associated option can be altered when the engine is running.
 */
- (void)updatePanel;

@end

/**
 * The `ProjectOptionsLabel` class represents a text field in a project options panel. It can be en/disabled.
 */
@interface ProjectOptionsLabel : NSTextField

/**
 * Enable or disable this label. This method changes the text color of the label.
 *
 * @param flag True if this label should be enabled. False if it should be disabled.
 */
- (void)setEnabled:(BOOL)flag;

@end

#pragma mark - Custom Project Options Panel Controllers

/**
 * The `ProjectOptionsBuildPanelController` class controls a project options panel with build options.
 */
@interface ProjectOptionsBuildPanelController : ProjectOptionsPanelController

@end

/**
 * The `ProjectOptionsCrawlerPanelController` class controls a project options panel with spider options.
 */
@interface ProjectOptionsCrawlerPanelController : ProjectOptionsPanelController <NSOutlineViewDataSource, NSOutlineViewDelegate> {
    
    NSOutlineView *_outlineView;
    
}

/**
 * The outline view for this crawler options panel.
 */
@property (nonatomic, retain) IBOutlet NSOutlineView *outlineView;

@end

/**
 * The `ProjectOptionsAppearancePanelController` class controls a project options panel with appearance options.
 */
@interface ProjectOptionsAppearancePanelController : ProjectOptionsPanelController

@end

/**
 * The `ProjectOptionsFiltersPanelController` class controls a project options panel with filtering options.
 */
@interface ProjectOptionsFiltersPanelController : ProjectOptionsPanelController {
    
    NSTableView *_filterListView;
    NSButton *_includeImagesButton, *_includeAudioButton, *_includeArchivesButton, *_includeVideoButton;
    NSPopUpButton *_addFilterMenu;
    NSTextField *_addFilterField;
    
}

@end

/**
 * The `ProjectOptionsIdentityPanelController` class controls a project options panel with identity options.
 */
@interface ProjectOptionsIdentityPanelController : ProjectOptionsPanelController {
    
    IBOutlet NSTextField *usernameField, *passwordField;
    
}
@end

/**
 * The `ProjectOptionsEnginePanelController` class controls a project options panel with engine options.
 */
@interface ProjectOptionsEnginePanelController : ProjectOptionsPanelController

@end

/**
 * The `ProjectOptionsNetworkPanelController` class controls a project options panel with download options.
 */
@interface ProjectOptionsNetworkPanelController : ProjectOptionsPanelController

@end

/**
 * The `ProjectOptionsProxyPanelController` class controls a project options panel with proxy options.
 */
/*
@interface ProjectOptionsProxyPanelController : ProjectOptionsPanelController

@end
*/