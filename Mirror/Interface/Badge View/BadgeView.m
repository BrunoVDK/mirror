//
//  BadgeView.m
//
//  Created by Bruno Vandekerkhove on 22/08/15.
//  Copyright (c) 2015 Bruno VDK. All rights reserved.
//

#import "BadgeView.h"

#pragma mark Badge View

@implementation BadgeView

@synthesize visible = _visible, message = _message;

#pragma mark Constructors

+ (id)sharedView { // Singleton
    
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        
        NSRect frame = NSZeroRect;
        frame.size = [NSApp dockTile].size;
        _sharedObject = [[self alloc] initWithFrame:frame];
        
        [[NSApp dockTile] setContentView:_sharedObject];
        
    });
    
    return _sharedObject;
    
}

- (id)init {
    
    return [BadgeView sharedView];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return [BadgeView sharedView];
    
}

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect]) {
        
        self.message = @"-- / s";
        badgeImage = [[NSImage imageNamed:@"Badge"] retain];
        
    }
    
    return self;
    
}

#pragma Drawing

- (void)setVisible:(BOOL)visible {
    
    _visible = visible;
    
    [[NSApp dockTile] display];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    
    [[NSApp applicationIconImage] drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    if (!self.isVisible)
        return;
    
    NSShadow *stringShadow = [[NSShadow alloc] init];
    [stringShadow setShadowOffset:NSMakeSize(2.0, -2.0)];
    [stringShadow setShadowBlurRadius:4.0];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:3];
    [attributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributes setObject:stringShadow forKey:NSShadowAttributeName];
    
    NSSize imageSize = [badgeImage size];
    
#define BADGE_TILE_PADDING 10.0
    CGFloat badgeHeight = ((self.bounds.size.width - BADGE_TILE_PADDING * 2.0) / imageSize.width) * imageSize.height;
    NSRect badgeRect = NSInsetRect(self.bounds, BADGE_TILE_PADDING, (self.bounds.size.height - badgeHeight) / 2);
    [badgeImage drawInRect:badgeRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
#define BADGE_TEXT_PADDING 20.0
    CGFloat fontSize = 26.0;
    NSSize stringSize;
    do {
        [attributes setObject:[NSFont boldSystemFontOfSize:fontSize] forKey:NSFontAttributeName];
        stringSize = [self.message sizeWithAttributes:attributes];
        fontSize -= 1.0;
    } while (NSWidth(badgeRect) - BADGE_TEXT_PADDING < stringSize.width);
    
    NSRect stringRect;
    stringRect.origin.x = NSMidX(badgeRect) - stringSize.width * 0.5;
    stringRect.origin.y = NSMidY(badgeRect) - stringSize.height * 0.5 + 1.0; // Adjust for shadow
    stringRect.size = stringSize;
    
    [self.message drawInRect:stringRect withAttributes:attributes];
    
    [attributes release];
    [stringShadow release];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [badgeImage release];
    
    [super dealloc];
    
}

@end