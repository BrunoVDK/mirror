//
//  NumberedCaptionCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NumberedCaptionCell.h"

@implementation NumberedCaptionCell

#pragma mark Interface

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setTextColor:[NSColor whiteColor]];
    [self setBackgroundColor:[NSColor lightGrayColor]];
    
}

#pragma mark Drawing

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    if (![self isEnabled])
        return;
    
    [NSGraphicsContext saveGraphicsState];
    [[NSGraphicsContext currentContext] setShouldAntialias:true];
    
    CGFloat captionWidth = self.attributedStringValue.size.width + 20;
    CGFloat captionHeight = 20.0;
    NSRect frame = NSMakeRect(cellFrame.origin.x + (cellFrame.size.width - captionWidth) / 2,
                              cellFrame.origin.y + (cellFrame.size.height - captionHeight) / 2,
                              captionWidth,
                              captionHeight);
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:10.0 yRadius:10.0];
    [[self backgroundColor] setFill];
    [path fill];
    
    [NSGraphicsContext restoreGraphicsState];
    
    [super drawWithFrame:cellFrame inView:controlView];
    
}

@end
