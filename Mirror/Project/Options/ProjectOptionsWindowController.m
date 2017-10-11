//
//  ProjectOptionsWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "PreferencesConstants.h" // To know what preferences key the presets are stored under
#import "ProjectOptionsDictionary.h"
#import "ProjectOptionsPanelController.h"
#import "ProjectOptionsWindowController.h"

#define PRESET_MENU [ProjectOptionsWindowController presetMenu] // For convenience/readability within this file
#define PRESET_IDENTIFIER [_project.options presetName]

#pragma mark Project Options Window Controller

@implementation ProjectOptionsWindowController

@synthesize project = _project;

#pragma mark Class Methods

+ (void)initialize {
    
    if (self == [ProjectOptionsWindowController self]) { // Prevent this from being run twice
        
        [ProjectOptionsWindowController reloadPresetMenu];
        
    }
    
}

+ (NSMenu *)presetMenu {
    
    static NSMenu *presetMenu = nil;
    
    if (!presetMenu) {
        
        NSMenuItem *projectItem = [[NSApp mainMenu] itemWithTitle:@"Project"];
        NSMenuItem *optionsItem = [projectItem.submenu itemWithTitle:@"Options"];
        presetMenu = optionsItem.submenu;
        
    }
    
    return presetMenu;
    
}

+ (void)reloadPresetMenu {
    
    NSMenu *presetMenu = PRESET_MENU;
    [presetMenu removeAllItems];
    
    NSArray *presetNames = [ProjectOptionsDictionary savedPresetNames]; // Autoreleased array
    presetNames = [presetNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; // Same
    for (NSUInteger presetIndex = [presetNames count] ; presetIndex > 0 ; presetIndex--) {
        NSString *presetName = [presetNames objectAtIndex:presetIndex - 1];
        [presetMenu insertItemWithTitle:presetName action:@selector(loadPreset:) keyEquivalent:@"" atIndex:0];
    }
    
    [presetMenu addItem:[NSMenuItem separatorItem]];
    [presetMenu addItemWithTitle:DefaultPresetName action:@selector(revertToDefaults:) keyEquivalent:@""];
    [presetMenu addItemWithTitle:CustomPresetName action:NULL keyEquivalent:@""];
    [presetMenu addItem:[NSMenuItem separatorItem]];
    [presetMenu addItemWithTitle:@"Save preset ..." action:@selector(savePreset:) keyEquivalent:@"s"];
    
}

+ (void)addPresetWithIdentifier:(NSString *)identifier {
    
    NSMenu *presetMenu = PRESET_MENU;
    NSArray *currentPresets = presetMenu.itemArray;
    
    NSInteger index = 0;
    while (index < currentPresets.count
           && [[[currentPresets objectAtIndex:index] title] localizedCaseInsensitiveCompare:identifier] == NSOrderedAscending
           && [(NSMenuItem *)[currentPresets objectAtIndex:index] action] == @selector(loadPreset:))
        index++;
    [presetMenu insertItemWithTitle:identifier action:@selector(loadPreset:) keyEquivalent:@"" atIndex:index];
    
}

+ (void)removePresetWithIdentifier:(NSString *)identifier {
    
    NSMenu *presetMenu = PRESET_MENU;
    [presetMenu removeItem:[presetMenu itemWithTitle:identifier]];
    
}

+ (id)sharedOptions { // Singleton
    
    static dispatch_once_t token = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&token, ^{
        _sharedObject = [self new];
    });
    
    return _sharedObject;
    
}

#pragma mark Constructors

- (id)init {
    
    static BOOL *singletonCreated = false;
    
    if (singletonCreated)
        return [ProjectOptionsWindowController sharedOptions]; // Ensure that only the shared options controller is used
    
    if (self = [super init]) {
        
        self.window.title = @"Project Options";
        
        NSArray *panels =  @[[[ProjectOptionsCrawlerPanelController new] autorelease],
                             [[ProjectOptionsBuildPanelController new] autorelease],
                             [[ProjectOptionsFiltersPanelController new] autorelease],
                             [[ProjectOptionsAppearancePanelController new] autorelease],
                             [[ProjectOptionsIdentityPanelController new] autorelease],
                             [[ProjectOptionsEnginePanelController new] autorelease]];
        [self setPanelControllers:panels];
        
        savePresetSheetController = [ProjectOptionsSavePresetSheetController new];
        savePresetSheetController.delegate = self;
        
        singletonCreated = true;
        
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                                  forKeyPath:[@"values." stringByAppendingString:PresetsPreferencesKey]
                                                                     options:NSKeyValueObservingOptionNew
                                                                     context:NULL];
        
    }
    
    return self;
    
}

