//
//  ProjectOptionsPanelController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "ProjectOptionsDictionary.h"
#import "ProjectOptionsPanelController.h"
#import "ProjectOptionsWindowController.h"

#pragma mark Project Options Panel Controller

@implementation ProjectOptionsPanelController

@synthesize project = _project;

#pragma mark Initialization

- (instancetype)init {
    
    return [super initWithNibName:self.nibName bundle:nil];
    
}

- (NSString *)nibName {
    
    return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
    
}

- (NSString *)label {
    
    NSString *label = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"PanelController" withString:@""];
    return [label stringByReplacingOccurrencesOfString:@"ProjectOptions" withString:@""];
    
}

#pragma mark Animated Panel Controller Protocol

- (NSString *)panelIdentifier {
    
    NSString *label = self.label;
    if (label.length < 6)
        return [self.nibName stringByAppendingString:@"Identifier"];
    
    return label;
    
}

- (NSString *)panelTitle {
    
    return self.label; // [NSString stringWithFormat:@" %@ ", self.label];
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:self.label];
    
}

#pragma mark Interface

- (void)updatePanel {
    
    BOOL hasProject = (self.project != nil);
    BOOL projectStarted = (hasProject ? self.project.hasStarted : false);
    
    for (id subview in [[self view] subviews]) {
        
        BOOL canChangeOptionAfterProjectStarted = false;
        NSDictionary *bindingInfo = [self infoForBinding:NSValueBinding];
        if (!bindingInfo)
            bindingInfo = [subview infoForBinding:NSSelectedIndexBinding];
        if (bindingInfo) {
            NSString *optionsKey = [[bindingInfo valueForKey:NSObservedKeyPathKey] substringFromIndex:16]; // 16 stands for length of prefix 'self.controller.'
            if (optionsKey)
                canChangeOptionAfterProjectStarted = [ProjectOptionsDictionary optionCanBeAltered:optionsKey];
        }
        
        if ([subview respondsToSelector:@selector(setEnabled:)]
            && (!hasProject || (projectStarted && canChangeOptionAfterProjectStarted)))
            [subview setEnabled:false];
        
    }
    
}

@end

#pragma mark - Custom Panel Controls

#import "NSColor+Additions.h"

@implementation ProjectOptionsLabel

- (void)setEnabled:(BOOL)flag {
    
    if (flag)
        [self setTextColor:[NSColor darkerGrayColor]];
    else
        [self setTextColor:[NSColor disabledControlTextColor]];
    
}

@end

#pragma mark - Custom Project Options Panel Controllers

@implementation ProjectOptionsBuildPanelController

- (NSString *)panelTitle {
    
    return @" Structure ";
    
}

@end

@implementation ProjectOptionsCrawlerPanelController

- (NSString *)panelTitle {
    
    return @" General ";
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
    
}

@end

#define IMAGE_EXCLUSION_RULES @[@"-*.gif",@"-*.jpg",@"-*.jpeg",@"-*.png",@"-*.tif",@"-*.bmp"]
#define IMAGE_INCLUSION_RULES @[@"+*.gif",@"+*.jpg",@"+*.jpeg",@"+*.png",@"+*.tif",@"+*.bmp"]

#define AUDIO_EXCLUSION_RULES @[@"-*.mp3",@"-*.mp2",@"-*.wav",@"-*.ac3",@"-*.wma"]
#define AUDIO_INCLUSION_RULES @[@"+*.mp3",@"+*.mp2",@"+*.wav",@"+*.ac3",@"+*.wma"]

#define ARCHIVES_EXCLUSION_RULES @[@"-*.zip",@"-*.tar",@"-*.tgz",@"-*.gz",@"-*.rar",@"-*.z",@"-*.exe"]
#define ARCHIVES_INCLUSION_RULES @[@"+*.zip",@"+*.tar",@"+*.tgz",@"+*.gz",@"+*.rar",@"+*.z",@"+*.exe"]

#define VIDEO_EXCLUSION_RULES @[@"-*.mov",@"-*.mpg",@"-*.mpeg",@"-*.avi",@"-*.asf",@"-*.wmv",@"-*.rm",@"-*.vob",@"-*.qt",@"-*.vid"]
#define VIDEO_INCLUSION_RULES @[@"+*.mov",@"+*.mpg",@"+*.mpeg",@"+*.avi",@"+*.asf",@"+*.wmv",@"+*.rm",@"+*.vob",@"+*.qt",@"+*.vid"]

@implementation ProjectOptionsFiltersPanelController

- (void)updatePanel {
    
    [super updatePanel];
    
    [self updateInclusionButtons];
    
}

- (NSString *)panelTitle {
    
    return @" Rules ";
    
}

#pragma mark Actions

- (IBAction)removeSelected:(NSButton *)sender {
    
    [self.project removeFiltersAtIndexes:[filterListView selectedRowIndexes]];
    [self updateInclusionButtons];
    
}

- (IBAction)removeAll:(NSButton *)sender {
    
    [self.project removeAllFilters];
    [self updateInclusionButtons];
    
}

- (IBAction)include:(NSButton *)sender {
    
    NSString *input = [self currentInputRule];
    if (input) {
        
        NSString *excludeRule = [NSString stringWithFormat:@"-%@", input];
        [self.project removeFilter:excludeRule];
        
        NSString *includeRule = [NSString stringWithFormat:@"+%@", input];
        [self.project addFilter:includeRule];
        
    }
    
    [self updateInclusionButtons];
    
    [filterListView scrollRowToVisible:filterListView.numberOfRows - 1];
    
}

