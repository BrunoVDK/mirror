//
//  WindowAdaptedCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/02/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "NSColor+Additions.h"
#import "NSImage+Additions.h"
#import "WindowAdaptedCell.h"

#pragma mark Window Adapted Cell

@implementation WindowAdaptedCell

@end

#pragma mark Window Adapted Text Field Cell

@implementation WindowAdaptedTextFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    [self setTextColor:(IS_MAIN(self.controlView.window) ? [NSColor darkerGrayColor] : [NSColor lightGrayColor])];
#endif
    
    [super drawWithFrame:cellFrame inView:controlView];
    
}

@end

#pragma mark Window Adapted Button Cell

@implementation WindowAdaptedButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    [self setEnabled:IS_MAIN(self.controlView.window)];
#endif
                        
    [super drawWithFrame:cellFrame inView:controlView];
    
}

@end

#pragma mark Window Adapted Image Cell

@implementation WindowAdaptedImageCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    if (!IS_MAIN(self.controlView.window)) {
        NSImage *grayImage = [self.image copyWithTint:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
        self.image = grayImage;
        [grayImage release];
    }
#endif
    
    [super drawWithFrame:cellFrame inView:controlView];
    
}

@end

#pragma mark Window Adapted Table Header Cell

@implementation WindowAdaptedTableHeaderCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    
    
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    if (!IS_MAIN(controlView.window)) {
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self font], NSFontAttributeName,
                                    [NSColor lightGrayColor], NSForegroundColorAttributeName,
                                    nil];
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.stringValue attributes:attributes];
        NSSize titleSize = [title size];
        cellFrame.origin.x += (cellFrame.size.width - titleSize.width) / 2;
        cellFrame.size.width = titleSize.width;
        [title drawWithRect:cellFrame options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [title release];
        
        return;
        
    }
#endif
    
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
}

@end

#pragma mark Window Adapted Table View

@implementation WindowAdaptedTableView

#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    
    if (newWindow) {
        
        [NOTIFICATION_CENTER addObserver:self selector:@selector(windowDidChangeStatus:) name:NSWindowDidBecomeMainNotification object:newWindow];
        [NOTIFICATION_CENTER addObserver:self selector:@selector(windowDidChangeStatus:) name:NSWindowDidResignMainNotification object:newWindow];
        
    }
    else {
        
        [NOTIFICATION_CENTER removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
        [NOTIFICATION_CENTER removeObserver:self name:NSWindowDidResignMainNotification object:nil];
        
    }
    
    [super viewWillMoveToWindow:newWindow];
    
}

- (void)windowDidChangeStatus:(NSNotification *)notification {
    
    [self reloadData];
    [self.headerView setNeedsDisplay:true];
    
}

- (void)dealloc {
    
    [NOTIFICATION_CENTER removeObserver:self];
    
    [super dealloc];
    
}

#endif

@end

#pragma mark Window Adapted Outline View

@implementation WindowAdaptedOutlineView

#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    
    // [self tile];
    
    if (newWindow) {
        
        [NOTIFICATION_CENTER addObserver:self selector:@selector(windowDidChangeStatus:) name:NSWindowDidBecomeMainNotification object:newWindow];
        [NOTIFICATION_CENTER addObserver:self selector:@selector(windowDidChangeStatus:) name:NSWindowDidResignMainNotification object:newWindow];
        
    }
    else {
        
        [NOTIFICATION_CENTER removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
        [NOTIFICATION_CENTER removeObserver:self name:NSWindowDidResignMainNotification object:nil];
        
    }
    
    [super viewWillMoveToWindow:newWindow];
    
}

- (void)windowDidChangeStatus:(NSNotification *)notification {
    
    for (id subview in self.subviews)
        if ([subview respondsToSelector:@selector(setEnabled:)])
            [subview setEnabled:self.window.isKeyWindow];
    
    [self reloadData];
    
}

- (void)dealloc {
    
    [NOTIFICATION_CENTER removeObserver:self];
    
    [super dealloc];
    
}

#endif

@end
