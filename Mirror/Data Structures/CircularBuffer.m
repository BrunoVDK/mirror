//
//  CircularBuffer.m
//
//  Created by Bruno Vandekerkhove on 05/09/17.
//  Copyright (c) 2017 Bruno Vandekerkhove. All rights reserved.
//

#import "CircularBuffer.h"

#define DEFAULT_CAPACITY 10

#pragma mark Circular Buffer

@implementation CircularBuffer

@synthesize capacity = _capacity, size = _size, retainsItems = _retainsItems;

#pragma mark Constructors

- (id)init {
    
    return [self initWithCapacity:DEFAULT_CAPACITY];
    
}

- (id)initWithCapacity:(unsigned int)capacity {
    
    if (self = [super init]) {
        
        _size = offset = 0;
        _retainsItems = true;
        
        self.capacity = capacity;
        
    }
    
    return self;
    
}

#pragma mark Getters

- (BOOL)isEmpty {
    
    return _size == 0;
    
}

#pragma mark Setters

- (void)setCapacity:(unsigned int)capacity {
    
    if (capacity == 0 || _capacity == capacity)
        return;
    
    id *newBackingArray = malloc(capacity * sizeof(id));
    
    // Recreate new backing array form old one
    unsigned int i = capacity;
    while (!self.isEmpty && i > 0)
        newBackingArray[--i] = self.removeLast;
    offset = (i == capacity ? 0 : i);
    _size = capacity - i;
    
    // Make remaining items NULL
    while (i > 0)
        newBackingArray[--i] = nil;
    
    free(backingArray);
    backingArray = newBackingArray;
    
    _capacity = capacity;
    
}

- (void)setRetainsItems:(BOOL)retainsItems {
    
    if (retainsItems != _retainsItems) {
        
        if (_retainsItems) {
            for (int i=0 ; i<self.size ; i++)
                [backingArray[(offset + i) % self.size] release];
        }
        else {
            for (int i=0 ; i<self.size ; i++)
                [backingArray[(offset + i) % self.size] retain];
        }
        
        _retainsItems = retainsItems;
        
    }
    
}

#pragma mark Adding and Removing

- (void)addObject:(id)item {
    
    if (offset + _size >= _capacity)
        backingArray[offset + _size - _capacity] = item;
    else
        backingArray[offset + _size] = item;
    
    if (self.capacity > _size)
        _size++;
    else
        offset = (offset == _capacity - 1 ? 0 : offset + 1);
    
    if (_retainsItems)
        [item retain];
    
}

- (id)removeFirst {
    
    if (_size == 0)
        return nil;
    
    id first = backingArray[offset];
    backingArray[offset] = nil;
    offset = (offset == _capacity - 1 ? 0 : offset + 1);
    
    if (_retainsItems)
        [first release];
    
    _size--;
    
    return first;
    
}

- (id)removeLast {
    
    if (_size == 0)
        return nil;
    
    unsigned int lastOffset = offset + _size - 1;
    if (lastOffset >= _capacity)
        lastOffset = lastOffset - _capacity;
    
    id last = backingArray[lastOffset];
    backingArray[lastOffset] = nil;
    
    if (_retainsItems)
        [last release];
    
    _size--;
    
    return last;
    
}

#pragma mark Misc

- (NSString *)stringRepresentation {
    
    NSString *string = @"";
    
    for (int i=0 ; i<_size ; i++)
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%i | %@\n", i, backingArray[(offset + i) % self.capacity]]];
    
    return string;
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    while (!self.isEmpty)
        [self removeFirst];
    
    free(backingArray);
    
    [super dealloc];
    
}

@end