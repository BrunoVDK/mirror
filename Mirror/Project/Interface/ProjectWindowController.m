//
//  ProjectWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 21/10/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import <time.h>

#import "BadgeView.h"
#import "Globals.h"
#import "NSColor+Additions.h"
#import "NSString+Additions.h"
#import "PreferencesConstants.h"
#import "Project.h"
#import "ProjectFile.h"
#import "ProjectFileList.h"
#import "ProjectNotificationsWindowController.h"
#import "ProjectURL.h"
#import "ProjectStatsDictionary.h"
#import "ProjectStatsWindowController.h"
#import "ProjectWindowController.h"

#define TIMER_INTERVAL 1.0/2.0

#pragma mark Project Window Controller

@interface ProjectWindowController() <NSTableViewDataSource, NSTableViewDelegate, NSToolbarDelegate>

+ (NSMenuItem *)pauseMainMenuItem;
- (void)requestExportDirectoryForBaseURL:(ProjectURL *)URL completion:(void(^)(BOOL success))completion;
- (NSString *)getRootDomain:(NSURL *)url;

@end

@implementation ProjectWindowController

@dynamic project;
@synthesize renderInCircles = _renderInCircles;

- (Project *)project {
    
    return (Project *)self.document;
    
}

#pragma mark Interface

#define PAUSE_ITEM [ProjectWindowController pauseMainMenuItem]

+ (NSMenuItem *)pauseMainMenuItem { // Get the main menu item for pausing/resuming projects
    
    static NSMenuItem *pauseItem = nil;
    
    if (!pauseItem) {
        
        NSMenu *mainMenu = [NSApp mainMenu];
        NSMutableArray *items = [NSMutableArray arrayWithArray:[mainMenu itemArray]];
        
        while (items.count != 0) {
            
            NSMenuItem *currenItem = [items lastObject];
            [items removeLastObject];
            
            if (currenItem.submenu != nil)
                [items addObjectsFromArray:[currenItem.submenu itemArray]];
            else if ([currenItem.title.lowercaseString isEqualToString:@"pause"]) {
                pauseItem = currenItem;
                break;
            }
            
        }
        
    }
    
    return pauseItem;
    
}

- (NSString *)windowNibName {
    
    return @"ProjectWindow";
    
}

- (void)windowDidLoad {
    
    [super windowDidLoad];
    
    [self setWindowFrameAutosaveName:[self className]];
    
    [[toolbarSearchButton cell] setHighlightsBy:NSNoCellMask];
    [[toolbarOptionsButton cell] setHighlightsBy:NSNoCellMask];
    [[toolbarStatsButton cell] setHighlightsBy:NSNoCellMask];
    
}

- (void)updateInterface {
    
    // Abstract method
    
}

- (void)updateURLAtIndex:(NSInteger)index {
    
    // Abstract method
    
}

- (void)updateAllURLs {
    
    for (int i=0 ; i<[[[self document] URLs] count] ; i++)
        [self updateURLAtIndex:i];
    
}

- (void)updateStatus {
    
    // Abstract method
    
}

- (void)updateMenus {
    
    BOOL statsShown = [[STATISTICS window] isVisible];
    [toolbarStatsButton setState:(statsShown ? NSOnState : NSOffState)];
    [toolbarStatsButton setAction:(statsShown ? @selector(hideStatistics:) : @selector(showStatistics:))];
    
    BOOL optionsShown = [[OPTIONS window] isVisible];
    [toolbarOptionsButton setState:(optionsShown ? NSOnState : NSOffState)];
    [toolbarOptionsButton setAction:(optionsShown ? @selector(hideOptions:) : @selector(showOptions:))];
    
}

- (IBAction)addURL:(id)sender {
    
    // Abstract method
    
}

- (void)restoreInterface:(ProjectWindowController *)controller {
    
    NSRect oldFrame = [controller.window frame];
    NSRect currentFrame = [self.window frame];
    NSPoint newOrigin = oldFrame.origin;
    newOrigin.y += (oldFrame.size.height - currentFrame.size.height);
    
    [self.window setFrameOrigin:newOrigin];
    [self showWindow:self];
    
}

#pragma mark Export Directory

- (void)requestExportDirectory:(void(^)(BOOL success))completion {
    
    if ([[self project] rootURL])
        [self requestExportDirectoryForBaseURL:[[self project] rootURL] completion:completion];
    else
        completion(false);
    
}

- (void)requestExportDirectoryForBaseURL:(ProjectURL *)URL completion:(void(^)(BOOL success))completion {
    
    if ([[self project] exportDirectory])
        return completion(true);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger savePreference = [(NSNumber *)[PREFERENCES objectForKey:SaveProjectsIn] integerValue];
    
    if (savePreference == 0) { // Downloads folder
        
        NSURL *exportDirectory = nil;
        
        NSArray *URLs = [fileManager URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask];
        if (URLs != nil || [URLs count] > 0) {
            
            NSURL *downloadsDirectory = [URLs objectAtIndex:0];
            exportDirectory = [downloadsDirectory URLByAppendingPathComponent:[self getRootDomain:URL.URL]];
            
            if ([[exportDirectory absoluteString] length] > 0) {
                
                int i = 2;
                NSError *error = nil;
                
                do {
                    
                    if ([fileManager createDirectoryAtURL:exportDirectory withIntermediateDirectories:false attributes:nil error:&error]) {
                        [[self project] setExportDirectory:exportDirectory];
                        break;
                    }
                    
                    exportDirectory = [downloadsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@ %i", [self getRootDomain:URL.URL], i++]];
                    
                } while (i < 1000);
                
                if (i < 1000)
                    return completion(true);
                
            }
            
        }
        
        completion(false);
        
    }
    else { // User-selected folder
                
        NSSavePanel *panel = [NSSavePanel savePanel];
        [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger returnCode) {
            
            if (returnCode == NSOKButton) {
                
                BOOL isDirectory;
                NSError *error = nil;
                
                NSURL *panelURL = [panel URL];
                
                if ([fileManager fileExistsAtPath:[panelURL path] isDirectory:&isDirectory] && isDirectory)
                    [fileManager removeItemAtPath:[panelURL path] error:&error]; // Overwrite
                
                if (!error) {
                    
                    if ([fileManager createDirectoryAtURL:panelURL withIntermediateDirectories:NO attributes:nil error:&error]) {
                        
                        [[self project] setExportDirectory:panelURL];
                        return completion(true);
                        
                    }
                    
                }
                
            }
            
            completion(false);
            
        }];
        
    }
    
}

- (NSString *)getRootDomain:(NSURL *)url {
    
    NSString *host = [url host];
    NSArray *hostComponents = [host componentsSeparatedByString:@"."];
    
    if ([hostComponents count] >=2) {
        return [NSString stringWithFormat:@"%@.%@",
                [hostComponents objectAtIndex:([hostComponents count] - 2)],
                [hostComponents objectAtIndex:([hostComponents count] - 1)]];
    }
    
    return @"";
    
}

