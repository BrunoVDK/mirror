//
//  ScrollingTextView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "ScrollingTextView.h"

#pragma mark Scrolling Text View

@interface ScrollingTextView (Private)

- (void)toggle;
- (void)newTimer;
- (void)scrollText;
- (void)scrollWithTopOffset:(CGFloat)value;

@end

@implementation ScrollingTextView

#pragma mark Interface

- (void)awakeFromNib {
    
    [super awakeFromNib];
        
    offset = 0.0;
    [self scrollText];
    [self setNeedsDisplay:YES];
    
    [self scroll];
        
}

#pragma mark Actions

- (void)toggle {
    
    if (timer)
        [self stick];
    else
        [self scroll];
    
}

- (void)stick {
    
    if (timer) {
        
        [timer invalidate];
        [timer release];
        timer = nil; // Or might actually release something meaningful
    }
    
}

- (void)scroll {
    
    [self newTimer];
    
}

- (void)newTimer {
    
    if (timer)
        return;
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(scrollText) userInfo:nil repeats:YES] retain];
    
}

- (void)scrollText {
    
    NSScrollView *scrollView = [self enclosingScrollView];
    
    offset++;
    if (offset > [[scrollView documentView] frame].size.height - [[scrollView contentView] bounds].size.height)
        offset =  0.0;

    [self scrollWithTopOffset:offset];
    
}

- (void)scrollWithTopOffset:(CGFloat)value {
    
    NSPoint newScrollOrigin;
    NSScrollView *scrollView = [self enclosingScrollView];
    
    if ([[scrollView documentView] isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0, offset);
    } else {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY([[scrollView documentView] frame]) - NSHeight([[scrollView contentView] bounds]) - offset);
    }
    
    [[scrollView documentView] scrollPoint:newScrollOrigin];
    
}

#pragma mark Events

- (void)mouseEntered:(NSEvent *)theEvent {
    
    [self stick];
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    offset = [[[self enclosingScrollView] contentView] documentVisibleRect].origin.y;
    
    [self scroll];
    
}

#pragma mark Memory Management

- (void)dealloc {
        
    [timer release];
    
    [super dealloc];
    
}

@end
