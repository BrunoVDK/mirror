//
//  CircularBuffer.h
//
//  Created by Bruno Vandekerkhove on 05/09/17.
//  Copyright (c) 2017 Bruno Vandekerkhove. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The `CircularBuffer` class represents a circular buffer.
 *  It has a fixed capacity but the buffer can be resized manually if so desired.
 */
@interface CircularBuffer : NSObject {
    
    id *backingArray;
    BOOL _retainsItems;
    
    unsigned int offset, _size, _capacity;
    
}

/**
 * The capacity of this buffer (the maximum number of items it can contain).
 *  This number cannot be zero.
 */
@property (nonatomic, readwrite) unsigned int capacity;

/**
 * The size of this buffer, that is, the number of items it contains.
 */
@property (nonatomic, readonly) unsigned int size;

/**
 * Whether or not the items in this buffer are retained when they are added (and released upon removal).
 */
@property (nonatomic, readwrite) BOOL retainsItems;

/**
 * Initialize a new circular buffer with given maximum capacity.
 * 
 * @param capacity The capacity for the newly formed buffer.
 * @return A circular buffer with given capacity.
 */
- (id)initWithCapacity:(unsigned int)capacity;

/**
 * Check whether or not this buffer is empty.
 *
 * @return True if and only if the size of this buffer equals zero.
 */
- (BOOL)isEmpty;

/**
 * Add the given item to this buffer;
 *
 * @param   item The item to add.
 * @note    If the size of this buffer equals its capacity, then the new item will replace the item in the buffer
 *          that was added the earliest.
 */
- (void)addObject:(id)item;

/**
 * Remove the first item in this buffer;
 *
 * @return The item in this buffer that was formerly the first.
 */
- (id)removeFirst;

/**
 * Remove the last item in this buffer;
 *
 * @return The item in this buffer that was formerly the last.
 */
- (id)removeLast;

/**
 * Represents a text representation of this queue, listing all its elements in reverse order (from last to first).
 *
 * @return A string representing this queue.
 */
- (NSString *)stringRepresentation;

@end
