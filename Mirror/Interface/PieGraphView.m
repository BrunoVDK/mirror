//
//  PieGraphView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "PieGraphView.h"

#define MAX_SLICES 5

#define radians(degrees) (degrees * M_PI / 180.0)

#pragma mark Pie Graph View

@implementation PieGraphView

@synthesize enabled = _enabled;

#pragma mark Class Methods

+ (const NSString *)nameOfTheme:(PieGraphTheme)theme {
    
    if (theme >= PieGraphThemeCount)
        return nil;
    
    static const NSString *themeNames[] = {@"Classic", @"Forest"};
    
    return themeNames[theme];
    
}

+ (const NSArray *)colorsForTheme:(PieGraphTheme)theme {
    
    static const NSArray *classicColors = nil, *seaColors = nil;
    
    if (theme == PieGraphThemeClassic) {
        
        if (!classicColors)
            classicColors = [@[[NSColor colorWithCalibratedRed:.35 green:.52 blue:.70 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.90 green:.52 blue:.45 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.62 green:.75 blue:.37 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.90 green:.81 blue:.45 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.38 green:.75 blue:.59 alpha:1.0],
                               ] retain];
        
        return classicColors;
        
    }
    else if (theme == PieGraphThemeSea) {
        
        if (!seaColors)
            seaColors =     [@[[NSColor colorWithCalibratedRed:.42 green:.66 blue:.40 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.94 green:.92 blue:.27 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.61 green:.74 blue:.29 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.58 green:.56 blue:.40 alpha:1.0],
                               [NSColor colorWithCalibratedRed:.49 green:.76 blue:.80 alpha:1.0],
                               ] retain];
        
        return seaColors;
        
    }
    
    return nil;
    
}

+ (NSInteger)maximumNbOfSlices {
    
    return MAX_SLICES;
    
}

+ (NSColor *)randomColor {
    
    int red = rand() % 255;
    int green = rand() % 255;
    int blue = rand() % 255;
    
    return [NSColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    
}

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect]) {
        
        if (!self.layer)
            self.layer = [CALayer new];
        
    }
    
    return self;
    
}

- (void)viewWillMoveToSuperview:(NSView *)newSuperview {
    
    [super viewWillMoveToSuperview:newSuperview];
    
    self.layer.delegate = self;
    self.layer.needsDisplayOnBoundsChange = true;
    self.wantsLayer = true;
    
    [self.layer setNeedsDisplay];
    
}

#pragma mark Accessors

- (NSUInteger)numberOfSlices {
    
    return self.layer.sublayers.count;
    
}

- (NSUInteger)weightForSliceAtIndex:(NSUInteger)index {
    
    PieGraphSliceLayer *slice = [self sliceAtIndex:index];
    return (slice ? slice.weight : 0);
    
}

- (PieGraphSliceLayer *)sliceAtIndex:(NSUInteger)index {
    
    return (index < [self numberOfSlices] ? (PieGraphSliceLayer *)[self.layer.sublayers objectAtIndex:index] : nil);
    
}

- (NSColor *)colorOfSliceAtIndex:(NSUInteger)index {
    
    PieGraphSliceLayer *slice = [self sliceAtIndex:index];
    return (slice ? slice.color : 0);
    
}

#pragma mark Mutators

- (void)addSliceWithWeight:(NSUInteger)weight {
    
    [self addSlicesWithWeights:1, weight];
    
}

- (void)addSlicesWithWeights:(NSUInteger)nbOfSlices, ... {
    
    va_list args;
    va_start(args, nbOfSlices);
    
    NSUInteger oldNb = [self numberOfSlices], newNb = MIN(MAX_SLICES, oldNb + nbOfSlices);
    
    for (NSUInteger i=oldNb ; i<newNb ; i++) {
        
        unsigned int newWeight = va_arg(args, unsigned int);
        
        PieGraphSliceLayer *slice = [PieGraphSliceLayer new];
        slice.color = [PieGraphView randomColor];
        slice.weight = newWeight;
        totalWeight += newWeight;
        slice.delegate = self;
        slice.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
        slice.needsDisplayOnBoundsChange = true;
        slice.layoutManager = [CAConstraintLayoutManager layoutManager];
        slice.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
        
        [self.layer addSublayer:slice];
        [slice release];
        
    }
    
    va_end(args);
    
    [self setupSliceAngles];
    
}

- (void)removeSliceAtIndex:(NSUInteger)index {
    
    PieGraphSliceLayer *slice = [self sliceAtIndex:index];
    if (slice) {
        [slice removeFromSuperlayer];
        [self setupSliceAngles];
    }
    
}

- (void)removeAllSlices {
    
    while ([self numberOfSlices] > 0)
        [[self sliceAtIndex:0] removeFromSuperlayer];
    
}

- (void)setWeight:(NSUInteger)weight forSliceAtIndex:(NSUInteger)index {
    
    PieGraphSliceLayer *slice = [self sliceAtIndex:index];
    if (slice) {
        totalWeight += weight - slice.weight;
        slice.weight = weight;
        [self setupSliceAngles];
    }
    
}

- (void)addWeight:(NSUInteger)weight toSliceAtIndex:(NSUInteger)index {
        
    NSUInteger currentWeight = [self weightForSliceAtIndex:index];
    if (NSUIntegerMax - currentWeight >= weight)
        [self setWeight:weight + currentWeight forSliceAtIndex:index];
    
}

