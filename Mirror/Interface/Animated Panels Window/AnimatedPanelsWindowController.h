//
//  AnimatedPanelsWindowController.h
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

#import <AppKit/AppKit.h>
#import "AnimatedPanelControllerProtocol.h"

/**
 * The keys used by the `AnimatedPanelsWindowController` class to save some of its options to the shared user defaults.
 *  Use this if you want to allow the user to customize some of the class's aspects.
 */
#define KeepPanelsOnTop @"KeepPanelsOnTop" // Keep the animated panels windows on top of others
#define PanelWindowTheme @"PanelWindowTheme" // The panel window theme (0 = Classic, 1 = White)

/**
 * The `AnimatedPanelsWindowController` class controls a window with panels that can be navigated through.
 *  Switching from one panel to an other is animated.
 */
@interface AnimatedPanelsWindowController : NSWindowController <NSToolbarDelegate, NSWindowDelegate> {
    
    NSMutableOrderedSet *_panelControllers;
    NSMutableArray *_toolbarDefaultItemIdentifiers;
    id<AnimatedPanelControllerProtocol> _activePanelController;
    
}

/**
 * Returns this instance's panel controllers.
 */
- (NSArray *)panelControllers;

/**
 * Set up this instance's panel controllers.
 *
 * @param panelControllers An array of panelControllers. Each viewController must implement the `AnimatedPanelControllerProtocol`.
 */
- (void)setPanelControllers:(NSArray *)panelControllers;

/**
 * Manually activate the given panel controller, with or without animation.
 *
 * @param panelController The panel to activate.
 * @param animate Set to true if animation is desired.
 */
- (void)activatePanelController:(id<AnimatedPanelControllerProtocol>)panelController animate:(BOOL)animate;

@end
