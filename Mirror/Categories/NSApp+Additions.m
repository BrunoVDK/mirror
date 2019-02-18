//
//  NSApp+NSApp_Additions.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 30/11/15.
//  Copyright (c) 2015 CZ. All rights reserved.
//

#import "NSApp+Additions.h"

#pragma mark NSApplication + Additions

@implementation NSApplication (Additions)

- (void)beginSheet:(NSWindow *)sheet modalForWindow:(NSWindow *)docWindow didEndBlock:(void (^)(NSInteger returnCode))block {
    
    [self beginSheet:sheet
      modalForWindow:docWindow
       modalDelegate:self
      didEndSelector:@selector(my_blockSheetDidEnd:returnCode:contextInfo:)
         contextInfo:[block copy]];
    
}

- (void)my_blockSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    
    void (^block)(NSInteger returnCode) = contextInfo;
    block(returnCode);
    [block release];
    
}

@end