#pragma mark Window Delegation

- (void)windowDidBecomeKey:(NSNotification *)notification {
    
    [self updateMenus];
    
}

- (void)windowDidResignKey:(NSNotification *)notification {
    
    if ([[NSApp mainWindow] class] != [ProjectWindow class]) {
        [self hideOptions:self];
        [self hideStatistics:self];
        [self hideNotifications:self];
    }
    
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
    
    if ([notification object] == [self window]) {
        
        [OPTIONS setProject:self.project];
        [NOTIFICATIONS setProject:self.project];
        [STATISTICS setProject:self.project];
        
        [self updateMenus];
        
        [[OPTIONS window] setDelegate:self];
        [[STATISTICS window] setDelegate:self];
                
    }
    
}

- (void)windowDidResignMain:(NSNotification *)notification {
    
    [toolbarOptionsButton setState:NSOffState];
    [toolbarStatsButton setState:NSOffState];
    [toolbarSearchButton setState:NSOffState];
    
}

- (void)windowWillMiniaturize:(NSNotification *)notification {
    
    [self hideOptions:self];
    [self hideStatistics:self];
    [self hideNotifications:self];
    
}

- (void)windowWillClose:(NSNotification *)notification {
    
    if ([notification object] == self.window) {
        
        [self hideOptions:self];
        [self hideStatistics:self];
        [self hideNotifications:self];
                
    }
    
}

- (void)didMakeFirstResponder:(NSResponder *)responder {
    
    // Abstract method called by project windows.
    
}

#pragma mark Project Options

- (void)setDocument:(Project *)project {
    
    if (project && self.document != project) {
        
        project.delegate = self;
        
        [super setDocument:project];
        
        [OPTIONS setProject:self.project];
        [NOTIFICATIONS setProject:self.project];
        [STATISTICS setProject:self.project];
        
    }
    
}

- (IBAction)showOptions:(id)sender {
    
    // [self hideStatistics:self];
    [OPTIONS showWindow:self];
    [self updateMenus];
    
}

- (IBAction)hideOptions:(id)sender {
    
    [[OPTIONS window] orderOut:self];
    [self updateMenus];
    
}

- (IBAction)showStatistics:(id)sender {
    
    // [self hideOptions:self];
    [STATISTICS showWindow:self];
    [self updateMenus];
    
}

- (IBAction)hideStatistics:(id)sender {
    
    [[STATISTICS window] orderOut:self];
    [self updateMenus];
    
}

- (IBAction)showNotifications:(id)sender {
    
    [NOTIFICATIONS showWindow:self];
    
}

- (IBAction)hideNotifications:(id)sender {
    
    [[NOTIFICATIONS window] orderOut:self];
    
}

#pragma mark Menu

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
        
    return (menuItem == PAUSE_ITEM ? self.project.isMirroring : true);
    
}

#pragma mark Searching

- (IBAction)toggleSearch:(id)sender {
    
    // Abstract method
    
}

- (IBAction)showSearch:(id)sender {
    
    // Abstract method
    
}

- (IBAction)hideSearch:(id)sender {
    
    // Abstract method
    
}

#pragma mark Memory Management

- (void)close {
    
    [STATISTICS setProject:nil];
    
    [super close];
    
}

@end

//
//  OS-specific Project Window Controllers
//

#import "CapsuleSegmentedControl.h"
#import "ColoredView.h"
#import "GradientView.h"
#import "PreferencesWindowController.h"
#import "Project.h"
#import "ProjectAdditionField.h"
#import "ProjectFileList.h"
#import "ProjectListView.h"
#import "ProjectOptionsWindowController.h"
#import "ProjectStatsCell.h"
#import "SplitView.h"
#import "TextView.h"

#pragma mark - Project Window Controller (Lion)

@interface ProjectWindowControllerLion() <SplitViewDelegate, NSTextDelegate>

- (NSString *)currentSearchString;
- (void)setSearchString:(NSString *)string;

- (IBAction)toggleAddPauseSegment:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)selectSearch:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;
- (IBAction)cancelURL:(id)sender;

@end

@implementation ProjectWindowControllerLion

#pragma mark Interface

- (void)setURL:(NSURL *)url edit:(BOOL)edit {
    
    ProjectURL *newURL = [[ProjectURL alloc] initWithURL:[NSURL URLWithString:[url absoluteString]] identifier:0];
    
    if (newURL) {
        
        [dummy release];
        dummy = newURL;
        
        if (edit) {
            if (showDummy)
                [self stopEditingDummy];
            [self setShowDummy:true];
        }
        
    }
    
}

- (NSString *)currentSearchString {
    
    return [searchField stringValue];
    
}

- (void)setSearchString:(NSString *)string {
    
    [searchField setStringValue:string];
    
}

- (void)resizeWindow:(BOOL)initialisation {
    
    BOOL automatic = [PREFERENCES boolForKey:ResizeAutomatically];
    
    CGFloat minHeight = [self contentHeightForNumberOfRows:2], maxHeight = [self contentHeightForNumberOfRows:6];
    self.window.contentMinSize = NSMakeSize([self minWindowWidth], minHeight);
    self.window.contentMaxSize = NSMakeSize([self maxWindowWidth], maxHeight);
    
    // Calculate new frame height
    CGFloat newHeight = [self contentHeightForNumberOfRows:[self numberOfRowsInTableView:listView]];
    if (newHeight > self.window.contentMaxSize.height)
        newHeight = self.window.contentMaxSize.height;
    if (newHeight < self.window.contentMinSize.height)
        newHeight = self.window.contentMinSize.height;
    CGFloat newFrameHeight = [self.window frameRectForContentRect:NSMakeRect(0, 0, 0, newHeight)].size.height;
    
    // Calculate new frame
    NSRect frame = self.window.frame;
    frame.origin.y += frame.size.height - newFrameHeight;
    frame.size.height = newFrameHeight;
    
    if (automatic || initialisation) {
        [self.window setFrame:frame display:true animate:!initialisation];
        if (automatic){
            CGFloat fixedHeight = ((NSView *)(self.window.contentView)).frame.size.height;
            self.window.contentMinSize = NSMakeSize([self minWindowWidth], fixedHeight);
            self.window.contentMaxSize = NSMakeSize([self maxWindowWidth], fixedHeight);
        }
    }
    
}

- (CGFloat)minWindowWidth {
    
    return 400;
    
}

- (CGFloat)maxWindowWidth {
    
    return 600;
    
}

- (CGFloat)contentHeightForNumberOfRows:(NSInteger)rows {
    
    CGFloat contentHeight = [(NSView *)[self.window contentView] frame].size.height - [listView enclosingScrollView].frame.size.height;
    return contentHeight + rows * [listView rowHeight];
    
}

- (void)setDocument:(NSDocument *)document {
    
    [super setDocument:document];
    [self renewTimer];
    
}

