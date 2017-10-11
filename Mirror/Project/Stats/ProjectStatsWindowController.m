//
//  ProjectStatsWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/06/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "NSColor+Additions.h"
#import "PreferencesConstants.h"
#import "ProjectFileList.h"
#import "ProjectStatsPanelController.h"
#import "ProjectStatsWindowController.h"
#import "ProjectStatsDictionary.h"

#pragma mark Project Options Statistics Controller

@implementation ProjectStatsWindowController

@synthesize project = _project;

+ (id)sharedStatistics { // Singleton
    
    static dispatch_once_t token = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&token, ^{
        _sharedObject = [[self alloc] initWithProject:nil];
    });
    
    return _sharedObject;
    
}

- (id)initWithProject:(Project *)project {
    
    if (self = [super init]) {
        
        self.window.title = @"Project Statistics";
        self.window.styleMask |= NSResizableWindowMask;
        self.window.minSize = NSMakeSize(250, 200);
        self.window.maxSize = NSMakeSize(600, 600);
        [self.window setFrame:NSMakeRect(0, 0, 300, 400) display:true];
        self.window.resizeIncrements = NSMakeSize(1, 17);
        
        filesPanel = [ProjectStatsFilesPanelController new];
        overviewPanel = [ProjectStatsOverviewPanelController new];
        NSArray *panels =  @[filesPanel, overviewPanel];
        [self setPanelControllers:panels];
        
        self.project = project;
        
    }
    
    return self;
    
}

#pragma mark Mutators

- (void)setProject:(Project *)project {
    
    _project = project;
    
    for (ProjectStatsPanelController *panel in self.panelControllers)
        [panel setProject:project]; // Updates bindings
    
}

#pragma mark Interface

- (void)activatePanelController:(id<AnimatedPanelControllerProtocol>)panelController animate:(BOOL)animate {
    
    [super activatePanelController:panelController animate:animate];
    [self setProject:_project]; // Reload the views
    
}

/*
- (void)showWindow:(id)sender {
    
    [super showWindow:sender];
    [self updateInterface];
    
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    
    [super windowDidBecomeKey:notification];
    [self updateInterface];
    
}

- (void)windowDidResignKey:(NSNotification *)notification {
    
    [super windowDidResignKey:notification];
    [self updateInterface];
    
}
*/

#pragma mark Memory management

- (void)dealloc {
    
    [filesPanel release];
    [overviewPanel release];
    
    [super dealloc];
    
}

@end