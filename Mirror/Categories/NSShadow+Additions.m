//
//  NSShadow+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 05/06/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSShadow+Additions.h"

@implementation NSShadow (Additions)

- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur {
    
	self = [self init];
	
	if (self != nil) {
		self.shadowColor = color;
		self.shadowOffset = offset;
		self.shadowBlurRadius = blur;
	}
	
	return self;
    
}

@end