- (void)restoreInterface:(ProjectWindowController *)controller {
    
    [super restoreInterface:controller];
    
    if ([controller isKindOfClass:[ProjectWindowControllerLion class]])
        if (![(ProjectWindowControllerLion *)controller showsDummy])
            [self setShowDummy:false];
    
}

#pragma mark Interface Updates

- (void)updateInterface {
    
    [self updateInterface:nil];
    
}

- (void)updateInterface:(NSTimer *)timer {
    
    // [self updateRelevantURLs];
    // [self updateStatus];
    [self updateTransferRate];
    if (self.project.engineOptions->stats.stat_timestart != 0) {
        long long seconds = time(NULL) - self.project.engineOptions->stats.stat_timestart;
        [self.project.statistics setValue:[NSString elapsedTimeForSeconds:seconds] forStatisticOfType:ProjectStatisticTime];
    }
    [self.project.statistics.outlineView reloadData];
    
}

- (void)updateStatus {
    
    NSString *status = @"No links";
    
    if (errorMessage) {
        status = errorMessage;
        errorMessage = nil;
        NSBeep();
    }
    else {
        
        NSInteger count = [listView numberOfRows] - showDummy;
        if (count == 1)
            status = [NSString stringWithFormat:@"1 link"];
        else if (count > 1)
            status = [NSString stringWithFormat:@"%li link", (long)count];
        
        if ([self.project isPaused])
            status = [NSString stringWithFormat:@"%@ - Paused", status];
        else if ([statusField.stringValue contains:@"Pausing"])
            status = [NSString stringWithFormat:@"%@ - Pausing ...", status];
        else if ([self.project isCompleted])
            status = @"Project completed.";
        
    }
    
    [statusField setStringValue:status];
    
}

- (void)updateTransferRate {
    
    if ([self.window isMainWindow]
        && [PREFERENCES boolForKey:ShowRateInDock]
        && [self.project isMirroring]
        && ![self.project isPaused]) {
        NSString *rate = (NSString *)[self.project.statistics valueForStatisticOfType:ProjectStatisticTransferRate];
        if (!rate)
            rate = @"-- / s";
        [[BadgeView sharedView] setMessage:rate];
        [[BadgeView sharedView] setVisible:true];
    }
    else
        [[BadgeView sharedView] setVisible:false];
    
}

- (void)updateMenus {
    
    [super updateMenus];
    
    // Flags
    BOOL paused = [self.project isPaused];
    
    // Update toolbar
    [toolbarSearchButton setState:(![searchSplitView viewIsCollapsed:searchView] ? NSOnState : NSOffState)];
    [toolbarAddPauseButton setSelected:[listView editedRow] != -1 forSegment:0];
    [toolbarAddPauseButton setEnabled:![self.project isCompleted]];
    
    // Update main menu
    [PAUSE_ITEM setTitle:(paused ? @"Resume" : @"Pause")];
    [PAUSE_ITEM setAction:(paused ? @selector(resume:) : @selector(pause:))];
    [PAUSE_ITEM setTarget:self];
    
}

- (void)updateGradient {
    
    if ([self.window isMainWindow])
        [(GradientView *)[windowSplitView secondView] setGradient:[GradientView defaultGradient]];
    else
        [(GradientView *)[windowSplitView secondView] setGradient:[GradientView secondaryGradient]];
    
}

- (void)updateRelevantURLs {
    
    NSIndexSet *columnIndices = [NSIndexSet indexSetWithIndex:0];
    [statsIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [listView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:idx + showDummy] columnIndexes:columnIndices];
    }];
    
    [statsIndices removeAllIndexes];
    
}

- (void)updateURLAtIndex:(NSInteger)index {
    
    [listView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    
}

#pragma mark Project Delegate

- (void)projectDidStart:(Project *)project {
    
    [OPTIONS updatePanels];
    [self renewTimer];
    [self updateStatus];
    [self updateMenus];
    [self updateTransferRate];
    
    showDummy = false; // Remove dummy when interface is refreshed
    [self setSearchString:@""];
    [listView reloadData];
    [self resizeWindow:false];
    
}

- (void)projectDidStartEngine:(Project *)project {
    
    [toolbarAddPauseButton setEnabled:true forSegment:1];
    
}

- (void)projectDidEnd:(Project *)project error:(NSString *)error {
    
    [self stopEditingDummy];
    [self invalidateTimer];
    if (error)
        errorMessage = error;
    [self updateStatus];
    [self updateMenus];
    [self updateTransferRate];
    
}

- (void)projectDidResume:(Project *)project {
        
    [self renewTimer];
    [self updateStatus];
    [self updateMenus];
    [self updateTransferRate];
    [toolbarAddPauseButton setSelected:false forSegment:1];
    [toolbarAddPauseButton setEnabled:true forSegment:1];
    
}

- (void)projectDidPause:(Project *)project {
    
    [self invalidateTimer];
    [self updateStatus];
    [self updateMenus];
    [self updateTransferRate];
    [toolbarAddPauseButton setSelected:true forSegment:1];
    [toolbarAddPauseButton setEnabled:true forSegment:1];
    [listView reloadData];
    
}

#pragma mark Actions

- (IBAction)toggleAddPauseSegment:(id)sender {
    
    if ([sender selectedSegment] == 0) { // Add button clicked
        
        BOOL editing = [listView editedRow] != -1;
        
        if (editing)
            [self setShowDummy:false];
        else
            [self addURL:sender];
        
    }
    else { // Pause button clicked
        
        if ([self.project isPaused])
            [self resume:self];
        else
            [self pause:self];
        
    }
    
}

- (IBAction)addURL:(id)sender {
    
    if ([self project].completed || [self project].URLs.count >= MAX_URLS) {
        NSBeep();
        return;
    }
    
    [self hideSearch:self]; // This prevents any interference with the dummy-related animation
    
    if (!showDummy)
        [self setShowDummy:true];
    else if ([listView editedRow] == -1)
        [self editDummy];
    
}

- (IBAction)toggleSearch:(id)sender {
    
    if ([searchSplitView viewIsCollapsed:searchView])
        [self showSearch:self];
    else
        [self hideSearch:self];
    
}

- (IBAction)hideSearch:(id)sender {
    
    if ([searchSplitView viewIsCollapsed:searchView])
        return; // Or the methods below would interfere with smooth animations
    
    if ([projectListController filterPredicate]) {
        [projectListController setFilterPredicate:nil];
        [listView reloadData];
    }
    
    [searchSplitView collapseView:[searchSplitView secondView] withAnimation:true completionBlock:^(void) {
        
        [toolbarSearchButton setState:NSOffState];
        [toolbarSearchButton setAction:@selector(showSearch:)];
        
    }];
    
}

- (IBAction)showSearch:(id)sender {
    
    if (![searchSplitView viewIsCollapsed:searchView])
        return;
    else if ([searchField stringValue].length < 1)
        [searchField setStringValue:@"search"];
    
    [self setShowDummy:false];
    
    [searchSplitView uncollapseView:[searchSplitView secondView] withAnimation:true completionBlock:^(void) {
        
        [toolbarSearchButton setState:NSOnState];
        [toolbarSearchButton setAction:@selector(hideSearch:)];
        
        [self.window makeFirstResponder:searchField];
        [searchTextView selectAll:self];
        
        [[listView enclosingScrollView] setHasVerticalScroller:true];
        
    }];
    
}

- (IBAction)pause:(id)sender {
        
    if ([self.project isMirroring]) {
        [statusField setStringValue:@"Pausing ..."];
        if (![self.project isPaused]) {
            [toolbarAddPauseButton setSelected:false forSegment:1];
            [toolbarAddPauseButton setEnabled:false forSegment:1];
            [[self project] pause];
        }
    }
    else
        NSBeep();
    
}

- (IBAction)resume:(id)sender {
    
    if ([[self project] isMirroring]) {
        [statusField setStringValue:@"Resuming ..."];
        if ([self.project isPaused]) {
            [toolbarAddPauseButton setSelected:true forSegment:1];
            [toolbarAddPauseButton setEnabled:false forSegment:1];
            [[self project] resume];
        }
    }
    else
        NSBeep();
    
}

- (IBAction)cancelURL:(id)sender {
    
    ProjectURL *URL = [[projectListController arrangedObjects] objectAtIndex:[listView clickedRow] - showDummy];
    [self.project cancelURL:URL];
    [listView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[listView clickedRow]]
                        columnIndexes:[listView columnIndexesInRect:[listView visibleRect]]];
    
}

