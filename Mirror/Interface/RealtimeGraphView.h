//
//  RealtimeGraphView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 13/10/16.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

const static uint8_t MAX_VALUES = 15; // The maximum amount of values in real-time graph views (2 < MAX_VALUES < UINT8_MAX).

@class RealtimeGraphLayer;

/**
 * A `RealtimeValue` represents a recorded value in a real-time graph view.
 */
struct RealtimeNode;

/**
 * The `RealtimeGraphView` class represents a view with a bar graph that represents a series of positive values that have been recorded in real-time.
 *  Values are added without any timestamp associated to them, so as to keep things simple. The end result is a simple, animated plot with bars of equal width.
 *
 * It's not really meant to be reused, just a small piece of code to give some vague overview of some marker.
 */
@interface RealtimeGraphView : NSView {
    
    uint8_t currentIndex, indexOfMaximum, _nbValues;
    struct RealtimeNode *nodePointers[MAX_VALUES];
    
    NSColor *_barColor;
    
    RealtimeGraphLayer *graphLayer;
        
}

/**
 * The amount of values recorded in this graph view.
 */
@property (nonatomic, readonly) uint8_t nbValues;

/**
 * This instance's bar color.
 */
@property (nonatomic, copy) NSColor *barColor;

/**
 * Add the given value to this bar graph. The value represents a realtime value that was recently recorded.
 *
 * @param value The value to be added.
 * @note This function does nothing if a value is already animated into the graph.
 */
- (void)addValue:(unsigned int)value;

/**
 * Remove all the values from this bar graph.
 */
- (void)removeAllValues;

@end

/**
 * A `RealtimeGraphLayer` represents a layer for a `RealtimeGraphView`.
 */
@interface RealtimeGraphLayer : CALayer

/**
 * The offset of this instance.
 */
@property (nonatomic, readwrite) CGFloat offset;

/**
 * The maximum value for this instance. Animatable.
 */
@property (nonatomic, readwrite) CGFloat maximum;

@end