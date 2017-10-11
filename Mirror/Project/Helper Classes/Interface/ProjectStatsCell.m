//
//  ProjectStatsCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "ColoredView.h"
#import "NSColor+Additions.h"
#import "NSImage+Additions.h"
#import "PreferencesConstants.h"
#import "Project.h"
#import "ProjectURL.h"
#import "ProjectStatsCell.h"
#import "TextView.h"

#pragma mark Private Classes

@interface ProjectStatsCellBorder : ColoredView
@end

#pragma mark - Project Statistics Cell

@interface ProjectStatsCell (Private)

- (void)drawTitleInFrame:(NSRect)theRect;
- (void)drawStatsInFrame:(NSRect)theRect;
- (void)drawIconInFrame:(NSRect)theRect;

@end

@implementation ProjectStatsCell

@synthesize URL = _URL, renderInCircles = _renderInCircles, stats = _stats, color = _color;

#pragma mark Constructors

- (id)copyWithZone:(NSZone *)zone {
    
    ProjectStatsCell *copy = [super copyWithZone:zone];
    
    if (copy) {
        
        copy.color = self.color;
        copy.renderInCircles = self.renderInCircles;
        copy.stats = self.stats;
        copy.URL = self.URL;
        
    }
    
    return copy;
    
}

#pragma mark Interface

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.sendsActionOnEndEditing = false;
    
}

#pragma mark Events

// Based on http://stackoverflow.com/questions/2280317/nsbuttoncell-inside-custom-nscell

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView {
    
    NSUInteger hitType = [super hitTestForEvent:event inRect:cellFrame ofView:controlView];
    
    // NSPoint location = [event locationInWindow];
    // location = [controlView convertPointFromBase:location];
    
    // if (NSMouseInRect(location, buttonRect, [controlView isFlipped]))
        // hitType |= NSCellHitTrackableArea;
    
    return hitType;
    
}

#pragma mark Drawing

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    [NSGraphicsContext saveGraphicsState];
    
    if (self.URL) {
        [self drawIconInFrame:cellFrame];
        [self drawTitleInFrame:cellFrame];
        [self drawStatsInFrame:cellFrame];
    }
    
    [NSGraphicsContext restoreGraphicsState];
    
}

- (void)drawTitleInFrame:(NSRect)theRect {
    
    NSRect titleRect = [self titleRectForBounds:theRect];
    
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    NSColor *textColor = [self.controlView.window isMainWindow] ? [NSColor darkerGrayColor] : [NSColor lightGrayColor];
#else
    NSColor *textColor = [NSColor darkerGrayColor];
#endif
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [self font], NSFontAttributeName,
                                        textColor, NSForegroundColorAttributeName,
                                     nil];

    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(self.URL.title ? self.URL.title : self.URL.URL.absoluteString) attributes:attributes];
    [title drawWithRect:titleRect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
    [title release];
    
}

- (void)drawStatsInFrame:(NSRect)theRect {
    
    // BOOL isEditing = [(NSTextField *)[self controlView] currentEditor] != nil;
    
    NSRect statsRect = [self statsRectForBounds:theRect];

#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    NSColor *textColor = [self.controlView.window isMainWindow] ? [NSColor darkerGrayColor] : [NSColor lightGrayColor];
#else
    NSColor *textColor = [NSColor darkerGrayColor];
#endif
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     STATS_FONT, NSFontAttributeName,
                                     textColor, NSForegroundColorAttributeName,
                                     nil];
    
    NSAttributedString *stats = [[NSAttributedString alloc] initWithString:(self.stats ? self.stats : self.URL.description) attributes:attributes];
    [stats drawWithRect:statsRect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
    [stats release];
    
}

