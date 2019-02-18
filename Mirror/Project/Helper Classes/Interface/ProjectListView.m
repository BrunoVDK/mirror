//
//  ProjectListView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import "PreferencesConstants.h"
#import "ProjectListView.h"

#pragma mark Project List View

@implementation ProjectListView

#pragma mark Interface

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    if ([PREFERENCES integerForKey:MainWindowTheme] == WindowThemeWhite)
        [[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] setFill];
    else if ([PREFERENCES integerForKey:MainWindowTheme] == WindowThemeClassic)
        [([[self window] isMainWindow] ? [NSColor colorWithCalibratedWhite:0.73 alpha:1.0] : [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]) setFill];
    else {
        [[NSGraphicsContext currentContext] restoreGraphicsState];
        return;
    }
    
    NSRectFill(NSMakeRect(self.bounds.origin.x, 1, self.bounds.size.width, 1));
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
}

- (void)drawContextMenuHighlight {
    
    
}

#pragma mark Events

- (void)mouseDown:(NSEvent *)event {
    
    [super mouseDown:event];
    
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:point];
    
    if (row == -1)
        [self deselectAll:nil]; // Deselect row if user clicks on empty one
    
}

- (void)keyDown:(NSEvent *)theEvent {
    
    [[self window] keyDown:theEvent];
    
}

@end
