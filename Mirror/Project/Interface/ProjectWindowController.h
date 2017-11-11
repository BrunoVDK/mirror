//
//  ProjectWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/10/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ProjectOptionsWindowController.h"

@class BadgeView, Project, ProjectURL, ProjectOptionsWindowController, ProjectSavePresetSheetController;

/**
 * The `ProjectWindowController` class represents a project window controller.
 *
 *  This abstract class is meant to be subclassed for the implementation of various 
 *   designs/functionalities in particular OSs or versions of the app.
 *  It does implement the interactions with the associated options/statistics panel and other basic functionalities of a project window.
 */
@interface ProjectWindowController : NSWindowController<NSWindowDelegate, ProjectDelegate> {
    
    BOOL _renderInCircles;
    NSButton *_toolbarOptionsButton, *_toolbarSearchButton, *_toolbarStatsButton;
    
}

/**
 * Determines whether or not URL icons are clipped in a circle.
 */
@property (nonatomic) BOOL renderInCircles;

/**
 * The property associated with this project window controller.
 */
@property (nonatomic, readonly) Project *project;

/**
 * Update the project URL at the given index listed in the window.
 *
 * @param index The index of the project link to update.
 */
- (void)updateURLAtIndex:(NSInteger)index;

/**
 * Update all project URLs.
 */
- (void)updateAllURLs;

/**
 * Update the window's interface (eg. when a project ends mirroring).
 */
- (void)updateInterface;

/**
 * Update the status.
 */
- (void)updateStatus;

/**
 * Show the options panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)showOptions:(id)sender;

/**
 * Hide the options panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)hideOptions:(id)sender;

/**
 * Show the statistics panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)showStatistics:(id)sender;

/**
 * Hide the statistics panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)hideStatistics:(id)sender;

/**
 * Show the notifications panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)showNotifications:(id)sender;

/**
 * Hide the notifications panel.
 *
 * @param sender The action's sender.
 */
- (IBAction)hideNotifications:(id)sender;

/**
 * Toggle the filtering field on/off.
 *
 * @param sender The action's sender.
 */
- (IBAction)toggleSearch:(id)sender;

/**
 * Show a view where a user can add project URLs.
 *
 * @param sender The action's sender.
 */
- (IBAction)addURL:(id)sender;

/**
 * Show the filtering field.
 *
 * @param sender The action's sender.
 */
- (IBAction)showSearch:(id)sender;

/**
 * Hide the filtering field.
 *
 * @param sender The action's sender.
 */
- (IBAction)hideSearch:(id)sender;

/**
 * Request an export directory to the user.
 *
 * @param completion A block to run after completing the request.
 */
- (void)requestExportDirectory:(void(^)(BOOL success))completion;

/**
 * Restore the interface of the given controller.
 *
 * @param controller The controller whose interface is to be adopted by the current one.
 */
- (void)restoreInterface:(ProjectWindowController *)controller;

@end

//
//  OS-specific Project Window Controllers
//

@class CapsuleSegmentedControl, ColoredView, FilterField, ProjectListView, SplitView, TextView;

/**
 * The `ProjectWindowControllerLion` class is a subclass of `ProjectWindowController`, adding functionalities for OS X < 10.10.
 */
@interface ProjectWindowControllerLion : ProjectWindowController<NSOutlineViewDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    
    ProjectURL *dummy; // A dummy shown in the list of project URLs
    NSString *dummyStats; // The stats string of the dummy URL
    
    BOOL showDummy; // Flag denoting whether or not the dummy are visible
    
    NSTextView *textView;
    NSText *searchTextView;
    
    NSColor *alternateRowColor;
    
    NSTimer *statsTimer;
    NSMutableIndexSet *statsIndices;
    
    NSString *errorMessage;
    
    // Outlets
    NSArrayController *_projectListController;
    ProjectListView *_listView;
    NSSearchField *_searchField;
    NSTextField *_statusField;
    SplitView *_windowSplitView, *_controllerSplitView, *_projectSplitView, *_searchSplitView;
    CapsuleSegmentedControl *_toolbarAddPauseButton;
    ColoredView *_searchView;
    
}

@end

@class HeaderView, ProjectMenuView, PieGraphView;

/**
 * The `ProjectWindowControllerYosemite` class is a subclass of `ProjectWindowControllerLion`, adding functionalities for OS X Yosemite in particular.
 */
@interface ProjectWindowControllerYosemite : ProjectWindowControllerLion {
    
    WindowTheme theme;
    HeaderView *headerView;
    
    NSMenu *_contextualMenu, *_filesMenu;
    ProjectMenuView *_menuView;
    NSOutlineView *_statsOutlineView;
    NSTableView *_fileListView;
    NSTextField *_speedStatField, *_sizeStatField, *_filesStatusField;
    NSSearchField *_filesSearchField;
    NSView *_panelView, *_linksPanel, *_statsPanel, *_filesPanel;
    
}

/**
 * Show the controller's contextual menu.
 *
 * @param sender The object sending this message.
 */
- (IBAction)showContextualMenu:(id)sender;

@end

//
//  Project Window (generic)
//

/**
 * The `ProjectWindow` class represents a generic project window.
 */
@interface ProjectWindow : NSWindow<NSWindowDelegate>

@end