#pragma mark Project

- (void)updatePanels {
    
    for (ProjectOptionsPanelController *panel in _panelControllers)
        [panel updatePanel];
    
}

- (void)setProject:(Project *)project {
    
    if (_project != project) {
        
        NSMenu *presetMenu = PRESET_MENU;
        if (_project)
            [[presetMenu itemWithTitle:PRESET_IDENTIFIER] setState:NSOffState];
        
        [NOTIFICATION_CENTER removeObserver:self name:ProjectOptionsDictionaryDidChange object:_project.options];
        [NOTIFICATION_CENTER removeObserver:self name:ProjectOptionsDictionaryWillChange object:_project.options];
        
        _project = project; // Assign
        
        if (project) {
            
            for (ProjectOptionsPanelController *panel in self.panelControllers)
                [panel setProject:project]; // Update panels
            
            NSMenuItem *newSelectedItem = [presetMenu itemWithTitle:PRESET_IDENTIFIER];
            if (!newSelectedItem)
                newSelectedItem = [presetMenu itemWithTitle:CustomPresetName];
            [newSelectedItem setState:NSOnState];
            
            [NOTIFICATION_CENTER addObserver:self selector:@selector(optionsDictionaryDidChange:) name:ProjectOptionsDictionaryDidChange object:project.options];
            [NOTIFICATION_CENTER addObserver:self selector:@selector(optionsDictionaryWillChange:) name:ProjectOptionsDictionaryWillChange object:project.options];
            
        }
        
        [self updatePanels];
        
    }
            
}

#pragma mark Presets

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // Presets dictionary changed
    
    if ([keyPath isEqualToString:[@"values." stringByAppendingString:PresetsPreferencesKey]]) {
        
        [ProjectOptionsWindowController reloadPresetMenu];
        [[PRESET_MENU itemWithTitle:PRESET_IDENTIFIER] setState:NSOnState];
        
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
        
    if (menuItem.action == @selector(savePreset:) && ![PRESET_IDENTIFIER isEqualToString:CustomPresetName])
        return false;
    
    return true;
    
}

- (IBAction)savePreset:(id)sender {
    
    if (!([self.project.options isCustom] && [PREFERENCES dictionaryForKey:PresetsPreferencesKey].allKeys.count < MAX_PRESETS))
        NSBeep(); // Either the options dictionary isn't custom or there are already too many presets in the user defaults
    else {
        
        Project *activeProject = self.project;
        
        [savePresetSheetController presentOnWindow:[self window] completionHandler:^(NSModalResponse response) {
            
            if (response == NSModalResponseOK) {
                
                NSString *presetName = [savePresetSheetController presetName];
                [ProjectOptionsWindowController addPresetWithIdentifier:presetName];
                
                NSString *error = nil;
                
                if (activeProject == self.project // The project could have changed while the preset saving sheet was shown
                    && [self.project.options saveAsPresetWithName:presetName error:&error]) {
                    NSMenu *presetMenu = PRESET_MENU;
                    [[presetMenu itemWithTitle:CustomPresetName] setState:NSOffState];
                    [[presetMenu itemWithTitle:presetName] setState:NSOnState];
                }
                                
            }
            
        }];
        
    }
    
}

- (void)loadPreset:(NSMenuItem *)sender {
    
    // Read preset with identifier equal to that of the menu item's
    
}

- (void)revertToDefaults:(NSMenuItem *)sender {
    
    if (self.project)
        ; // Propagate options
    
}

- (NSString *)projectOptionsSavePresetSheetController:(ProjectOptionsSavePresetSheetController *)controller errorForPresetName:(NSString *)presetName {
    
    NSString *error = nil;
    [self.project.options isValidPresetName:presetName error:&error];
    
    return error;
    
}

- (void)optionsDictionaryWillChange:(NSNotification *)notification {
    
    if (![self.project.options isCustom])
        [[PRESET_MENU itemWithTitle:PRESET_IDENTIFIER] setState:NSOffState];
    
}

- (void)optionsDictionaryDidChange:(NSNotification *)notification {
    
    [[PRESET_MENU itemWithTitle:PRESET_IDENTIFIER] setState:NSOnState];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    if (_project) {
        [NOTIFICATION_CENTER removeObserver:self name:ProjectOptionsDictionaryDidChange object:_project.options];
        [NOTIFICATION_CENTER removeObserver:self name:ProjectOptionsDictionaryWillChange object:_project.options];
    }
    
    [savePresetSheetController release];
    
    [super dealloc];
    
}

@end