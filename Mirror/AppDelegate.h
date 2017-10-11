//
//  AppDelegate.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "BadgeView.h"
#import "Project.h"

@class AboutWindowController;

/**
 * The `AppDelegate` class represents a delegate for this mirroring application.
 *
 *  It handles basic actions of the main menu (showing preferences as well as the about window, opening documents, ...).
 */
@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    BOOL terminationRequested;
    BadgeView *badgeView;
    
}

/**
 * Show the application about window.
 *
 * @param sender The object calling this method.
 */
- (IBAction)showAboutWindow:(id)sender;

/**
 * Show the application preferences panel.
 *
 * @param sender The object calling this method.
 */
- (IBAction)showPreferences:(id)sender;

/**
 * Try and quit the application.
 * 
 * This method attempts to quit the app, first asking its project controller to terminate all running projects.
 *
 * @param sender The object calling this method.
 */
- (IBAction)handleQuit:(id)sender;

@end
