//
//  ProjectNotificationsWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 09/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "AnimatedPanelsWindowController.h" // Theme preferences keys are defined there
#import "Project.h"
#import "ProjectNotification.h"
#import "ProjectNotificationList.h"
#import "ProjectNotificationsWindowController.h"

#pragma mark Project Notifications Window Controller

@implementation ProjectNotificationsWindowController

@synthesize project = _project;

#pragma mark Class Methods

+ (id)sharedNotifations { // Singleton
    
    static dispatch_once_t token = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&token, ^{
        _sharedObject = [self new];
    });
    
    return _sharedObject;
    
}

#pragma mark Constructors

- (id)init {
    
    if (self = [super init]) {
        
        [self readTheme];
        [PREFERENCES addObserver:self forKeyPath:PanelWindowTheme options:NSKeyValueObservingOptionNew context:NULL];
        [PREFERENCES addObserver:self forKeyPath:KeepPanelsOnTop options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    return self;
    
}

#pragma mark Interface

- (NSString *)windowNibName {
    
    return @"ProjectNotificationsWindowController";
    
}

#pragma mark Theme

- (void)readTheme {
    
    if ([PREFERENCES boolForKey:KeepPanelsOnTop])
        self.window.level = NSFloatingWindowLevel;
    else
        self.window.level = NSNormalWindowLevel;
    
    if (IS_PRE_YOSEMITE || [PREFERENCES integerForKey:PanelWindowTheme] == 0) {
        self.window.styleMask = self.window.styleMask & ~NSTexturedBackgroundWindowMask;
        self.window.backgroundColor = [NSColor windowBackgroundColor];
    }
    else {
        self.window.styleMask = self.window.styleMask | NSTexturedBackgroundWindowMask;
        self.window.backgroundColor = [NSColor whiteColor];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self readTheme];
    
}

#pragma mark Actions

- (IBAction)copy:(id)sender {
    
    NSInteger selectedRow = tableView.clickedRow;
    if (selectedRow == -1)
        selectedRow = tableView.selectedRow;
    
    if (selectedRow != NSNotFound) {
        
        ProjectNotificationList *notificationList = self.project.notifications;
        
        if (selectedRow < notificationList.size) {
            
            NSString *description = [(ProjectNotification *)[notificationList.arrangedObjects objectAtIndex:selectedRow] content];
            
            // Copy to pasteboard
            NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
            [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
            if ([pasteBoard setString:description forType:NSStringPboardType])
                return;
            
        }
        
    }
    
    NSBeep();
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:PanelWindowTheme context:NULL];
    [PREFERENCES removeObserver:self forKeyPath:KeepPanelsOnTop context:NULL];
    
    [tableView release];
    
    [super dealloc];
    
}

@end
