//
//  WhiteView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 04/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "WhiteView.h"

@implementation WhiteView

- (void)awakeFromNib {
    
    [self setColor:nil];
    [self setAlphaValue:1.0];
    
}

- (void)setColor:(NSColor *)color {
    
    if (!_color) {
        _color = [[NSColor whiteColor] copy];
        [self setNeedsDisplay:true];
    }
    
}

@end
