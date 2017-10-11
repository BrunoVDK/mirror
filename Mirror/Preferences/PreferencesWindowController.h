//
//  PreferencesWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "AnimatedPanelsWindowController.h"

#pragma mark Preferences Window Controller

/**
 * The `PreferencesWindowController` class controls a window with application preferences.
 *
 *  It presents a window with panels through which the user can navigate, altering options of the application.
 */
@interface PreferencesWindowController : AnimatedPanelsWindowController

/**
 * Get the shared preferences window controller.
 *
 * @return A singleton, this application's preferences window controller.
 */
+ (id)sharedPreferences;

/**
 * Initialize the application preferences.
 */
- (void)initPreferences;

/**
 * Save the application preferences. Call this method when the app is about to close.
 */
- (void)savePreferences;

/**
 * Checks whether this preferences window controller's window is key.
 *
 * @return True if the preferences window is key.
 */
- (BOOL)windowIsKey;

@end