- (void)setColor:(NSColor *)color forSliceAtIndex:(NSUInteger)index {
    
    [self sliceAtIndex:index].color = color;
    
}

- (void)adoptTheme:(PieGraphTheme)theme {
        
    if (theme >= PieGraphThemeCount) // Nominal programming
        return;
    
    const NSArray *colors = [PieGraphView colorsForTheme:theme];
    
    for (int i=0 ; i<[self numberOfSlices] ; i++)
        [self setColor:[colors objectAtIndex:i] forSliceAtIndex:i];
    
    [self setNeedsDisplay:true];
    
}

#pragma mark Drawing

- (void)setEnabled:(BOOL)enabled {
    
    if (enabled != _enabled) {
    
        _enabled = enabled;
        [self setNeedsDisplay:true];
        
    }
    
    
}

- (void)setNeedsDisplay:(BOOL)flag {
    
    [super setNeedsDisplay:flag];
    
    for (CALayer *layer in self.layer.sublayers)
        [layer setNeedsDisplay];
    
}

- (void)setupSliceAngles {
    
    if (totalWeight > 0) {
        
        double currentAngle = 0.0;
        
        for (NSUInteger index=0 ; index<[self numberOfSlices] ; index++) { // Draw slices
            
            PieGraphSliceLayer *slice = [self sliceAtIndex:index];
            
            double relativeWeightAngle = slice.weight / (double)totalWeight * 360.0;
            slice.startAngle = currentAngle;
            slice.endAngle = currentAngle + relativeWeightAngle;
            
            currentAngle += relativeWeightAngle;
            
        }
        
    }
    
}

- (void)drawRect:(NSRect)dirtyRect {
    
    // Unused
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSRect frame = self.bounds;
    CGFloat minSide = MIN(frame.size.width, frame.size.height);
    CGRect square = CGRectMake(frame.origin.x + (frame.size.width - minSide) / 2, frame.origin.y + (frame.size.height - minSide) / 2, minSide, minSide);
    NSPoint center = NSMakePoint(square.origin.x + minSide / 2, square.origin.y + minSide / 2);
    
    if ([layer isKindOfClass:[PieGraphSliceLayer class]]) {
        
        PieGraphSliceLayer *slice = (PieGraphSliceLayer *)layer;
        
        CGPathMoveToPoint(path, NULL, center.x, center.y);
        CGPathAddArc(path, NULL, center.x, center.y, minSide / 2 - 3, radians(slice.startAngle), radians(slice.endAngle), false);
        
        NSColor *sliceColor = slice.color;

        if (!_enabled) { // http://iphonedevsdk.com/forum/iphone-sdk-development/97172-uicolor-how-can-i-convert-to-grayscale.html
            CGFloat white = (0.2126 * sliceColor.redComponent) + (0.7152 * sliceColor.greenComponent) + (0.0722 * sliceColor.blueComponent);
            if (white < 0.7)
                white *= (2.0 - white);
            sliceColor = [NSColor colorWithCalibratedWhite:white alpha:1.0];
        }

        CGContextSetFillColorWithColor(context, sliceColor.CGColor);
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        
    }
    else {
        
        if (totalWeight == 0) { // Draw background of pie if there are no slices to draw
            
            CGPathMoveToPoint(path, NULL, center.x, center.y);
            CGPathAddEllipseInRect(path, NULL, CGRectInset(square, 3, 3));
            
            CGContextSetFillColorWithColor(context, CGColorCreateGenericGray(0.97, 1.0));
            
            CGContextBeginPath(context);
            CGContextAddPath(context, path);
            CGContextFillPath(context);
            
        }
        
#if DRAW_BORDER
        CGPathMoveToPoint(path, NULL, center.x, center.y);
        CGPathAddEllipseInRect(path, NULL, CGRectInset(square, 1, 1));
        
        CGContextSetStrokeColorWithColor(context, [NSColor lightGrayColor].CGColor);
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
#endif
        
    }
    
    CFRelease(path);
    
}

@end

#pragma mark - Pie Graph Slice Layer

@implementation PieGraphSliceLayer

@dynamic startAngle, endAngle;
@synthesize weight = _weight, color = _color;

#pragma mark Constructors

- (id)initWithLayer:(id)layer {
    
    if (self = [super initWithLayer:layer]) {
        
        if ([layer isKindOfClass:[PieGraphSliceLayer class]]) {
            PieGraphSliceLayer *slice = (PieGraphSliceLayer *)layer;
            self.startAngle = slice.startAngle;
            self.endAngle = slice.endAngle;
            self.weight = slice.weight;
            self.color = slice.color;
        }
        
    }
    
    return self;
    
}

#pragma mark Animation

+ (BOOL)needsDisplayForKey:(NSString *)key {
    
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"] || [key isEqualToString:@"color"])
        return true;
    
    return [super needsDisplayForKey:key];
    
}

- (id<CAAction>)actionForKey:(NSString *)event {
    
    if ([event isEqualToString:@"startAngle"] || [event isEqualToString:@"endAngle"]) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.fromValue = [[self presentationLayer] valueForKey:event];
        return animation;
        
    }
    
    return [super actionForKey:event];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [self.color release];
    
    [super dealloc];
    
}

@end
