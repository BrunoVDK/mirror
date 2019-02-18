//
//  ProjectOptionsWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "AnimatedPanelsWindowController.h"
#import "ProjectOptionsSavePresetSheetController.h"

#define OPTIONS [ProjectOptionsWindowController sharedOptions] // Convenience constant

@class Project, ProjectOptionsSavePresetSheetController;

/**
 * The `ProjectOptionsWindowController` class controls a window with project options.
 *  The window has panels through which the user can navigate, altering options of this instance's associated project
 *  (the interface elements are bound to this project's options dictionary).
 *
 * This class also takes care of the preset menu that is part of the 'File' menu. As the controller's project is set,
 *  the menu is updated accordingly (selecting the appropriate preset menu item). If the project's options dictionary changes,
 *  then the custom preset item is selected.
 *
 * Note that this class can only be instantiated once, the only instance being the singleton that can be accessed with +sharedOptions.
 *  The instance assumes that a preset menu is present in the main menu, under > File > Presets. This menu should be empty.
 */
@interface ProjectOptionsWindowController : AnimatedPanelsWindowController <ProjectOptionsSavePresetSheetDelegate> {
    
    Project *_project;
    ProjectOptionsSavePresetSheetController *savePresetSheetController;
    
}

/**
 * The project associated with this options window controller.
 */
@property (nonatomic, assign) Project *project;

/**
 * Get the global preset menu.
 *
 * @return An NSMenu instance representing the options menu of the application, or nil if there isn't any.
 */
+ (NSMenu *)presetMenu;

/**
 * Get the shared project options window controller.
 *
 * @return A singleton, this application's project options window controller.
 */
+ (id)sharedOptions;

/**
 * Update the status of all panels.
 *
 * @note This method disables options that can't be altered as a project's engine is running, or all options
 *        this controller's project is nil.
 */
- (void)updatePanels;

/**
 * Save the current options dictionary as a new preset.
 *
 * @param sender The object sending this message.
 * @note This method presents the user with a sheet in which he/she can enter the name of the new preset.
 *        Only alphanumerical characters are allowed.
 */
- (IBAction)savePreset:(id)sender;

/**
 * Revert to defaults options.
 *
 * @param sender The menu item sending this action.
 */
- (void)revertToDefaults:(NSMenuItem *)sender;

@end