//
//  PieGraphView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define DRAW_BORDER 1

/**
 * An enumeration for color themes for a `PieGraphView`. Each theme 
 */
enum {
    /**
     * Pie graph view classic theme.
     */
    PieGraphThemeClassic,
    /**
     * Pie graph view sea theme.
     */
    PieGraphThemeSea,
    /**
     * Pie graph view forest theme.
     */
    PieGraphThemeForest,
    /**
     * Pie graph view fire theme.
     */
    PieGraphThemeFire,
    /**
     * Pie graph view sunrise theme.
     */
    PieGraphThemeSunrise,
    /**
     * The number of themes that have been defined for a pie graph view.
     */
    PieGraphThemeCount,
} typedef PieGraphTheme;

@class PieGraphLayer;

/**
 * The `PieGraphView` class represents a view displaying a pie graph. The pie's amount of slices can be set (minimum 0, maximum 15), the size of
 *  each slice is based on percentual weight, that is, each slice has an associated unsigned integer weight, while its percentual weight is its 
 *  weight relative to the sum of all slice weights.
 */
@interface PieGraphView : NSView {
    
    BOOL _enabled;
    unsigned long long totalWeight;
    
}

/**
 * Denotes whether or not this view is enabled.
 */
@property (nonatomic, readwrite) BOOL enabled;

/**
 * Get the name of the given pie graph theme.
 *
 * @param theme The theme of which the name is desired.
 */
+ (const NSString *)nameOfTheme:(PieGraphTheme)theme;

/**
 * Get the colors used for the given pie graph theme.
 *
 * @param theme The theme of which the associated colors are requested.
 * @note    The number of colors in the returned array equals the maximum number of slices a pie graph can have.
 *          This number is returned by the `+maximumNbOfSlices' class method.
 */
+ (const NSArray *)colorsForTheme:(PieGraphTheme)theme;

/**
 * Returns the maximum number of slices a pie graph view can have.
 *
 * @return The maximum number of slices a pie graph can have.
 */
+ (NSInteger)maximumNbOfSlices;

/**
 * Get the number of slices this pie chart has.
 *
 * @return The number of slices of this pie chart.
 */
- (NSUInteger)numberOfSlices;

/**
 * Add a slice to this pie chart, having the given weight.
 *
 * @param weight The weight of the new slice.
 */
- (void)addSliceWithWeight:(NSUInteger)weight;

/**
 * Add slices with given weights to this pie chart.
 *
 * @param nbOfSlices The number of new slices
 * @param ... The actual weights of the new slices.
 */
- (void)addSlicesWithWeights:(NSUInteger)nbOfSlices, ...;

/**
 * Remove the slice at given index from this pie chart.
 *
 * @param index The index of the slice that is to be removed.
 */
- (void)removeSliceAtIndex:(NSUInteger)index;

/**
 * Remove all slices from this pie chart.
 */
- (void)removeAllSlices;

/**
 * Get the weight of the slice at the given index.
 *
 * @param index The index of the slice whose weight is requestted.
 * @return The weight of the slice at the given index (zero if the index was invalid).
 */
- (NSUInteger)weightForSliceAtIndex:(NSUInteger)index;

/**
 * Set the weight of the slice at the given index to the given weight.
 *
 * @param weight The new weight for the slice at given index.
 * @param index The index of the slice whose weight is to be mutated.
 */
- (void)setWeight:(NSUInteger)weight forSliceAtIndex:(NSUInteger)index;

/**
 * Add the given weight to that of the slice at the given index.
 *
 * @param weight The weight that is to be added to the slice's current weight.
 * @param index The index of the slice whose weight is to be altered.
 */
- (void)addWeight:(NSUInteger)weight toSliceAtIndex:(NSUInteger)index;

/**
 * Get the color of the slice at given index.
 *
 * @param index The index of the slice.
 */
- (NSColor *)colorOfSliceAtIndex:(NSUInteger)index;

/**
 * Set the color of the slice at the given index to the given one.
 *
 * @param color The new color for the slice at given index.
 * @param index The index of the slice whose color is to be altered.
 */
- (void)setColor:(NSColor *)color forSliceAtIndex:(NSUInteger)index;

/**
 * Adopt the given theme, using its associated colors for coloring the slices of this view.
 *
 * @param theme The theme that is to be used for this pie graph view.
 */
- (void)adoptTheme:(PieGraphTheme)theme;

@end

/**
 * The `PieGraphLayer` class represents a slice layer for a `PieGraphView`. It has a starting angle and an end angle.
 *  Its radius equals the minimum side length divided by two.
 */
@interface PieGraphSliceLayer: CAShapeLayer {
    
    NSUInteger _weight;
    NSColor *_color;
    
}

/**
 * This slice's weight.
 */
@property (nonatomic, readwrite) NSUInteger weight;

/**
 * This slice's color.
 */
@property (nonatomic, copy) NSColor *color;

/**
 * This slice's starting angle. Animatable.
 */
@property CGFloat startAngle;

/**
 * This slice's ending angle. Animatable.
 */
@property CGFloat endAngle;

@end
