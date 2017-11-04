//
//  ProjectFile.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 03/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The `ProjectFile` class represents a file a `Project` is creating/created.
 *
 *  It has a source address, a path (relative location on disk), a size and a progress value.
 */
@interface ProjectFile : NSObject {
    
    NSString *_address, *_path;
    unsigned long long _size;
    
}

/**
 * This project file's icon.
 */
@property (nonatomic, readonly) NSImage *icon;

/**
 * This project file's address.
 */
@property (nonatomic, readonly, copy) NSString *address;

/**
 * This project file's relative file path.
 */
@property (nonatomic, readonly, copy) NSString *path;

/**
 * This project file's size.
 */
@property (nonatomic, readonly) NSString *size;

/**
 * Initialize a new project file with given source address, file path and size.
 *
 * @param address The source address of the new project file.
 * @param path The relative location of the new project file on disk.
 * @param size The size of the new project file.
 * @return A newly allocated project file with the given attributes.
 */
- (id)initWithAddress:(NSString *)address file:(NSString *)path size:(unsigned long long)size;

/**
 * Reveal this file in the Finder.
 *
 * @param sender The sender of this method.
 */
- (void)revealInFinder:(id)sender;

/**
 * Returns the file name of this project file.
 *
 * @return The filename of this project file.
 */
- (NSString *)fileName;

@end
