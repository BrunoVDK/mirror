//
//  ProjectMenuView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 17/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "ProjectMenuView.h"

#pragma mark Project Menu View

@implementation ProjectMenuView

@synthesize hoveredRow = _hoveredRow;

#pragma mark Events

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    
    [newWindow invalidateCursorRectsForView:self];
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                options:(NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
                                                  owner:self
                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    _hoveredRow = -1;
    
    gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed:0.90 green:0.90 blue:0.90 alpha:0.8], 0.0,
                [NSColor colorWithDeviceRed:0.80 green:0.80 blue:0.80 alpha:0.8], 1.0,
                nil];
    
}

- (BOOL)acceptsFirstResponder {
    
    return false;
    
}

- (void)mouseMoved:(NSEvent *)theEvent {
    
    [self checkHover:theEvent];
    [super mouseMoved:theEvent];
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    [self checkHover:theEvent];
    [super mouseExited:theEvent];
    
}

- (void)mouseDown:(NSEvent *)theEvent { // Hackish solution to prevent mouse clicks selecting a row from also clicking a button in that newly selected row
    
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:point];
    NSInteger column = [self columnAtPoint:point];
        
    if (column == 1 && self.selectedRow == row)
        [super mouseDown:theEvent];
    else if ([self.delegate respondsToSelector:@selector(tableView:shouldSelectRow:)] && [self.delegate tableView:self shouldSelectRow:row])
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:false];
    
}

- (void)checkHover:(NSEvent *)theEvent {
    
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:point];
    
    if (row != self.hoveredRow) {
        _hoveredRow = row;
        [self reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:1]];
    }
    
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    
    if (row == self.selectedRow)
        [gradient drawInRect:[self rectOfRow:row] relativeCenterPosition:NSMakePoint(-0.6, 1.0)];

    [super drawRow:row clipRect:clipRect];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [trackingArea release];
    [gradient release];
    
    [super dealloc];
    
}

@end

#pragma mark - Project Menu Hover Cell

#define BUTTON_WIDTH 14

@implementation ProjectMenuHoverCell

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp {
    
    NSPoint point = [controlView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if (NSPointInRect(point, cellFrame))
        return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:untilMouseUp];
        
    return false;
    
}

@end
