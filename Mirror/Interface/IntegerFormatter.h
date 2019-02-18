//
//  IntegerFormatter.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 31/05/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The `IntegerFormatter` class is a specialization of `NSNumberFormatter` for integers.
 */
@interface IntegerFormatter : NSNumberFormatter <NSControlTextEditingDelegate>

@end

