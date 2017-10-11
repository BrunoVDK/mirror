//
//  AnimatedPanelsWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

//
//  Adapted from Frank Gregor's CCNPreferencesWindowController
//  The MIT License (MIT)
//  Copyright © 2014 Frank Gregor, <phranck@cocoanaut.com>
//  http://cocoanaut.mit-license.org
//

#import <QuartzCore/QuartzCore.h>
#import "AnimatedPanelsWindowController.h"
#import "NSImage+Additions.h"

@interface AnimatedPanelsWindow : NSPanel
@end

#pragma mark - AnimatedPanelsWindowController

@implementation AnimatedPanelsWindowController

#pragma mark Constructors

- (instancetype)init {
    
    if (self = [super init]) {
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            KeepPanelsOnTop : @YES,
            PanelWindowTheme : [NSNumber numberWithInt:1], // White
        }];
        
        _panelControllers = [NSMutableOrderedSet new];
        _activePanelController = nil;
        AnimatedPanelsWindow *window = [AnimatedPanelsWindow new];
        self.window = window;
        self.window.styleMask &= ~NSResizableWindowMask | NSUtilityWindowMask;
        [window release];
        
        [self readTheme];
        [PREFERENCES addObserver:self forKeyPath:PanelWindowTheme options:NSKeyValueObservingOptionNew context:NULL];
        [PREFERENCES addObserver:self forKeyPath:KeepPanelsOnTop options:NSKeyValueObservingOptionNew context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:self.window];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:self.window];
        
    }
    
    return self;
    
}

#pragma mark Initialization

- (void)setupToolbar {
    
    static int i = 0;

    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:[NSString stringWithFormat:@"%@%i", @"PanelsToolbar", i++]];
    toolbar.allowsUserCustomization = toolbar.autosavesConfiguration = false;
    toolbar.showsBaselineSeparator = true;
    toolbar.delegate = self;
    toolbar.sizeMode = NSToolbarSizeModeSmall;
    self.window.toolbar = toolbar;
    
}

#pragma mark Notifications

- (void)windowDidResignKey:(NSNotification *)notification {
    
    [self activatePanelController:_activePanelController animate:false];
    
#if CHANGE_NONKEY_WINDOW_DESIGN
    [self updateWindow];
#endif
    
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    
    [self activatePanelController:_activePanelController animate:false];
    
#if CHANGE_NONKEY_WINDOW_DESIGN
    [self updateWindow];
#endif
    
}

- (void)updateWindow {
    
    for (NSToolbarItem *item in self.window.toolbar.items) {
        
        id<AnimatedPanelControllerProtocol> vc = [self panelControllerWithIdentifier:[item itemIdentifier]];
        
        if (IS_MAIN(self.window))
            [item setImage:[vc panelIcon]];
        else {
            NSImage *newImage = [[vc panelIcon] copyWithTint:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]];
            [item setImage:newImage];
            [newImage release];
        }
        
    }
    
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

#pragma mark API

- (NSArray *)panelControllers {
    
    return [_panelControllers array];
    
}

- (void)setPanelControllers:(NSArray *)panelControllers {
    
    for (id panelController in panelControllers)
        [self addPanelController:panelController];
    
    [self setupToolbar];
    
}

- (void)showWindow:(id)sender {
    
    if ([_panelControllers count] < 1)
        return;
    
    self.window.alphaValue = 0.0;
    [self.window makeKeyAndOrderFront:self];

    NSInteger activeIndex = 0;
    if (!_activePanelController) {
        [self activatePanelController:_panelControllers.firstObject animate:false];
        [self.window center];
    }
    else
        activeIndex = [_panelControllers indexOfObject:_activePanelController];
    
    if (self.window.toolbar)
        [self.window.toolbar setSelectedItemIdentifier:[_toolbarDefaultItemIdentifiers objectAtIndex:activeIndex + 1]];
    
    self.window.alphaValue = 1.0;
    
}

- (void)dismissController {
    
    [self close];
    
}

#pragma mark Helper

- (NSSize)maxSegmentSizeForCurrentViewControllers {
    
    NSSize maxSize = NSMakeSize(42, 0);
    
    for (NSViewController *panelController in _panelControllers) {
        
        NSString *title = [panelController performSelector:@selector(preferenceTitle)];
        NSSize titleSize = [title sizeWithAttributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]] }];
        if (titleSize.width + 36 > maxSize.width)
            maxSize =  NSMakeSize(ceilf(titleSize.width) + 36, ceilf(titleSize.height) + 12);
        
    }
    
    return maxSize;
    
}

- (void)addPanelController:(id<AnimatedPanelControllerProtocol>)panelController {
    
    NSAssert([panelController conformsToProtocol:@protocol(AnimatedPanelControllerProtocol)], @"ERROR: The viewController [%@] must conform to protocol <AnimatedPanelControllerProtocol>", [panelController class]);

    [_panelControllers addObject:panelController];
    
}

- (id<AnimatedPanelControllerProtocol>)panelControllerWithIdentifier:(NSString *)identifier {
    
    for (id<AnimatedPanelControllerProtocol> panelController in _panelControllers)
        if ([[panelController panelIdentifier] isEqualToString:identifier])
            return panelController;
    
    return nil;
    
}

