//
//  ProjectURL.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 03/09/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;

#define PREFERRED_ICON_SIZE 36.0

/**
 * The `ProjectURL` class represents a base URL of a `Project`.
 *
 *  Apart from its address it has a title and an icon.
 */
@interface ProjectURL : NSObject <NSCoding> {
    
    BOOL fetchingAttributes, fetchedTitle, fetchedIcon, cancelled, failed;
    
    NSUInteger _identifier;
    NSString *_title;
    NSImage *_icon;
    NSURL *_URL;
    
    long long bytesScanned, bytesWritten, linksDetected;
    
}

/**
 * This project's identifier.
 */
@property (nonatomic, readonly) NSUInteger identifier;

/**
 * This project URL's title.
 */
@property (nonatomic, copy) NSString *title;

/**
 * This project URL's favicon, if any.
 */
@property (nonatomic, retain) NSImage *icon;

/**
 * This project URL's address.
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 * A boolean denoting whether or not this project URL was cancelled.
 */
@property (nonatomic, readwrite, getter=isCancelled) BOOL cancelled;

/**
 * A boolean denoting whether or not this project URL failed to be processed.
 */
@property (nonatomic, readwrite) BOOL failed;

/**
 * The amount of bytes of this URL and sub-URLS that were scanned.
 */
@property (nonatomic, readwrite) long long bytesScanned;

/**
 * The amount of bytes of this URL and sub-URLS that were written on disk.
 */
@property (nonatomic, readwrite) long long bytesWritten;

/**
 * The amount of links that were detected starting from this URL.
 */
@property (nonatomic, readwrite) long long linksDetected;

/**
 * Initialize a new project URL with the given link and identifier.
 *
 * @param url The address to initialize this project URL with.
 * @param identifier The identifier of the new project URL.
 * @return A new project URL with given address and identifier.
 */
- (id)initWithURL:(NSURL *)url identifier:(NSUInteger)identifier;

/**
 * Fetch the attributes of this project URL.
 *
 * @return YES if the operation was successful.
 */
- (BOOL)fetchAttributes;

/**
 * Reset this URL (that is, set its parameters to zero).
 */
- (void)reset;

@end