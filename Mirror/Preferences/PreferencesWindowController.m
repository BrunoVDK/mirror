//
//  PreferencesWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "NSColor+Additions.h"
#import "NSImage+Additions.h"
#import "NSString+Additions.h"
#import "PointerButton.h"

#import "PreferencesConstants.h"
#import "PreferencesPanelController.h"
#import "PreferencesWindowController.h"

#pragma mark Preferences Window Controller

@implementation PreferencesWindowController

#pragma mark Singleton

+ (id)sharedPreferences { // Singleton
    
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject setPanelControllers:@[[[PreferencesGeneralPanelController new] autorelease],
                                             [[PreferencesDownloadsPanelController new] autorelease],
                                             [[PreferencesInterfacePanelController new] autorelease],
                                             [[PreferencesNotificationsPanelController new] autorelease],
                                             [[PreferencesPresetsPanelController new] autorelease]]];
#if DEBUG
        if (![_sharedObject windowIsKey])
            ;//exit(173);
#endif
    });
    
    return _sharedObject;
    
}

#pragma mark Management

- (void)initPreferences {
    
    [PREFERENCES registerDefaults:defaultAppPreferences()];
    if (![self windowIsKey])
        ;//exit(173);
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultAppPreferences()];
    
    if (![PREFERENCES boolForKey:HasLaunched]) { // Reset options
        
        NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
        [PREFERENCES removePersistentDomainForName:domainName];
        
        [PREFERENCES setBool:true forKey:HasLaunched];
        if (IS_PRE_YOSEMITE)
            [PREFERENCES setBool:true forKey:UseLionIcon];
        
    }
    
}

- (void)savePreferences {
    
    // Finish off any synchronisation here
    
}

#pragma mark Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([[[PreferencesWindowController sharedPreferences] window] isVisible])
        [[[PreferencesWindowController sharedPreferences] window] makeKeyAndOrderFront:self];
    
}

#pragma mark Getters

- (BOOL)windowIsKey {
    
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
        return NO;
    
    return YES;
    
}

@end