- (IBAction)revealInFinder:(id)sender {
        
    NSURL *projectDirectory = [[self project] exportDirectory];
    [[NSWorkspace sharedWorkspace] selectFile:projectDirectory.path inFileViewerRootedAtPath:nil];
    
}

- (IBAction)showPreferences:(id)sender {
    
    [[PreferencesWindowController sharedPreferences] showWindow:self];
    
}

- (IBAction)selectSearch:(id)sender {
    
//    [[self controlView] uncollapseView:[[self controlView] secondView] withAnimation:true];
    
}

#pragma mark Events

- (void)windowDidLoad {
    
    alternateRowColor = [[NSColor colorWithCalibratedWhite:0.95 alpha:1.0] retain];
    listView.alternateColor = alternateRowColor;
    
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSURLPboardType]];
    
    [PREFERENCES addObserver:self forKeyPath:RenderIconsInCircles options:NSKeyValueObservingOptionNew context:NULL];
    self.renderInCircles = [PREFERENCES boolForKey:RenderIconsInCircles];
    [PREFERENCES addObserver:self forKeyPath:ResizeAutomatically options:NSKeyValueObservingOptionNew context:NULL];
    [PREFERENCES addObserver:self forKeyPath:ShowRateInDock options:NSKeyValueObservingOptionNew context:NULL];
    
    [listView setDoubleAction:@selector(doubleClick:)];
    [listView setTarget:self];
    
    dummy = [[ProjectURL alloc] initWithURL:[NSURL URLWithString:BASE_URL] identifier:0];
    [dummy setIcon:[NSImage imageNamed:NSImageNameNetwork]];
    
    // [[self controllerSplitView] setCustomDividerThickness:0.0]; // Hide divider of split view
    [controllerSplitView collapseView:[controllerSplitView firstView] withAnimation:false];
    [listView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone]; // Selection is enabled for the dummy row only to enable editing
    [listView setDoubleAction:@selector(doubleClick:)];
    [listView setTarget:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification object:nil];
    
    // [projectSplitView setCustomDividerThickness:0.0]; // Remove separator line above stats view
    // [windowSplitView setCustomDividerThickness:0.0]; // Remove line above path view field
    
    [self resizeWindow:true]; // At the end, when the window is fully set up
    [self setShowDummy:true]; // After min/max size setup or it will mess up the size of the window and cause a negative min size
    
    statsIndices = [[NSMutableIndexSet alloc] init];
    [self renewTimer];
    
    [super windowDidLoad];
    
    if (![self.window isMainWindow]) {
        // On runloop or the dummy edit interferes
        [[NSRunLoop currentRunLoop] performSelector:@selector(updateMenus) target:self argument:nil order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        [self windowDidResignMain:[NSNotification notificationWithName:NSWindowDidResignMainNotification object:self.window]];
    }
    
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
        
    [super windowDidBecomeMain:notification];
    
    [listView reloadVisibleRect];
    [self updateGradient];
    [statusField setTextColor:[NSColor darkGrayColor]];
    [searchTextView setTextColor:[NSColor darkerGrayColor]];
    [searchField setTextColor:[NSColor darkerGrayColor]];
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    [textView setTextColor:[NSColor darkerGrayColor]];
#endif
    
}

- (void)windowDidResignMain:(NSNotification *)notification {
    
    [super windowDidResignMain:notification];
    
    [listView reloadVisibleRect];
    [self updateGradient];
    [statusField setTextColor:[NSColor lightGrayColor]];
    [searchTextView setTextColor:[NSColor lightGrayColor]];
    [searchField setTextColor:[NSColor lightGrayColor]];
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    [textView setTextColor:[NSColor lightGrayColor]];
#endif
    
}

- (void)windowWillStartLiveResize:(NSNotification *)notification {
    
    [self stopEditingDummy]; // Quick fix to avoid a bug with the field editor overlapping the text field
    dummyStats = @"Double-click to edit & add a URL";
    
}

- (void)windowWillClose:(NSNotification *)notification {

    [super windowWillClose:notification];

    if (notification.object == self.window) {
        [projectListController unbind:@"contentArray"]; // Or there will be complaints about a deallocated project being observed
        [self invalidateTimer];
    }
    
}

- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client {
   
    // Generate a separate field editor for the search/filter field, so it's easier for the window controller to figure out
    //  when it needs to collapse the field.
    if (client == searchField) {
        
        if (!searchTextView) {
            searchTextView = [NSText new];
            [searchTextView setFieldEditor:true];
        }
        
        return searchTextView;
        
    }
    else if ([client isMemberOfClass:[ProjectListView class]]) {
        
        if (!textView)
            textView = [TextView new];
            
        return textView;
        
    }
    
    return nil;
    
}

- (void)didMakeFirstResponder:(NSResponder *)aResponder {
    
    if (aResponder != searchTextView)
        [self hideSearch:self];
    
    if (![aResponder isMemberOfClass:[ProjectStatsCell class]]) // Update dummy (there are some glitches otherwise)
        [listView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:0] columnIndexes:[listView columnIndexesInRect:[listView visibleRect]]];
    
}

