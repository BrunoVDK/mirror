//
//  NSApp+NSApp_Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 30/11/15.
//  Copyright (c) 2015 CZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * A category for adding functionality to the `NSApp` class.
 */
@interface NSApplication (Additions)

/**
 * Attach a given sheet to a given window.
 *
 * @param sheet The sheet to show.
 * @param docWindow The window to attach the sheet to.
 * @param block The block of code to run on completion.
 */
- (void)beginSheet:(NSWindow *)sheet modalForWindow:(NSWindow *)docWindow didEndBlock:(void (^)(NSInteger returnCode))block;

@end