- (IBAction)exclude:(NSButton *)sender {
    
    NSString *input = [self currentInputRule];
    if (input) {
        
        NSString *includeRule = [NSString stringWithFormat:@"+%@", input];
        [self.project removeFilter:includeRule];
        
        NSString *excludeRule = [NSString stringWithFormat:@"-%@", input];
        [self.project addFilter:excludeRule];
        
    }
    
    [self updateInclusionButtons];
    
}

- (IBAction)includeImages:(NSButton *)checkbox {
    
    NSArray *imageExclusionRules = IMAGE_EXCLUSION_RULES;
    NSArray *imageInclusionRules = IMAGE_INCLUSION_RULES;
    
    if ([checkbox state] == NSOnState) {
        [self.project removeFilters:imageExclusionRules];
        [self.project addFilters:imageInclusionRules];
    }
    else
        [self.project removeFilters:imageInclusionRules];
    
    [filterListView scrollRowToVisible:filterListView.numberOfRows - 1];
    
}

- (IBAction)includeAudio:(NSButton *)checkbox {
    
    NSArray *audioExclusionRules = AUDIO_EXCLUSION_RULES;
    NSArray *audioInclusionRules = AUDIO_INCLUSION_RULES;
    
    if ([checkbox state] == NSOnState) {
        [self.project removeFilters:audioExclusionRules];
        [self.project addFilters:audioInclusionRules];
    }
    else
        [self.project removeFilters:audioInclusionRules];
    
    [filterListView scrollRowToVisible:filterListView.numberOfRows - 1];
    
}

- (IBAction)includeArchives:(NSButton *)checkbox {
    
    NSArray *archivesExclusionRules = ARCHIVES_EXCLUSION_RULES;
    NSArray *archivesInclusionRules = ARCHIVES_INCLUSION_RULES;
    
    if ([checkbox state] == NSOnState) {
        [self.project removeFilters:archivesExclusionRules];
        [self.project addFilters:archivesInclusionRules];
    }
    else
        [self.project removeFilters:archivesInclusionRules];
    
    [filterListView scrollRowToVisible:filterListView.numberOfRows - 1];
    
}

- (IBAction)includeVideo:(NSButton *)checkbox {
    
    NSArray *videoExclusionRules = VIDEO_EXCLUSION_RULES;
    NSArray *videoInclusionRules = VIDEO_INCLUSION_RULES;
    
    if ([checkbox state] == NSOnState) {
        [self.project removeFilters:videoExclusionRules];
        [self.project addFilters:videoInclusionRules];
    }
    else
        [self.project removeFilters:videoInclusionRules];
    
    [filterListView scrollRowToVisible:filterListView.numberOfRows - 1];
    
}

#pragma mark Private methods

- (NSString *)currentInputRule {
    
    NSString *format;
    NSString *input = [addFilterField stringValue];
    
    switch ([addFilterMenu indexOfSelectedItem]) {
        case 0:
            format = @"*.%@";
            break;
        case 1:
            format = @"*/*%@*";
            break;
        case 2:
            format = @"*/%@";
            break;
        case 3:
            format = @"*/*%@*/*";
            break;
        case 4:
            format = @"*/%@/*";
            break;
        case 5:
            format = @"*[name].%@/*";
            break;
        case 6:
            format = @"*[name].*[name]%@*[name].*[name]/*";
            break;
        case 7:
            format = @"%@/*";
            break;
        case 8:
            format = @"*%@*";
            break;
        case 9:
            format = @"%@";
            break;
        default:
            return nil;
            break;
    }
    
    return [NSString stringWithFormat:format, input];
    
}

- (void)updateInclusionButtons {
    
    int index = 0;
    NSArray *checkboxes = @[includeImagesButton, includeAudioButton, includeVideoButton, includeArchivesButton];
    
    for (NSArray *filterArray in @[IMAGE_INCLUSION_RULES, AUDIO_INCLUSION_RULES, VIDEO_INCLUSION_RULES, ARCHIVES_INCLUSION_RULES]) {
        
        BOOL containsAll = true;
        NSButton *currentCheckbox = [checkboxes objectAtIndex:index++];
        
        for (NSString *filter in filterArray)
            if (![self.project hasFilter:filter])
                containsAll = false;
        
        [currentCheckbox setState:(containsAll ? NSOnState : NSOffState)];
        
    }
    
}

#pragma mark Memory management

- (void)dealloc {
    
    [filterListView release];
    
    [includeImagesButton release];
    [includeAudioButton release];
    [includeArchivesButton release];
    [includeVideoButton release];
    
    [addFilterMenu release];
    [addFilterField release];
    
    [super dealloc];
    
}

@end

@implementation ProjectOptionsAppearancePanelController

- (NSString *)panelTitle {
    
    return @"  Design  ";
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Design"];
    
}

@end

@implementation ProjectOptionsIdentityPanelController

- (NSString *)panelTitle {
    
    return @"  Identity  ";
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Identity"];
    
}

@end

@implementation ProjectOptionsEnginePanelController

- (NSString *)panelTitle {
    
    return @"  Engine  ";
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNameAdvanced];
    
}

@end

@implementation ProjectOptionsNetworkPanelController

- (NSString *)panelTitle {
    
    return @"  Network  ";
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Network"];
    
}

@end