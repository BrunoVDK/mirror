//
//  ProjectFileList.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_FILES 1000

@class Project, ProjectFile;

/**
 * A `ProjectFileList` represents an array controller for a list of files downloaded by a `Project`.
 */
@interface ProjectFileList : NSArrayController <NSCoding> {
    
    Project *_project;
    NSUInteger maximumCapacity; // Maximum capacity of backing array
    
}

/**
 * The project associated with this file list.
 */
@property (nonatomic, readwrite, assign) Project *project;

/**
 * Gives the status of the file list.
 */
@property (nonatomic, readonly) NSString *status;

/**
 * Returns the size of this file list.
 *
 * @return The number of files this list keeps track of.
 */
- (NSUInteger)size;

/**
 * Remove all files in this list.
 */
- (void)clearFileList;

@end