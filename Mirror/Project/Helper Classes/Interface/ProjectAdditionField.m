//
//  ProjectAdditionField.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "ProjectAdditionField.h"

#pragma mark Project Addition Field

@implementation ProjectAdditionField

#pragma mark Interface

- (void)awakeFromNib {
    
    NSButtonCell *c = [[NSButtonCell alloc] init];
	[c setButtonType:NSMomentaryChangeButton];
	[c setBezelStyle:NSRegularSquareBezelStyle];
	[c setBordered:false];
	[c setBezeled:false];
	[c setEditable:false];
	[c setImagePosition:NSImageOnly];
	[c setImage:[NSImage imageNamed:@"AddURLTemplate"]];
    [c setAlternateImage:[NSImage imageNamed:@"AddURLTemplate"]];
	[c setTarget:self];
	[c setAction:@selector(performClick:)];
    [c setSendsActionOnEndEditing:false];
    [[self cell] setSearchButtonCell:c];
    [c release];
    
    [self setFocusRingType:NSFocusRingTypeNone];
    
}

@end