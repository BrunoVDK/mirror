//
//  RealtimeGraphView.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 13/10/16.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//

#import "RealtimeGraphView.h"

typedef struct RealtimeNode {
    unsigned int value;
    uint8_t previousMaximum, nextMaximum;
} RealtimeNode;

#pragma mark Realtime Graph View

@interface RealtimeGraphView (Private)

- (void)resetGraph;

@end

@implementation RealtimeGraphView

@synthesize nbValues = _nbValues, barColor = _barColor;

#pragma mark Value Management

- (void)resetGraph {
    
    for (int i=0 ; i<MAX_VALUES ; i++)
        if (nodePointers[i] != nil) {
            free(nodePointers[i]);
            nodePointers[i] = nil;
        }
    
    _nbValues = indexOfMaximum = currentIndex = 0;
    
}

- (void)addValue:(unsigned int)value {
    
    if (graphLayer.animationKeys.count > 0)
        return;
    
    // Create novel node
    RealtimeNode *newNode = malloc(sizeof(RealtimeNode));
    newNode->value = value;
    newNode->previousMaximum = newNode->nextMaximum = UINT8_MAX;
    
    // Add node to list of pointers, replacing one if there is an excess of nodes
    if (_nbValues == MAX_VALUES) {
        RealtimeNode *oldNode = nodePointers[currentIndex];
        if (oldNode->previousMaximum != UINT8_MAX) nodePointers[oldNode->previousMaximum]->nextMaximum = oldNode->nextMaximum;
        if (oldNode->nextMaximum != UINT8_MAX) nodePointers[oldNode->nextMaximum]->previousMaximum = oldNode->previousMaximum;
        if (currentIndex == indexOfMaximum) indexOfMaximum = oldNode->nextMaximum;
        free(oldNode);
    }
    else
        _nbValues++;
    nodePointers[currentIndex] = newNode;
    
    // Update linked list
    uint8_t index = indexOfMaximum;
    while (nodePointers[index]->nextMaximum != UINT8_MAX && nodePointers[index]->value > value) // Select index where the new node is to be inserted
        index = nodePointers[index]->nextMaximum;
    if (nodePointers[index]->nextMaximum == UINT8_MAX && nodePointers[index]->value > value) { // Add node at the end of the list
        nodePointers[index]->nextMaximum = currentIndex;
        newNode->previousMaximum = index;
    }
    else if (_nbValues != 1) { // Insert new node before selected index
        newNode->nextMaximum = index;
        newNode->previousMaximum = nodePointers[index]->previousMaximum;
        nodePointers[index]->previousMaximum = currentIndex;
        if (newNode->previousMaximum != UINT8_MAX) nodePointers[newNode->previousMaximum]->nextMaximum = currentIndex;
        else indexOfMaximum = currentIndex;
    }
    
    // Step index
    if (++currentIndex == MAX_VALUES)
        currentIndex = 0;
    
    // Adapt layer
    RealtimeGraphLayer *presentationLayer = (RealtimeGraphLayer *)graphLayer.presentationLayer;
    presentationLayer.offset = 1.0;
    graphLayer.offset = (graphLayer.offset == 0.0 ? 0.0001 : 0.0);
    graphLayer.maximum = nodePointers[indexOfMaximum]->value;
    
}

- (void)removeAllValues {
    
    [self resetGraph];
    
}

- (unsigned int)currentMaximum {
    
    return MAX((_nbValues > 0 ? nodePointers[indexOfMaximum]->value : 0), 1);
    
}

