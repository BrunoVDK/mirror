//
//  PreferencesConstants.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 25/06/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//
//  App preferences globals, constants, ...
//

#import <Cocoa/Cocoa.h>

#pragma mark Application Preferences

//
// App preferences
//

#define HasLaunched @"HasLaunched5"

#define UseLionIcon @"UseLionIcon"

#define NotifyOnError @"NotifyOnError"
#define NotifyOnCompletion @"NotifyOnCompletion"
#define ShowRateInDock @"ShowRateInDock"
#define AskForConfirmationOnCancel @"AskForConfirmationOnCancel"
#define AddDroppedLinksImmediately @"AddDroppedLinksImmediately"

#define SaveProjectsIn @"SaveProjectsIn"
#define HideCache @"HideCache"
#define BundleProjects @"BundleProjects"

#define RenderIconsInCircles @"RenderIconsInCircles"
#define ResizeAutomatically @"ResizeAutomatically"
#define PleaseNoSpider @"PleaseNoSpider"
#define MainWindowTheme @"MainWindowTheme"
#define MaxFiles @"MaxFiles"
#define MaxUpdates @"MaxUpdates"

/**
 * Get an app preferences dictionary with default values.
 *
 * @return A dictionary having default values for all of this application's preferences.
 */
static NSDictionary *defaultAppPreferences() {
    
    static NSDictionary *preferences = nil;
    
    if (!preferences) {
        
        preferences =  @{
                
            HasLaunched : @NO,
            
            UseLionIcon : @NO,
            
            NotifyOnError : @NO,
            NotifyOnCompletion : @YES,
            ShowRateInDock : @YES,
            AskForConfirmationOnCancel : @YES,
            AddDroppedLinksImmediately : @YES,
            
            SaveProjectsIn : [NSNumber numberWithInt:1],
            HideCache : @YES,
            BundleProjects : @NO,
            
            RenderIconsInCircles : @NO,
            ResizeAutomatically : @NO,
            PleaseNoSpider : @NO,
            MainWindowTheme : [NSNumber numberWithInt:0], // Yosemite
            
            MaxFiles : [NSNumber numberWithInteger:100], // Should currently equal the minimum value
            MaxUpdates : [NSNumber numberWithInteger:100], // Should currently equal the minimum value
        
        };
        
        [preferences retain]; // Increase reference count
                            
    }
    
    return preferences;
    
}