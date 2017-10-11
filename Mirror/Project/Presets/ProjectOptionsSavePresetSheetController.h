//
//  ProjectOptionsSavePresetSheetController.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/12/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ProjectOptionsSavePresetSheetDelegate;

/**
 * The `ProjectSavePresetSheetController` class controls a sheet with which a user can easily save the options
 *  of a `Project` as a custom 'preset'.
 */
@interface ProjectOptionsSavePresetSheetController : NSWindowController {
    
    id<ProjectOptionsSavePresetSheetDelegate> _delegate;
    
    NSWindow *modalWindow; // For Yosemite+
    void (^block)(NSInteger returnCode);
    IBOutlet NSTextField *textField, *warningLabel;
    IBOutlet NSButton *cancelButton, *okButton;
    
}

/**
 * This controller's delegate.
 */
@property (nonatomic, assign) id<ProjectOptionsSavePresetSheetDelegate> delegate;

/**
 * The current preset name entered in the sheet's text field.
 */
- (NSString *)presetName;

/**
 * Present the preset saving sheet as a sheet.
 *
 * @param window The window to attach the sheet to.
 * @param completionBlock The block of code to run when the sheet has been dismissed for whatever reason.
 */
- (void)presentOnWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse code))completionBlock;

@end

/**
 * The `ProjectOptionsSavePresetSheetDelegate` protocol allows a delegate of preset saving sheet controller to prevent the use of particular preset names.
 */
@protocol ProjectOptionsSavePresetSheetDelegate <NSObject>

/**
 * Called when a project options save preset sheet controller wants to create a new preset, to make sure that the new preset's name is permissible.
 *
 * @param controller The sheet controller.
 * @param presetName The name for the new preset.
 * @return An error description if the given preset name is not permissible, or nil or an empty string if it is.
 */
- (NSString *)projectOptionsSavePresetSheetController:(ProjectOptionsSavePresetSheetController *)controller errorForPresetName:(NSString *)presetName;

@end