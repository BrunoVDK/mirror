//
//  PreferencesPanelController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 30/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PreferencesWindowController.h"

#pragma mark Project Options Panel Controller

/**
 * The `PreferencesPanelController` class represents a panel of a preferences window. It is an abstract class.
 */
@interface PreferencesPanelController : NSViewController <AnimatedPanelControllerProtocol>

@end

#pragma mark - Custom Preferences Panel Controllers

/**
 * The `PreferencesGeneralPanelController` class controls the general preferences panel of this application.
 */
@interface PreferencesGeneralPanelController : PreferencesPanelController

@end

/**
 * The `PreferencesDownloadsPanelController` class controls the download preferences panel of this application.
 */
@interface PreferencesDownloadsPanelController : PreferencesPanelController

@end

/**
 * The `PreferencesInterfacePanelController` class controls the interface preferences panel of this application.
 */
@interface PreferencesInterfacePanelController : PreferencesPanelController

@end

/**
 * The `PreferencesNotificationsPanelController` class controls the notification preferences panel of this application.
 */
@interface PreferencesNotificationsPanelController : PreferencesPanelController

@end

/**
 * The `PreferencesPresetsPanelController` class controls the preset preferences panel of this application.
 */
@interface PreferencesPresetsPanelController : PreferencesPanelController <NSTableViewDataSource, NSTableViewDelegate> {
    
    NSMutableArray *presets;
    
    IBOutlet NSTableView *presetsListView;
    IBOutlet NSPopUpButton *defaultPresetMenu;
    IBOutlet NSButton *removeSelectedButton, *removeAllButton;
    
}

@end