- (void)controlTextDidChange:(NSNotification *)notification {
    
    if ([notification object] == searchField) {
        
        NSPredicate *predicate = nil;
        NSString *searchString = [searchField stringValue];
        
        if ([searchString length] > 0) {
             predicate = [NSPredicate predicateWithFormat:@"self.URL.absoluteString CONTAINS[cd] %@ OR self.title CONTAINS[cd] %@", searchString, searchString];
            [projectListController setFilterPredicate:predicate];
            [listView reloadData];
        }
        else {
            [projectListController setFilterPredicate:nil];
            [listView reloadData];
        }
        
    }
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:RenderIconsInCircles]) {
        self.renderInCircles = [PREFERENCES boolForKey:RenderIconsInCircles];
        [listView reloadData];
    }
    else if ([keyPath isEqualToString:ResizeAutomatically])
        [self resizeWindow:false];
    else if ([keyPath isEqualToString:ShowRateInDock])
        [[BadgeView sharedView] setVisible:self.project.isMirroring && [PREFERENCES boolForKey:ShowRateInDock]];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

- (void)doubleClick:(id)sender { // Called when double-clicking a row in the project's list view
    
    if (showDummy) {
        
        if ([sender clickedRow] == 0) {
            dummyStats = @"Press enter to start mirroring"; // Editing will start, editing stops when pressing the enter key
            [self editDummy];
        }
        
    }
    
}

#pragma mark Timer

- (void)invalidateTimer {
    
    [statsTimer invalidate];
    [statsTimer release];
    statsTimer = nil;
    
}

- (void)renewTimer {
    
    if (statsTimer)
        [self invalidateTimer];
    
    statsTimer = [[NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateInterface:) userInfo:nil repeats:true] retain];
    [[NSRunLoop mainRunLoop] addTimer:statsTimer forMode:NSRunLoopCommonModes]; // If timer is to be fired when main menu is active
    
}

#pragma mark List View Data Source & Delegation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return  [[projectListController arrangedObjects] count] // Could be bound but that makes the use of a dummy more difficult
            + showDummy;
    
}

- (void)tableView:(ProjectListView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    BOOL isDummy = (row == 0 && showDummy); // True if the cell is for the dummy
    
    if ([cell isKindOfClass:[NSButtonCell class]]) {
        
        BOOL hideButtons = isDummy;
        
        if (!isDummy) {
            
            ProjectURL *URL = [[projectListController arrangedObjects] objectAtIndex:row - showDummy];
            hideButtons = [URL isCancelled];
            
            if ([tableColumn.identifier isEqualToString:@"Cancel"]) {
                if (![self project].hasWritingPermission) {
                    if (row == showDummy) {
                        [(NSButtonCell *)cell setImage:[NSImage imageNamed:NSImageNameRefreshFreestandingTemplate]];
                        [(NSButtonCell *)cell setAction:@selector(mirror)];
                        [(NSButtonCell *)cell setTarget:[self project]];
                    }
                    else
                        hideButtons = true;
                }
                else if (row == showDummy) {
                    [(NSButtonCell *)cell setImage:[NSImage imageNamed:NSImageNameStopProgressFreestandingTemplate]];
                    [(NSButtonCell *)cell setAction:@selector(cancelURL:)];
                    [(NSButtonCell *)cell setTarget:self];
                }
            }
            
        }
        
        [cell setTransparent:hideButtons]; // No cancel button if it's the dummy row (do not remove image of cell as it is recycled by other rows)
        [cell setEnabled:!hideButtons];
        
    }
    else if ([cell isMemberOfClass:[ProjectStatsCell class]]) {
        
        ProjectStatsCell *statsCell = (ProjectStatsCell *)cell; // The project list view only has project stats cells
        
        if (isDummy) {
            [statsCell setURL:dummy];
            [statsCell setStats:dummyStats];
            [statsCell setColor:([tableView odd] ? alternateRowColor : [NSColor whiteColor])];
        }
        else {
            [statsCell setURL:[[projectListController arrangedObjects] objectAtIndex:row - showDummy]];
            [statsCell setStats:nil];
            [statsCell setRenderInCircles:self.renderInCircles];
        }
        
        [statsCell setEditable:isDummy];
        
    }
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    return true; // Necessary to enable editing
    // return (row == 0 && self.showDummy); // This is necessary to enable editing
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (row == 0 && showDummy && [[tableColumn identifier] isEqualToString:@"Project"])
        return true; // Only the dummy is editable
    
    return false;
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    // NSInteger row = [listView selectedRow] - (showDummy == true ? 1 : 0); // Ignore dummy
    
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return nil; // This method has to be implemented when conforming to the table view data source protocol
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    // ProjectURL *URL = [[[self projectListController] arrangedObjects] objectAtIndex:row];
    return STATS_BASE_HEIGHT + STATS_SUB_HEIGHT;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if ([cell isKindOfClass:[NSButtonCell class]])
        return true; // Enable button tracking
    
    return false;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return !(row == 0 && showDummy) && ![[tableColumn identifier] isEqualToString:@"Margin"];
    
}

- (NSString *)tableView:(NSTableView *)aTableView toolTipForCell:(NSCell *)aCell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    
    if (showDummy && row == 0)
        return dummyStats;
    
    NSString *identifier = [aTableColumn identifier];
    
    if ([identifier isEqualToString:@"Project"])
        return [[[projectListController arrangedObjects] objectAtIndex:row - showDummy] title];
    else if ([identifier isEqualToString:@"Reveal"])
        return @"Open URL";
    else if ([identifier isEqualToString:@"Cancel"])
        return @"Cancel URL";
    
    return nil;
    
}

#pragma mark Dummy Editing

- (BOOL)showsDummy {
    
    return showDummy;
    
}

- (void)editingDidEnd:(NSNotification *)notification {
    
    // Implementing this method instead of -tableView:setObjectValue:forTableColumn:row:
    //  enables one to intercept what led to the end of the table cell edit session.
    //  (The edit session is put into effect only if it was ended by the return key)
    
    id sender = [notification object];
    
    if (sender == listView) {
        
        [self stopEditingDummy];
        
        NSDictionary *userInfo = [notification userInfo];
        NSNumber *textMovement = [userInfo objectForKey:@"NSTextMovement"];
        NSText *fieldEditor = [userInfo objectForKey:@"NSFieldEditor"];
        NSURL *newURL = [NSURL URLWithString:[fieldEditor string]];
        
        if (textMovement && fieldEditor) {
            
            if ([textMovement longLongValue] == NSReturnTextMovement) {
                
                if (newURL && newURL.scheme && newURL.host && [[self project] addURL:newURL])
                    showDummy = false;
                else {
                    
                    [self setShowDummy:true];
                    dummyStats = @"The URL couldn't be added";
                    
                }
                
            }
            else {
                
                if (!newURL) // eg. In the case of invalid characters
                    newURL = [NSURL URLWithString:BASE_URL];
                
                [self setURL:newURL edit:false];
                dummyStats = @"Double-click to edit & add a URL";
                
            }
            
        }
        
    }
    
}

