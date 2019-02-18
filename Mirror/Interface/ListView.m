//
//  ListView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 01/07/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "ListView.h"
#import "PreferencesConstants.h"

@implementation ListView

@synthesize alternateColor = _alternateColor, odd = _odd;

#pragma mark Insertion/Removal

- (void)insertRowsAtIndexes:(NSIndexSet *)indexes withAnimation:(NSTableViewAnimationOptions)animationOptions {
    
    _odd = !_odd;
    [super insertRowsAtIndexes:indexes withAnimation:animationOptions];
    
}

- (void)removeRowsAtIndexes:(NSIndexSet *)indexes withAnimation:(NSTableViewAnimationOptions)animationOptions {
    
    _odd = !_odd;
    [super removeRowsAtIndexes:indexes withAnimation:animationOptions];
    
}

#pragma mark Drawing

- (void)awakeFromNib {
    
    _odd = true;
    [super awakeFromNib];
    
}

- (void)reloadVisibleRect {
    
    [self reloadDataForRowIndexes:[NSIndexSet indexSetWithIndexesInRange:[self rowsInRect:[self visibleRect]]]
                        columnIndexes:[self columnIndexesInRect:[self visibleRect]]];
    
}

- (void)setAlternateColor:(NSColor *)alternateColor {
    
    if (_alternateColor != alternateColor) {
        [_alternateColor release];
        _alternateColor = [alternateColor copy];
        [self setNeedsDisplay:true];
    }
    
}

- (void)drawRect:(NSRect)dirtyRect {
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    if (![[self window] isKeyWindow]) { // Bit of a weird piece of code to avoid a black border around cells that are being edited while the window is not key
        
        [self drawBackgroundInClipRect:dirtyRect];
        
        NSRange range = [self rowsInRect:dirtyRect];
        for (NSInteger row = range.location ; row < range.location + range.length ; row++)
            [self drawRow:row clipRect:dirtyRect];
        
    }
    else
        [super drawRect:dirtyRect];

    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
}

- (void)drawBackgroundInClipRect:(NSRect)clipRect {
    
    [[self backgroundColor] set];
    NSRectFill(clipRect);
    
    if (!self.usesAlternatingRowBackgroundColors)
        return;
    
    [_alternateColor set];
    
    NSRect checkRect = [self bounds];
    checkRect.origin.y = clipRect.origin.y;
    checkRect.size.height = clipRect.size.height;
    NSRange rowsToDraw = [self rowsInRect:checkRect];
    NSUInteger curRow = rowsToDraw.location;
    
    while(curRow < rowsToDraw.location + rowsToDraw.length) {
        
        if(curRow % 2 != _odd) {
            NSRect rowRect = [self rectOfRow:curRow];
            rowRect.origin.x = clipRect.origin.x;
            rowRect.size.width = clipRect.size.width;
            NSRectFill(rowRect);
        }
        
        curRow++;
        
    }
    
    CGFloat rowHeight = [self rowHeight];
    if( ([self gridStyleMask] & NSTableViewSolidHorizontalGridLineMask) == NSTableViewSolidHorizontalGridLineMask
       || ([self gridStyleMask] & NSTableViewDashedHorizontalGridLineMask) == NSTableViewDashedHorizontalGridLineMask) {
        rowHeight += 2.0f;
    }
    
    CGFloat virtualRowOrigin = 0.0f;
    NSInteger virtualRowNumber = [self numberOfRows];
    if([self numberOfRows] > 0) {
        NSRect finalRect = [self rectOfRow:[self numberOfRows]-1];
        virtualRowOrigin = finalRect.origin.y + finalRect.size.height;
    }
    while(virtualRowOrigin < clipRect.origin.y + clipRect.size.height) {
        
        if(virtualRowNumber % 2 != _odd) {
            NSRect virtualRowRect = NSMakeRect(clipRect.origin.x,virtualRowOrigin,clipRect.size.width,rowHeight);
            NSRectFill(virtualRowRect);
        }
        
        virtualRowNumber++;
        virtualRowOrigin += rowHeight;
        
    }
    
    virtualRowOrigin = -1 * rowHeight;
    virtualRowNumber = -1;
    while(virtualRowOrigin + rowHeight > clipRect.origin.y) {
        
        if(abs((int)virtualRowNumber) % 2 != _odd) {
            NSRect virtualRowRect = NSMakeRect(clipRect.origin.x,virtualRowOrigin,clipRect.size.width,rowHeight);
            NSRectFill(virtualRowRect);
        }
        
        virtualRowNumber--;
        virtualRowOrigin -= rowHeight;
        
    }
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_alternateColor release];
    [super dealloc];
    
}

@end
