//
//  PreferencesPanelController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 30/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "ProjectOptionsDictionary.h"
#import "PreferencesConstants.h"
#import "PreferencesPanelController.h"

#pragma mark Preferences Panel Controller

@implementation PreferencesPanelController

- (instancetype)init {
    
    return [super initWithNibName:self.nibName bundle:nil];
    
}

- (NSString *)nibName {
    
    return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
    
}

- (NSString *)panelIdentifier {
    
    return [self.nibName stringByAppendingString:@"Identifier"];
}

- (NSString *)panelTitle {
    
    NSString *title = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"PanelController" withString:@""];
    return [title stringByReplacingOccurrencesOfString:@"Preferences" withString:@""];
    
}

- (NSImage *)panelIcon {
    
    return nil;
    
}

@end

#pragma mark - Custom Preferences Panels

@implementation PreferencesGeneralPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
    
}

@end

@implementation PreferencesDownloadsPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Download"];
    
}

@end

@implementation PreferencesInterfacePanelController

- (NSString *)nibName {
    
    return [[super nibName] stringByAppendingString:(IS_PRE_YOSEMITE ? @"" : @"Yosemite")];
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNameColorPanel];
    
}

@end

@implementation PreferencesNotificationsPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Notifications"];
    
}

@end

@implementation PreferencesPresetsPanelController

- (instancetype)init {
    
    if (self = [super init]) {
        
        presets = [[[PREFERENCES dictionaryForKey:PresetsPreferencesKey] allKeys] mutableCopy];
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                                  forKeyPath:[@"values." stringByAppendingString:PresetsPreferencesKey]
                                                                     options:NSKeyValueObservingOptionNew
                                                                     context:NULL];
        
    }
    
    return self;
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Presets"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:[@"values." stringByAppendingString:PresetsPreferencesKey]]) {
        
        [presets release];
        presets = [[[PREFERENCES dictionaryForKey:PresetsPreferencesKey] allKeys] mutableCopy];
        
        [presetsListView reloadData];
        [self populatePresetMenu];
        
    }
    
}

- (void)loadView {
    
    [super loadView];
    
    [self populatePresetMenu];
    
}

- (void)populatePresetMenu {
    
    NSUserDefaults *defaults = PREFERENCES;
    
    [defaultPresetMenu removeAllItems];
    
    for (NSString *presetName in presets)
        [defaultPresetMenu addItemWithTitle:presetName];
    
    NSString *defaultPreset = [defaults stringForKey:PresetsPreferencesKey];
    if (!defaultPreset || ![defaultPresetMenu itemWithTitle:defaultPreset])
        defaultPreset = @"AYAYAYAYA";
    
    [defaultPresetMenu selectItemWithTitle:defaultPreset];
    
}

#pragma mark Table View Data Source & Delegation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [presets count];
    
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return [presets objectAtIndex:row];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    // One could disable the deletion of any active presets here, but it's better if every project remembers its own preset name and options
    
}

#pragma mark Actions

- (IBAction)selectDefault:(id)sender {
    
    [PREFERENCES setObject:[[defaultPresetMenu selectedItem] title] forKey:PresetsPreferencesKey];
    
}

- (IBAction)removeSelected:(NSButton *)sender {
    
    NSMutableDictionary *presetsDictionary = [[PREFERENCES objectForKey:PresetsPreferencesKey] mutableCopy];
    
    NSIndexSet *selectedIndexes = [presetsListView selectedRowIndexes];
    
    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [presetsDictionary removeObjectForKey:[presets objectAtIndex:idx]];
    }];
    
    [presets removeObjectsAtIndexes:selectedIndexes];
    
    [PREFERENCES setObject:presetsDictionary forKey:PresetsPreferencesKey];
    [presetsDictionary release];
    
    [presetsListView reloadData];
    [self populatePresetMenu];
    
}

- (IBAction)removeAll:(NSButton *)sender {
    
    NSMutableDictionary *presetsDictionary = [NSMutableDictionary new];
    [PREFERENCES setObject:presetsDictionary forKey:PresetsPreferencesKey];
    [presetsDictionary release];
    
    [presets removeAllObjects];
    
    [presetsListView reloadData];
    [self populatePresetMenu];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:[@"values." stringByAppendingString:PresetsPreferencesKey]];
    
    [presets release];
    [presetsListView release];
    [defaultPresetMenu release];
    [removeSelectedButton release];
    [removeAllButton release];
    
    [super dealloc];
    
}

@end