- (void)drawIconInFrame:(NSRect)theRect {
    
    [NSGraphicsContext saveGraphicsState];
    
    NSRect imageRect = [self iconRectForBounds:theRect];
    
    if ([self renderInCircles]) {
        NSBezierPath *imagePath = [NSBezierPath bezierPathWithOvalInRect:imageRect];
        [imagePath addClip]; // Add a clipping oval
    }
    
    NSImage *icon = self.URL.icon;
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    NSImage *grayIcon = [self.URL.icon copyWithTint:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
    if (!IS_MAIN(self.controlView.window))
        icon = grayIcon;
#endif
    [icon drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:true hints:nil];
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
    [grayIcon release];
#endif
    
    [NSGraphicsContext restoreGraphicsState];
        
}

#pragma mark Editing

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    
    if (!self.isEditable)
        return;
    
    NSRect titleFrame = [self titleRectForBounds:aRect];
    [super selectWithFrame:titleFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
    
    NSString *url;
    NSRange selectedRange;
    
    if (!self.URL.URL) {
        url = BASE_URL;
        selectedRange = BASE_URL_SELECT_RANGE;
    }
    else {
        url = [self.URL.URL absoluteString];
        NSString *host = [self.URL.URL host];
        if ([host hasPrefix:@"www."])
            host = [host substringFromIndex:4];
        if (host)
            selectedRange = [url rangeOfString:[host stringByAppendingString:[self.URL.URL path]]];
        else
            selectedRange = NSMakeRange(0, url.length);
    }
    
    // Attribute modifications after super call, or the alterations are undone
    // Note that it can be assumed that the input text view is a member of TextView, so it can be cast
    TextView *textView = (TextView *)textObj;
    [textView setFieldEditor:true];
    textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = NSMakeSize(0, 0);
    textView.font = self.font;
    textView.alignment = NSLeftTextAlignment;
    textView.textColor = ([controlView.window isMainWindow] ? [NSColor darkerGrayColor] : [NSColor lightGrayColor]);
    textView.string = url;
    textView.selectedRange = selectedRange;
    textView.focusRingType = NSFocusRingTypeNone; // Hide focus ring
    textView.textContainer.containerSize = NSMakeSize(3000, textView.frame.size.height);
    textView.drawsBackground = true;
    textView.backgroundColor = self.color;
    
    NSRect outerRect = NSMakeRect(titleFrame.origin.x - 3, titleFrame.origin.y - 2, titleFrame.size.width +  5, titleFrame.size.height + 4);
    if (!borderView)
        borderView = [ProjectStatsCellBorder new];
    borderView.frame = outerRect;
    borderView.color = self.color;
    
    [controlView addSubview:borderView];
    
}

- (void)endEditing:(NSText *)textObj {
    
    [borderView removeFromSuperview];
    
    [super endEditing:textObj];
    
}

#pragma mark Getters

- (NSRect)titleRectForBounds:(NSRect)theRect {
    
    CGFloat side = theRect.size.height / 2;
    CGFloat titleX = theRect.origin.x + side * 3;
    NSRect titleRect = NSMakeRect(titleX, theRect.origin.y + 11, theRect.size.width - titleX - 30, 15);
    
    return titleRect;
    
}

- (NSRect)statsRectForBounds:(NSRect)theRect {
    
    CGFloat side = theRect.size.height / 2;
    CGFloat statsX = theRect.origin.x + side * 3 + 5;
    NSRect statsRect = NSMakeRect(statsX, theRect.origin.y + 26, theRect.size.width - statsX - 30, 12);
    
    return statsRect;
    
}

- (NSRect)iconRectForBounds:(NSRect)theRect {
    
    CGFloat side = theRect.size.height / 2;
    NSRect imageRect = NSMakeRect(theRect.origin.x + side, theRect.origin.y + (theRect.size.height - side) / 2, side, side);
    
    return imageRect;
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_stats release];
    [borderView release];
    
    [super dealloc];
    
}

@end

//
// Project Stats Cell Border
//  This is a bit of an odd class to solve an issue with a white border around an edited project stats cell (the dummy).
//  The code is a hack that draws a border of a appropriate thickness and color in a ProjectStatsCell so as to conceal the white
//   border around an URL that's been edited.
//

#pragma mark - Project Stats Cell Border

@implementation ProjectStatsCellBorder

- (void)drawRect:(NSRect)dirtyRect {
    
    if (self.color) {
        
        [NSGraphicsContext saveGraphicsState];
        
        NSRect innerRect = NSInsetRect(self.bounds, 4, 2); // Bounds, not dirtyRect, latter can have offset
        
        [[self color] setFill];
        
        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
        [clipPath appendBezierPathWithRect:innerRect];
        [clipPath setWindingRule:NSEvenOddWindingRule];
        [clipPath setClip];
        NSRectFill(dirtyRect);
        
        [NSGraphicsContext restoreGraphicsState];
        
    }
    
}

@end