- (void)activatePanelController:(id<AnimatedPanelControllerProtocol>)panelController animate:(BOOL)animate {
    
    for (NSView *subview in [self.window.contentView subviews])
        [subview removeFromSuperview];
    
    NSView *newView = [(NSViewController *)panelController view];
    NSRect currentWindowFrame = self.window.frame;
    NSRect contentViewFrame = newView.frame;
    contentViewFrame.origin = NSMakePoint(0, 0); // Or there might be a shift
    NSRect newWindowFrame = self.window.frame;
    
    BOOL resizable = (self.window.styleMask & ~NSResizableWindowMask) != self.window.styleMask;
    
    if (resizable) {
        
        contentViewFrame.size = ((NSView *)self.window.contentView).frame.size;
        [newView setFrame:contentViewFrame];
        
    }
    else {
        
        [self.window.contentView setFrame:contentViewFrame];
        NSRect frameRectForContentRect = [self.window frameRectForContentRect:contentViewFrame];
        CGFloat deltaX = NSWidth(currentWindowFrame) - NSWidth(frameRectForContentRect);
        CGFloat deltaY = NSHeight(currentWindowFrame) - NSHeight(frameRectForContentRect);
        newWindowFrame = NSMakeRect(NSMinX(currentWindowFrame) + deltaX / 2,
                                    NSMinY(currentWindowFrame) + deltaY,
                                    NSWidth(frameRectForContentRect),
                                    NSHeight(frameRectForContentRect));
        
    }
    
    newView.alphaValue = 0;
    [newView setFrameOrigin:NSMakePoint(0, 0)];
    [self.window.contentView addSubview:newView];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = (animate && !resizable ? 0.25 : 0);
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [[self.window animator] setFrame:newWindowFrame display:true];
        [[newView animator] setAlphaValue:1.0];
    } completionHandler:^{
        _activePanelController = panelController;
    }];
    
}

#pragma mark NSToolbarItem Actions

- (void)toolbarItemAction:(NSToolbarItem *)toolbarItem {
    
    if (![[_activePanelController panelIdentifier] isEqualToString:toolbarItem.itemIdentifier]) {
        id<AnimatedPanelControllerProtocol> panelController = [self panelControllerWithIdentifier:toolbarItem.itemIdentifier];
        [self activatePanelController:panelController animate:true];
    }
    
}

#pragma mark NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
    if ([itemIdentifier isEqualToString:NSToolbarFlexibleSpaceItemIdentifier])
        return nil;
    else {
        
        id<AnimatedPanelControllerProtocol> panelController = [self panelControllerWithIdentifier:itemIdentifier];
        NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:[panelController panelIdentifier]];
        toolbarItem.label          = toolbarItem.paletteLabel = [panelController panelTitle];
        toolbarItem.image          = [panelController panelIcon];
        toolbarItem.toolTip        = ([panelController respondsToSelector:@selector(panelToolTip)] ? [panelController panelToolTip] : nil);
        toolbarItem.target         = self;
        toolbarItem.action         = @selector(toolbarItemAction:);
        
        return toolbarItem;
        
    }
    
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    
    if (!_toolbarDefaultItemIdentifiers && _panelControllers.count > 0) {
        
        _toolbarDefaultItemIdentifiers = [[NSMutableArray alloc] init];
        [_toolbarDefaultItemIdentifiers insertObject:NSToolbarFlexibleSpaceItemIdentifier atIndex:0];
        
        NSInteger offset = _toolbarDefaultItemIdentifiers.count;
        [_panelControllers enumerateObjectsUsingBlock:^(id<AnimatedPanelControllerProtocol>panelController, NSUInteger idx, BOOL *stop) {
            [_toolbarDefaultItemIdentifiers insertObject:[panelController panelIdentifier] atIndex:idx + offset];
        }];
        
        [_toolbarDefaultItemIdentifiers insertObject:NSToolbarFlexibleSpaceItemIdentifier atIndex:_toolbarDefaultItemIdentifiers.count];
        
    }
    
    return _toolbarDefaultItemIdentifiers;
    
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    
    return [self toolbarDefaultItemIdentifiers:toolbar];
    
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    
    return [self toolbarDefaultItemIdentifiers:toolbar];
    
}

#pragma mark - Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:PanelWindowTheme context:NULL];
    [PREFERENCES removeObserver:self forKeyPath:KeepPanelsOnTop context:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_panelControllers release];
    [_activePanelController release];
    [_toolbarDefaultItemIdentifiers release];
    
    [super dealloc];
    
}

@end

#pragma mark - Animated Panels Window

@implementation AnimatedPanelsWindow

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    
    if ([menuItem action] == @selector(toggleToolbarShown:))
        return false;
    
    return [super validateMenuItem:menuItem];
    
}

- (void)keyDown:(NSEvent *)theEvent {
    
    switch(theEvent.keyCode) {
        case 53: // Escape key
            [self orderOut:nil];
            [self close];
            break;
        default: [super keyDown:theEvent];
    }
    
}

@end