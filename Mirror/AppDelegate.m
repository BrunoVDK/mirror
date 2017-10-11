//
//  AppDelegate.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//
//  Delegate for the application.
//

#import "AboutWindowController.h"
#import "AppDelegate.h"
#import "PreferencesConstants.h"
#import "PreferencesWindowController.h"

#pragma mark Application Delegate

@implementation AppDelegate

#pragma mark Application Delegation

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    
    [self loadIcon];
    [PREFERENCES addObserver:self forKeyPath:UseLionIcon options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleQuitAppleEvent:withReplyEvents:)
                                                     forEventClass:kCoreEventClass
                                                        andEventID:kAEQuitApplication];
    
    [[PreferencesWindowController sharedPreferences] initPreferences]; // Not in -applicationDidFinishLaunching: or untitled file may have issue
    
    [NSApp setServicesProvider:self];
    
    terminationRequested = false;
    
    badgeView = [[BadgeView alloc] init];
    [[NSApp dockTile] setContentView:badgeView];
    
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    
    return true;
    
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
    if ([[[NSDocumentController sharedDocumentController] documents] count] > 0) {
        [[NSDocumentController sharedDocumentController] closeAllDocumentsWithDelegate:self
                                                                   didCloseAllSelector:@selector(documentController:didCloseAll:contextInfo:)
                                                                           contextInfo:nil];
        return NSTerminateLater;
    }
    
    return NSTerminateNow;
    
}

- (void)documentController:(NSDocumentController *)documentController didCloseAll:(BOOL)didCloseAll contextInfo:(void *)contextInfo {
    
    if (didCloseAll)
        [NSApp terminate:self];
    
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    
    NSError *error = nil;
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[NSURL fileURLWithPath:filename] display:true error:&error];
     
     return (error == nil);
    
}


- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    
    for (NSString *filename in filenames)
        [self application:sender openFile:filename];
    
}

- (void)handleQuitAppleEvent:(NSAppleEventDescriptor *)event withReplyEvents:(NSAppleEventDescriptor *)reply {
    
    [self handleQuit:self];
    
}

#pragma mark Services

- (void)mirrorURL:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error {
    
    NSArray *classes = [NSArray arrayWithObjects:[NSString class], [NSURL class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    
    if (![pboard canReadObjectForClasses:classes options:options]) {
        *error = @"Error: couldn't read URL.";
        return;
    }
    
    NSURL *pboardURL = [NSURL URLFromPasteboard:pboard];
    if (!pboardURL)
        pboardURL = [NSURL URLWithString:[pboard stringForType:NSPasteboardTypeString]];
    
    BOOL success = [self newDocumentWithURL:pboardURL];
    
    if (!success) {
        *error = @"Error: couldn't mirror the URL.";
        return;
    }
    
    [pboard clearContents];
    
}

- (BOOL)newDocumentWithURL:(NSURL *)url {
    
    if (terminationRequested || !url)
        return false;
    
    for (Project *newDocument in [[NSDocumentController sharedDocumentController] documents])
        if (![newDocument hasStarted] && [newDocument addURL:url] != nil)
            return true;
    
    [[NSDocumentController sharedDocumentController] newDocument:self];
    Project *newDocument = [[NSDocumentController sharedDocumentController] currentDocument];
    if ([newDocument addURL:url])
        return true;
    
    [[NSDocumentController sharedDocumentController] removeObject:newDocument];
        
    return false;
    
}

#pragma mark Actions

- (IBAction)showPreferences:(id)sender {
    
    [[[PreferencesWindowController sharedPreferences] window] setTitle:@"App Preferences"];
    [[PreferencesWindowController sharedPreferences] showWindow:self];
    
}

- (IBAction)showAboutWindow:(id)sender {
    
    [[AboutWindowController sharedController] showWindow:self];
    
}

- (IBAction)handleQuit:(id)sender {
    
    for (NSWindow *window in [NSApp windows])
        [[window attachedSheet] orderOut:self];
    
    [[NSApplication sharedApplication] terminate:self];
    
}

#pragma mark Icon

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self loadIcon];
    
}

- (void)loadIcon {
    
    BOOL useLionIcon = [PREFERENCES boolForKey:UseLionIcon];
    NSString *iconPath = @"icon";
    if (useLionIcon)
        iconPath = @"lionicon";
    
    [NSApp setApplicationIconImage:[NSImage imageNamed:iconPath]];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [badgeView release];
    
    [PREFERENCES removeObserver:self forKeyPath:UseLionIcon];
    
    [super dealloc];
    
}

@end
