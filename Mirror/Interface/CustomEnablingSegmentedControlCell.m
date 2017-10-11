//
//  CustomEnablingSegmentedControlCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "CustomEnablingSegmentedControlCell.h"

#pragma mark Custom Enabling Segmented Controll Cell

@implementation CustomEnablingSegmentedControlCell

- (void)drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView { // Crappy code but won't be a problem
    
    BOOL enabled = [self isEnabledForSegment:segment];
        
    [self setEnabled:true forSegment:segment];
    [super drawSegment:segment inFrame:frame withView:controlView];
    [self setEnabled:enabled forSegment:segment];
    
}

@end