- (void)editDummy { // Programmatically induce dummy editing
    
    [toolbarAddPauseButton setSelected:true forSegment:0];
    [listView editColumn:0 row:0 withEvent:nil select:true]; // Calls 'selectWithFrame:in View:editor:delegate:start:length:' when flag == true
    
}

- (void)stopEditingDummy {
    
    [toolbarAddPauseButton setSelected:false forSegment:0];
    [listView abortEditing];
    [listView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:0] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    
}

- (void)setShowDummy:(BOOL)flag { // Automatically edits it the dummy after updating the interface
    
    ProjectListView *table = listView;
    
    if (flag) {
        
        dummyStats = @"Press enter to start mirroring"; // Editing will start, editing stops when pressing the enter key
        
        // This is one way to start editing after a row is inserted (NSTableView uses CATransaction for its animations) :
        // [CATransaction begin];
        // [CATransaction setCompletionBlock:^{[self editDummy];}];
        
        if (!showDummy) {
            
            [table beginUpdates];
            showDummy = true; // *after* beginUpdates or there will be a mess-up (beginUpdates starts with reloading the table, apparently)
            [table insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideDown];
            [table endUpdates];
            
        }
        
        // [CATransaction commit];
        
        // The following code can be used after an insert into a table view, to avoid editing before the row has been inserted.
        // See note for NSArrayController's add: method :
        //  "Beginning with OS X v10.4 the result of this method is deferred until the next iteration of the runloop
        //   so that the error presentation mechanism (see Error Responders and Error Recovery) can provide feedback as a sheet."
        // If editDummy is called immediately, then there will be no effect.
        [[NSRunLoop currentRunLoop] performSelector:@selector(editDummy) target:self argument:nil order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        
    }
    else {
        
        [self stopEditingDummy];
        
        if (showDummy) { // Slide up the dummy if it was shown
                        
            [table beginUpdates];
            [table removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideUp];
            [table endUpdates];
            
        }
        
    }
    
    showDummy = flag;
    
}

#pragma mark Split View Delegation

- (void)splitViewDidLoad:(SplitView *)splitView {
    
    if (splitView == projectSplitView) {
        [projectSplitView collapseView:[projectSplitView secondView] withAnimation:false];
    }
    else if (splitView == searchSplitView) {
        
        [searchSplitView collapseView:[searchSplitView secondView] withAnimation:false];
        [toolbarSearchButton setState:NSOffState];
        [toolbarSearchButton setAction:@selector(showSearch:)];
        
    }
    
}

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
    
    return NSZeroRect; // Only for the hover effect.
    
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    
    return true; // Only for the hover effect.
    
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view {
    
    if (view == [windowSplitView secondView]
        || view == [controllerSplitView firstView]
        || view == [projectSplitView secondView]
        || view == [searchSplitView secondView])
        return false;
    
    return true;
    
}

#pragma mark Drag & Drop Observation

- (NSDragOperation)draggingEntered:(id)sender {
    
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
    
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    
    
    
}

- (BOOL)prepareForDragOperation:(id)sender {
    
    return YES;
    
}

- (BOOL)performDragOperation:(id)sender {
    
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    
    [self setURL:[NSURL URLFromPasteboard:pasteboard] edit:true];
    
    return YES;
    
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [self stopEditingDummy];
    
    [PREFERENCES removeObserver:self forKeyPath:RenderIconsInCircles];
    [PREFERENCES removeObserver:self forKeyPath:ResizeAutomatically];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [dummy release];
    [dummyStats release];
    [statsIndices release];
    
    [alternateRowColor release];
    
    [super dealloc];
    
}

@end

#import "HeaderView.h"
#import "ProjectMenuView.h"
#import "WindowAdaptedCell.h"

#pragma mark - Project Window Controller (Yosemite)

@interface ProjectWindowControllerYosemite()

- (void)loadPanel;

@end

@implementation ProjectWindowControllerYosemite

- (void)setDocument:(NSDocument *)document {
    
    [super setDocument:document];
    
    if (theme == WindowThemeYosemite)
        [self.project.statistics setOutlineView:statsOutlineView];
    
}

#pragma mark Interface

- (NSString *)windowNibName {
    
    return ([PREFERENCES integerForKey:MainWindowTheme] == WindowThemeYosemite ? @"ProjectWindowYosemite" : @"ProjectWindow");
    
}

- (CGFloat)minWindowWidth {
    
    return (theme == WindowThemeYosemite ? 480 : [super minWindowWidth]);
    
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    
    if (theme == WindowThemeYosemite) {
        
        if (!self.project.isMirroring && [[menuItem title] contains:@"Statistics"])
            return false;
        else if (![menuItem.title contains:@"Options"] && ![menuItem.title contains:@"Notifications"]) {
            if ([menuView selectedRow] == 1)
                return false;
            else if ([menuView selectedRow] == 2 && ![menuItem.title contains:@"Filter"] && ![menuItem.title contains:@"Statistics"])
                return false;
        }
        
    }
    
    return [super validateMenuItem:menuItem];
    
}

#pragma mark Interface Updates

/*
- (void)updateInterface:(NSTimer *)timer {
    
    if (theme == WindowThemeYosemite) {
        
        NSUInteger selectedRow = [menuView selectedRow];
        
        if (selectedRow == 0) {
            [self updateStatus];
            [self updateRelevantURLs];
        }
        else {
            
            if (selectedRow == 1)
                [statsOutlineView reloadData];
            
            // Could postpone socket/file update by updating only here instead of real-time
            
        }
        
        [self updateTransferRate];
        
    }
    else
        [super updateInterface:timer];
    
}
 */

- (void)updateMenus {
    
    [super updateMenus];
    
    // Adapt 'Pause' item of contextual menu of listView
    BOOL paused = [self.project isPaused];
    NSMenuItem *pauseItem = [contextualMenu itemAtIndex:1];
    [pauseItem setEnabled:self.project.isMirroring];
    [pauseItem setTitle:(paused ? @"Resume" : @"Pause")];
    [pauseItem setAction:(paused ? @selector(resume:) : @selector(pause:))];
    
}

#pragma mark Project Delegate

- (void)projectDidStart:(Project *)project {
    
    [menuView beginUpdates];
    [menuView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withAnimation:NSTableViewAnimationEffectNone];
    [menuView endUpdates];
    
    [super projectDidStart:project];
    
}

#pragma mark Actions

- (IBAction)showContextualMenu:(id)sender {
    
    NSRect firstFrame = [menuView frameOfCellAtColumn:0 row:0];
    NSRect secondFrame = [menuView frameOfCellAtColumn:1 row:0];
    NSPoint location = NSMakePoint(firstFrame.size.width + secondFrame.size.width/2.0, firstFrame.size.height + secondFrame.size.height/2.0);
    [contextualMenu popUpMenuPositioningItem:[contextualMenu itemAtIndex:0] atLocation:location inView:menuView];
    
}

- (IBAction)clearList:(id)sender {
    
    [self.project.files clearFileList];
    
}

- (IBAction)toggleSearch:(id)sender {
        
    if (theme == WindowThemeYosemite)
        [self showSearch:sender];
    else
        [super toggleSearch:sender];
    
}

- (IBAction)hideSearch:(id)sender {
    
    if (theme != WindowThemeYosemite)
        [super hideSearch:sender];
    else {
        
        if ([projectListController filterPredicate]) {
            [projectListController setFilterPredicate:nil];
            [listView reloadData];
        }
        
        [searchField setStringValue:@""];
        
    }
    
}

- (IBAction)showSearch:(id)sender {
    
    if (theme != WindowThemeYosemite)
        [super showSearch:sender];
    else {
        
        BOOL isForFiles = ([menuView selectedRow] == 2); // Searching in files
        [self.window makeFirstResponder:(isForFiles ? filesSearchField : searchField)];
        
        if (!isForFiles) {
            [searchTextView selectAll:self];
            [self setShowDummy:false];
        }
        
    }
    
}

- (IBAction)showStatistics:(id)sender {
    
    if (theme == WindowThemeYosemite)
        [menuView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:false];
    else
        [super showStatistics:sender];
    
}

- (IBAction)switchFileView:(id)sender {
    
    BOOL socketsShown = [[fileListView infoForBinding:NSContentBinding] objectForKey:NSObservedObjectKey] == self.project.sockets;
    
    [self updateFileListView:!socketsShown];
    
}

#pragma mark Events

- (void)windowDidLoad {
    
    if ([self.window respondsToSelector:@selector(setAppearance:)]) { // Prevent scroll view from changing the window color
        [self.window setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
        [[STATISTICS window] setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
        [[OPTIONS window] setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    }
    
    theme = (WindowTheme)[PREFERENCES integerForKey:MainWindowTheme];
    [self readTheme];
    [PREFERENCES addObserver:self forKeyPath:MainWindowTheme options:NSKeyValueObservingOptionNew context:NULL];
    
    [toolbarAddPauseButton setOverrideDrawing:false]; // Disable custom segmented control drawing
    [self updateGradient];
    
    if (theme == WindowThemeYosemite)
        self.project.statistics.outlineView = statsOutlineView;
    
    [self updateFileListView:false];
    
    [super windowDidLoad]; // At the end, as the superclass is responsible for showing the window
    
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
    
    [super windowDidBecomeMain:notification];
    
    [filesStatusField setTextColor:[NSColor darkGrayColor]];
    
    if (theme == WindowThemeYosemite)
        [self.project.statistics setOutlineView:statsOutlineView];
    
}

- (void)windowDidResignMain:(NSNotification *)notification {
    
    [super windowDidResignMain:notification];
    
    [filesStatusField setTextColor:[NSColor lightGrayColor]];
    
}

#pragma mark Table Views

- (void)updateFileListView:(BOOL)showSockets {
    
    id contentController = self.project.files;
    if (showSockets) contentController = self.project.sockets;
    
    // Update interface elements
    [[filesMenu itemAtIndex:1] setTitle:(showSockets ? @"Show Recent Files" : @"Show Active Sockets")];
    [[[fileListView tableColumns] objectAtIndex:1] setIdentifier:(showSockets ? @"socketDescription" : @"fileName")];
    [[[fileListView tableColumns] objectAtIndex:2] setIdentifier:(showSockets ? @"progress" : @"size")];
    ((NSTableHeaderCell *)[[[fileListView tableColumns] objectAtIndex:1] headerCell]).stringValue
    = (showSockets ? @"Description" : @"File");
    ((NSTableHeaderCell *)[[[fileListView tableColumns] objectAtIndex:2] headerCell]).stringValue
    = (showSockets ? @"Progress" : @"Size");
    ((NSButtonCell *)[[[fileListView tableColumns] objectAtIndex:3] dataCell]).image
    = [NSImage imageNamed:(showSockets ? NSImageNameStopProgressFreestandingTemplate : NSImageNameRevealFreestandingTemplate)];
    fileListView.headerView.needsDisplay = true;
    [filesStatusField bind:NSValueBinding toObject:contentController withKeyPath:@"status" options:nil];
    
    // Update bindings
    [fileListView bind:NSContentBinding toObject:contentController withKeyPath:@"arrangedObjects" options:nil];
    [fileListView bind:NSSortDescriptorsBinding toObject:contentController withKeyPath:@"sortDescriptors" options:nil];
    NSString *identifier = nil;
    for (NSTableColumn *column in fileListView.tableColumns) {
        identifier = column.identifier;
        if ([identifier isEqualToString:@"Action"]) {
            if (showSockets) // Set up 'cancel' action (argument is the socket itself)
                [column bind:NSArgumentBinding toObject:contentController withKeyPath:@"arrangedObjects" options:nil];
            [column bind:NSTargetBinding
                toObject:(showSockets ? self : contentController)
             withKeyPath:(showSockets ? @"project" : @"arrangedObjects")
                 options:[NSDictionary dictionaryWithObjectsAndKeys:(showSockets ? @"cancel:" : @"revealInFinder:"), NSSelectorNameBindingOption, nil]];
        }
        else // This also takes care of sorting
            [column bind:NSValueBinding
                toObject:contentController
             withKeyPath:[@"arrangedObjects." stringByAppendingString:column.identifier]
                 options:[NSDictionary dictionaryWithObjectsAndKeys:!showSockets, NSCreatesSortDescriptorBindingOption, nil]];
    }
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if (tableView == menuView)
        return ([[self project] hasStarted] || [[self project] isCompleted] ? 3 : 1);
    else
        return [super numberOfRowsInTableView:tableView];
    
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableView == menuView) {
        
        NSString *identifier = [tableColumn identifier];
        
        if ([identifier isEqualToString:@"Title"]) {
            
            if (row == 0)
                return @"Links";
            else if (row == 1)
                return @"Stats";
            else
                return @"Files";
            
        }
        else if ([identifier isEqualToString:@"Caption"]) {
            
            if (row == 0)
                return [NSString stringWithFormat:@"%lu", (unsigned long)[self project].URLs.count];
            else if (row == 2)
                return [NSString stringWithFormat:@"%lu", (unsigned long)[self project].files.count];
            
        }
        
    }
    else
        return [super tableView:tableView objectValueForTableColumn:tableColumn row:row];
    
    return nil;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    if (tableView == menuView)
        return 30;
    else
        return [super tableView:tableView heightOfRow:row];
    
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableView == menuView) {
        
        NSInteger selectedRow = [tableView selectedRow];
        NSString *identifier = [tableColumn identifier];
        
        if (row == 0 && selectedRow == 0)
            [cell setMenu:contextualMenu];
        else if (row == 2 && selectedRow == 2)
            [cell setMenu:filesMenu];
        else
            [cell setMenu:nil];
        
        if ([identifier isEqualToString:@"Button"]) {
            
            if (selectedRow == row && menuView.hoveredRow == row) {
                
                if (row == 0)
                    cell.image = [NSImage imageNamed:@"AddBubble"], cell.action = @selector(addURL:);
                else if (row == 1)
                    cell.image = nil, cell.action = NULL; // cell.image = [NSImage imageNamed:@"PauseBubble"], cell.action = @selector(pause:);
                else
                    cell.image = [NSImage imageNamed:@"SwitchBubble"], cell.action = @selector(switchFileView:);
                
            }
            else
                cell.image = nil, cell.action = NULL;
            
            [cell setEnabled:true];
            
        }
        else if ([identifier isEqualToString:@"Caption"])
            [cell setEnabled:(row == 0)];
        
    }
    else
        [super tableView:tableView willDisplayCell:cell forTableColumn:tableColumn row:row];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    if ([notification object] == menuView)
        [self loadPanel];
    else
        [super tableViewSelectionDidChange:notification];
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    if (tableView == menuView)
        return (row == 0 || [[self project] hasStarted]);
    
    return [super tableView:tableView shouldSelectRow:row];
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return  (tableView == menuView ? true : [super tableView:tableView shouldShowCellExpansionForTableColumn:tableColumn row:row]);
    
}

- (NSString *)tableView:(NSTableView *)aTableView toolTipForCell:(NSCell *)aCell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    
    if (aTableView == menuView) {
        
        if ([aCell isEnabled]) {
            
            NSString *identifier = [aTableColumn identifier];
            
            if ([identifier isEqualToString:@"Title"]) {
                
                if (row == 0)
                    return @"Links downloaded by this project.";
                else if (row == 1)
                    return @"The statistics of this project.";
                else if (row == 2)
                    return @"Recently downloaded files.";
                
            }
            else if ([identifier isEqualToString:@"Button"] && row == [menuView selectedRow]) {
                
                if (row == 0)
                    return @"Add a new link.";
                else if (row == 1)
                    return @"Pause the project.";
                else
                    return @"Switch between files/sockets.";
                
            }
            
        }
        
        return nil;
        
    }
    
    return [super tableView:aTableView toolTipForCell:aCell rect:rect tableColumn:aTableColumn row:row mouseLocation:mouseLocation];
    
}

#pragma mark Notifications

- (void)updateGradient {
    
    if ([PREFERENCES integerForKey:MainWindowTheme] != WindowThemeClassic)
        [(GradientView *)[windowSplitView secondView] setGradient:nil]; // Remove footer gradient
    else
        [super updateGradient];
    
}

#pragma mark Theme

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:MainWindowTheme]) {
        [self readTheme];
        [self updateGradient];
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

- (void)readTheme {
    
    NSInteger newTheme = [PREFERENCES integerForKey:MainWindowTheme];
    
    if ((newTheme == WindowThemeYosemite || theme == WindowThemeYosemite) && newTheme != theme) { // Different nib
        ProjectWindowControllerLion *newController = [[ProjectWindowControllerYosemite new] autorelease];
        return [self.project setWindowController:newController];
    }
        
    if (newTheme == WindowThemeYosemite) {
        
        for (NSArray *columnArray in @[fileListView.tableColumns, statsOutlineView.tableColumns])
            for (NSTableColumn *column in columnArray) {
                [column setHeaderCell:[[WindowAdaptedTableHeaderCell alloc] initTextCell:[(NSTableHeaderCell *)column.headerCell stringValue]]];
                [(NSTableHeaderCell *)column.headerCell setAlignment:NSCenterTextAlignment];
            }
        
        [self hideStatistics:self];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        if ([self.window respondsToSelector:@selector(setTitlebarAppearsTransparent:)])
            [self.window setTitlebarAppearsTransparent:true];
#pragma clang diagnostic pop
                
        [menuView reloadData];
        
        HeaderView *outlineHeaderView = [HeaderView new];
        headerView.clickable = false; // Disable table header clicks
        [statsOutlineView setHeaderView:outlineHeaderView];
        
        [self loadPanel];
        
    }
    else if (newTheme == WindowThemeClassic) {
        
        self.window.backgroundColor = [NSColor windowBackgroundColor];
        self.window.styleMask &= ~NSTexturedBackgroundWindowMask;
        
        [searchView setColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
        
    }
    else if (newTheme == WindowThemeWhite) {
        
        self.window.styleMask |= NSTexturedBackgroundWindowMask;
        self.window.backgroundColor = [NSColor whiteColor];
        self.window.styleMask |= NSUnifiedTitleAndToolbarWindowMask;
        
        [searchView setColor:[NSColor whiteColor]];
        [searchSplitView setCustomDividerThickness:0.0]; // Remove line above filtering field
        
    }
    
    theme = (WindowTheme)newTheme;
    
}

- (void)loadPanel {
    
    NSInteger selectedIndex = [menuView selectedRow];
    
    if (selectedIndex != -1) {
        
        for (NSView *subview in panelView.subviews)
            [subview removeFromSuperview];
        
        NSView *newPanel = (selectedIndex == 0 ? linksPanel : (selectedIndex == 1 ? statsPanel : filesPanel));
        NSRect newFrame = NSMakeRect(0, 0, panelView.frame.size.width, panelView.frame.size.height);
        
        [newPanel setFrame:newFrame];
        [panelView addSubview:newPanel];
        
    }
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:MainWindowTheme];
    
    if (headerView)
        [headerView release];
    
    [super dealloc];
    
}

@end

//
//  Project Windows
//

#pragma mark - Project Window

@implementation ProjectWindow

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSMenu *toolbarMenu = ((NSView *)self.contentView).superview.menu;
    for (NSMenuItem *item in [toolbarMenu itemArray])
        if ([[item.title lowercaseString] contains:@"hide"]) {
            [toolbarMenu removeItem:item];
            return;
        }
    
}

- (BOOL)makeFirstResponder:(NSResponder *)aResponder {
    
    BOOL success = [super makeFirstResponder:aResponder];
    if (success)
        [(ProjectWindowController *)self.delegate didMakeFirstResponder:aResponder];
    
    return success;
    
}

@end

//
// Project Toolbar
//

#pragma mark - Project Window Toolbar

@interface ProjectWindowToolbar : NSToolbar
@end

@implementation ProjectWindowToolbar

- (void)setDisplayMode:(NSToolbarDisplayMode)displayMode {
    
    [super setDisplayMode:displayMode];
    
    if ([self.delegate isKindOfClass:[ProjectWindowControllerLion class]])
        [(ProjectWindowControllerLion *)self.delegate resizeWindow:false];
    
}

- (void)setSizeMode:(NSToolbarSizeMode)sizeMode {
    
    [super setSizeMode:sizeMode];
    
    if ([self.delegate isKindOfClass:[ProjectWindowControllerLion class]])
        [(ProjectWindowControllerLion *)self.delegate resizeWindow:false];
    
}

@end