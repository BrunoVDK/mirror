//
//  AboutWindowController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 25/06/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AnimatedPanelsWindowController.h"

@class PointerButton;
@class ScrollingTextView;

/**
 * The `AboutWindowController` class controls the about window of this application.
 */
@interface AboutWindowController : NSWindowController<NSWindowDelegate> {
    
    IBOutlet ScrollingTextView *scrollingTextView;
    IBOutlet NSImageView *iconView;
    IBOutlet PointerButton *emailButton, *sourceButton;
    IBOutlet NSTextField *version;
    
}

/**
 * Get the shared about window controller.
 *
 * @return A singleton, this application's about window controller.
 */
+ (id)sharedController;

/**
 * Open an URL having an overview of the source code of this application.
 *
 * @param sender The sender of this action.
 */
- (IBAction)sourceCode:(id)sender;

/**
 * Open an URL for emailing the developer of this application.
 *
 * @param sender The sender of this action.
 */
- (IBAction)sendEmail:(id)sender;

@end
