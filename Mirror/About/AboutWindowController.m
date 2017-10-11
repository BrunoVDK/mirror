//
//  AboutWindowController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 25/06/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import "AboutWindowController.h"
#import "NSColor+Additions.h"
#import "NSImage+Additions.h"
#import "NSString+Additions.h"
#import "PointerButton.h"
#import "PreferencesConstants.h"
#import "PreferencesWindowController.h"
#import "ScrollingTextView.h"

#pragma mark About Window Controller

@implementation AboutWindowController

#pragma mark Singleton

+ (id)sharedController { // Singleton
    
    static dispatch_once_t token = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&token, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
    
}

#pragma mark Interface

- (void)windowDidLoad {
    
    [super windowDidLoad];
    
    [self readTheme]; // Ties into the options of AnimatedPanelWindowController class, customizing the about window accordingly
    [PREFERENCES addObserver:self forKeyPath:PanelWindowTheme options:NSKeyValueObservingOptionNew context:NULL];
    [PREFERENCES addObserver:self forKeyPath:KeepPanelsOnTop options:NSKeyValueObservingOptionNew context:NULL];
    
    [scrollingTextView setString:[NSString stringWithFormat:@"\n\n\n\n%@\n\n\n\n", ABOUT_TEXT]];
    [iconView setImage:[NSApp applicationIconImage]];
    
    [self.window center];
    [self.window makeKeyAndOrderFront:self];
        
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    
    [self.window resetCursorRects]; // Temporary solution, for some reason the tracking rects of the pointer button is screwed up otherwise

#if CHANGE_NONKEY_WINDOW_DESIGN
    NSColor *primaryColor = [NSColor darkerGrayColor];
    [scrollingTextView setTextColor:primaryColor];
    [iconView setImage:[NSApp applicationIconImage]];
    [sourceButton setAttributedTitle:[NSString attributedStringWithTitle:[sourceButton title] color:primaryColor font:[sourceButton font] alignment:kCTCenterTextAlignment]];
    [emailButton setAttributedTitle:[NSString attributedStringWithTitle:[emailButton title] color:primaryColor font:[emailButton font] alignment:kCTCenterTextAlignment]];
    [version setTextColor:primaryColor];
#endif
    
}

- (void)windowDidResignKey:(NSNotification *)notification {
    
#if CHANGE_NONKEY_WINDOW_DESIGN
    NSColor *secondaryColor = [NSColor lightGrayColor];
    [scrollingTextView setTextColor:[NSColor lightGrayColor]];
    [iconView setImage:[[NSApp applicationIconImage] copyWithTint:secondaryColor]];
    [sourceButton setAttributedTitle:[NSString attributedStringWithTitle:[sourceButton title] color:secondaryColor font:[sourceButton font] alignment:kCTCenterTextAlignment]];
    [emailButton setAttributedTitle:[NSString attributedStringWithTitle:[emailButton title] color:secondaryColor font:[emailButton font] alignment:kCTCenterTextAlignment]];
    [version setTextColor:secondaryColor];
#endif
    
}

- (NSString *)windowNibName {
    
    return @"AboutWindowController";
    
}

#pragma mark Theme

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self readTheme];
    if ([keyPath isEqualToString:KeepPanelsOnTop] && [[[PreferencesWindowController sharedPreferences] window] isVisible])
        [[[PreferencesWindowController sharedPreferences] window] makeKeyAndOrderFront:self];
    
}

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

#pragma mark Window Delegation

- (void)windowWillClose:(NSNotification *)notification {
    
    [scrollingTextView stick];
    
}

#pragma mark Utility Functions

- (NSAttributedString *)newStringFromHTML:(NSString *)html withFont:(NSFont *)font {
    
    if (!font)
        font = [NSFont systemFontOfSize:0.0];  // Default font
    html = [NSString stringWithFormat:@"<span style=\"font-family:'%@'; font-size:%dpx;\">%@</span>", [font fontName], (int)[font pointSize], html];
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithHTML:data documentAttributes:nil];
    
}

#pragma mark Actions

- (IBAction)sourceCode:(id)sender {
    
    NSURL *sourceCodeURL = [NSURL URLWithString:@"https://github.com/BrunoVandekerkhove"];
    [[NSWorkspace sharedWorkspace] openURL:sourceCodeURL];
    
}

- (IBAction)sendEmail:(id)sender {
    
    NSString *encodedTo = [@"brunovandekerkhove2@gmail.com" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedURLString = [NSString stringWithFormat:@"mailto:%@", encodedTo];
    NSURL *mailtoURL = [NSURL URLWithString:encodedURLString];
    [[NSWorkspace sharedWorkspace] openURL:mailtoURL];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:PanelWindowTheme context:NULL];
    [PREFERENCES removeObserver:self forKeyPath:KeepPanelsOnTop context:NULL];
    [scrollingTextView release];
    [iconView release];
    
    [super dealloc];
    
}

@end
