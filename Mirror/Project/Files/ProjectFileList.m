//
//  ProjectFileList.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "NSString+Additions.h"

#import "PreferencesConstants.h"
#import "ProjectFile.h"
#import "ProjectFileList.h"

#pragma mark Project File List

@implementation ProjectFileList

@dynamic status;

#pragma mark Constructors

- (id)init {
    
    if (self = [super init]) {
        
        self.automaticallyRearrangesObjects = true;
        self.usesLazyFetching = false;
        self.clearsFilterPredicateOnInsertion = false;
        
        // Set up backing array
        [self cleanArray];
        [PREFERENCES addObserver:self forKeyPath:MaxFiles options:NSKeyValueObservingOptionNew context:NULL];

    }
    
    return self;
    
}

#pragma mark Coding

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.clearsFilterPredicateOnInsertion = false;
        
        // Set up backing array
        self.content = [[aDecoder decodeObjectForKey:@"BackingArray"] mutableCopy]; // Assumed to be in order, most recently saved first
        [self cleanArray];
        [PREFERENCES addObserver:self forKeyPath:MaxFiles options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)enCoder {
    
    [enCoder encodeObject:self.content forKey:@"BackingArray"]; // Content is NSMutableArray
    
}

#pragma mark Properties

- (NSUInteger)count {
    
    return ((NSMutableArray *)self.content).count;
    
}

- (NSString *)status {
    
    NSInteger nbOfFiles = [self.arrangedObjects count];
    return (nbOfFiles == 0 ? @"No files." : [NSString stringWithFormat:(nbOfFiles == 1 ? @"%li file." : @"%li files."), (long)nbOfFiles]);

}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self cleanArray]; // Remove possible excess
    
}

#pragma mark Mutating

- (void)addObject:(id)object {
    
    if ([object isMemberOfClass:[ProjectFile class]]) {
        
        if ([self count] > maximumCapacity) {
            [self removeObject:[(NSMutableArray *)self.content firstObject]];
            [super addObject:object];
        }
        else {
            [self willChangeValueForKey:@"status"];
            [super addObject:object];
            [self didChangeValueForKey:@"status"];
        }
        
    }
    
}

- (void)clearFileList {
    
    [self willChangeValueForKey:@"status"];
    self.content = [NSMutableArray array]; // Renew content (releases former content array)
    [self didChangeValueForKey:@"status"];
    
}

- (BOOL)cleanArray { // Enforce maximum capacity, returns true if objects were removed
    
    maximumCapacity = MAX(10, MIN([PREFERENCES integerForKey:MaxFiles], MAX_FILES)); // Minimum of 10, maximum of MAX_FILES
    
    if (!self.content) {
        self.content = [NSMutableArray arrayWithCapacity:MAX_FILES];
        return false; // Newly created array is already clean
    }
    
    NSUInteger count = ((NSMutableArray *)self.content).count;
    if (count <= maximumCapacity)
        return false; // Array does not exceed maximum capacity
    
    [self willChangeValueForKey:@"status"];
    
    for (int i=0 ; i<(maximumCapacity-count) ; i++)
        [self removeObject:[(NSMutableArray *)self.content firstObject]];
    
    [self didChangeValueForKey:@"status"];
    
    return true;
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [PREFERENCES removeObserver:self forKeyPath:MaxFiles];
    
    [super dealloc];
    
}

@end