#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
    
    // Unused
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context { // For 20 bars this takes less than 10 microseconds
    
    RealtimeGraphLayer *presentationLayer = (RealtimeGraphLayer *)graphLayer.presentationLayer;
    CGFloat offset = presentationLayer.offset;
    CGFloat maximum = presentationLayer.maximum;
        
    if (maximum > 0) { // Nothing's visible when the maximum equals zero
        
        uint8 startIndex = (currentIndex - _nbValues + MAX_VALUES) % MAX_VALUES; // The index of the node/bar to start drawing
        CGFloat barWidth = graphLayer.bounds.size.width / (MAX_VALUES - 2); // Minus one as one of the bars is being shifted at the right side of the layer
        CGFloat xOffset = graphLayer.bounds.size.width + (offset - _nbValues + 1) * barWidth + 1; // The horizontal offset for the first bar
        
        for (int i=0 ; i<_nbValues ; i++) { // Loop over all values, draw them as bars with the current offset (so that the bar chart slides to the left, slowly)
            CGFloat currentValue = nodePointers[(startIndex + i) % MAX_VALUES]->value / maximum; // Ratio of current value to current maximum (maximum is animated)
            CGContextSetFillColorWithColor(context, [self.barColor colorWithAlphaComponent:0.5 + 0.5 * currentValue].CGColor);
            CGContextFillRect(context, CGRectMake(xOffset + barWidth * i, 0, barWidth - 2, currentValue * graphLayer.bounds.size.height));
        }
        
    }
    
}

- (void)awakeFromNib {
    
    if (![self barColor])
        [self setBarColor:[NSColor lightGrayColor]]; // [NSColor colorWithCalibratedRed:0.4 green:0.5 blue:0.7 alpha:1.0]]
    
    [self resetGraph];
    
    self.wantsLayer = true;
    self.layer = [[CALayer new] autorelease];
    self.layer.borderColor = self.barColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 3.0;
    
    graphLayer = [RealtimeGraphLayer new];
    graphLayer.delegate = self;
    graphLayer.needsDisplayOnBoundsChange = true;
    graphLayer.frame = CGRectInset(self.layer.bounds, 2.0, 2.0);
    graphLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    graphLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
    [self.layer addSublayer:graphLayer];
    
}

#pragma mark Description

- (NSString *)description {
    
    NSString *description = @"END]";
    
    uint8_t loopIndex = indexOfMaximum;
    for (int i=0 ; i<_nbValues ; i++) {
        description = [[NSString stringWithFormat:@"%i-", nodePointers[loopIndex]->value] stringByAppendingString:description];
        loopIndex = nodePointers[loopIndex]->nextMaximum;
    }
    
    description = [@"END], Sorted = [START-" stringByAppendingString:description];
    
    for (int i=1 ; i<=_nbValues ; i++)
        description = [[NSString stringWithFormat:@"%i-", nodePointers[(currentIndex - i + MAX_VALUES) % MAX_VALUES]->value] stringByAppendingString:description];
    
    return [@"Realtime Graph View Values : [START-" stringByAppendingString:description];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [_barColor release];
    
    [super dealloc];
    
}

@end

#pragma mark - Realtime Graph Layer

@implementation RealtimeGraphLayer

@dynamic offset, maximum;

#pragma mark Constructors

- (id)initWithLayer:(id)layer {
    
    if (self = [super initWithLayer:layer]) {
        
        if ([layer isKindOfClass:[RealtimeGraphLayer class]]) {
            RealtimeGraphLayer *graphLayer = (RealtimeGraphLayer *)layer;
            self.offset = graphLayer.offset;
            self.maximum = graphLayer.maximum;
        }
        
    }
    
    return self;
    
}

#pragma mark Animation

+ (BOOL)needsDisplayForKey:(NSString *)key {
    
    return (([key isEqualToString:@"offset"] || [key isEqualToString:@"maximum"]) ? true : [super needsDisplayForKey:key]);
    
}

- (id<CAAction>)actionForKey:(NSString *)event {
    
    BOOL flag = [event isEqualToString:@"offset"];
    
    if (flag || [event isEqualToString:@"maximum"]) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.fromValue = (flag ? @1.0 : [[self presentationLayer] valueForKey:event]);
        animation.duration = (flag ? 1.0 : 0.3);
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        return animation;
        
    }
    
    return [super actionForKey:event];
    
}

@end