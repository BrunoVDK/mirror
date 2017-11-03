//
//  Project.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#include "httrack.h"
#include "htsnet.h"
#include "htsopt.h"
#include "htsdefines.h"
#include "htscore.h"

#define MAX_PROJECT_URLS 32
#define MAX_FILTERS 100

@class CircularBuffer, ProjectOptionsDictionary, ProjectFile, ProjectFileList, ProjectNotificationList, ProjectUpdate, ProjectURL, ProjectSocket, ProjectSocketList, ProjectStatsDictionary, ProjectWindowController;

@protocol ProjectDelegate;

/**
 * The `Project` class represents a mirroring project. It is a subclass of `NSDocument` and thus behaves much like any other document.
 *
 *  A mirroring project accepts a number of links to crawl and mirror for offline use. It manages pausing/resuming, cancelling, filters, ...
 *   Every project has an array of URLs, as well as filtering rules and an export directory to which files are downloaded.
 */
@interface Project : NSDocument {
    
    id<ProjectDelegate> _delegate;
    ProjectWindowController *_windowController;
    
    // Options
    httrackp *engineOptions;
    ProjectOptionsDictionary *_options;
    NSMutableArray *filters;
    
    // URLs
    int _addRetries; // Trials adding url from queue to list of urls to mirror
    NSMutableArray *_URLs;
    CircularBuffer *_addURLBuffer, *_cancelURLBuffer;
    
    // Statistics
    ProjectStatsDictionary *_statistics;
    
    // Files & Writing
    ProjectFileList *_files;
    ProjectSocketList *_sockets;
    NSURL *_exportDirectory;
    NSData *bookmarkData;
    
    // Notifications
    ProjectNotificationList *_notifications;
    
    // Flags
    BOOL _shouldCancel, _started, _completed, _writingPermission;
    
}

/**
 * This project's delegate.
 */
@property (nonatomic, assign) id<ProjectDelegate> delegate;

/**
 * The options dictionary of this project.
 */
@property (nonatomic, readonly) ProjectOptionsDictionary *options;

/**
 * The statistics dictionary of this project.
 */
@property (nonatomic, readonly) ProjectStatsDictionary *statistics;

/**
 * The recent file list of this project.
 */
@property (nonatomic, readonly) ProjectFileList *files;

/**
 * The recent socket list of this project.
 */
@property (nonatomic, readonly) ProjectSocketList *sockets;

/**
 * The recent notification list of this project.
 */
@property (nonatomic, readonly) ProjectNotificationList *notifications;

/**
 * The URLs this project mirrors.
 */
@property (nonatomic, readonly) NSMutableArray *URLs;

/**
 * This project's current export directory.
 */
@property (nonatomic, copy) NSURL *exportDirectory;

/**
 * Indicates whether the project has already been launched.
 */
@property (nonatomic, readonly, getter = hasStarted) BOOL started;

/**
 * Indicates whether the project has been completed.
 */
@property (nonatomic, readonly, getter = isCompleted) BOOL completed;

/**
 * Indicates whether the project has permission to write to its export directory.
 */
@property (nonatomic, readonly, getter = hasWritingPermission) BOOL writingPermission;

/**
 * This project's window controller.
 */
@property (nonatomic, retain) ProjectWindowController *windowController;

/**
 * Returns the project's root URL.
 *
 * @return The project's root URL.
 */
- (ProjectURL *)rootURL;

/**
 * Adds the given address to this project's list of links.
 *
 * @param url The URL to be added.
 */
- (ProjectURL *)addURL:(NSURL *)url;

/**
 * Cancel the given project url.
 *
 * @param url The url to cancel.
 * @return True if and only if the operation was succesful.
 */
- (BOOL)cancelURL:(ProjectURL *)url;

/**
 * Returns the project's engine options structure.
 *
 * @return The project's engine options structure.
 */
- (httrackp *)engineOptions;

/**
 * Start this project.
 */
- (void)mirror;

/**
 * Pause this project.
 */
- (void)pause;

/**
 * Resume this project.
 */
- (void)resume;

/**
 * Cancel this project.
 */
- (void)cancel;

/**
 * Check whether or not this project is mirroring.
 *
 * @return YES if this project is mirroring.
 */
- (BOOL)isMirroring;

/**
 * Check whether or not this project is paused.
 *
 * @return YES if this project is attempting a pause.
 */
- (BOOL)isPaused;

/**
 * Cancels the given socket.
 *
 * @param socket The socket to cancel.
 */
- (void)cancelSocket:(ProjectSocket *)socket;

/**
 * Returns the number of filters that this project has.
 *
 * @return The number of filters this project currently keeps track of.
 */
- (NSUInteger)nbOfFilters;

/**
 * Returns a filter of this project at the given index.
 *
 * @param index The index of the filter to return.
 * @return The filter at the given index.
 */
- (NSString *)filterAtIndex:(NSUInteger)index;

/**
 * Checks whether or not this project has the given filter.
 *
 * @param filter The filter to search for.
 * @return True if and only if this project uses the given filter.
 */
- (BOOL)hasFilter:(NSString *)filter;

/**
 * Add the given filter to this project.
 *
 * @param filter The filter to be added.
 * @note This method has no effect if the engine is running.
 */
- (void)addFilter:(NSString *)filter;

/**
 * Add the given filters to this project.
 *
 * @param newFilters An array of filters that are to be added.
 * @note This method has no effect if the engine is running.
 */
- (void)addFilters:(NSArray *)newFilters;

/**
 * Remove the given filter from this project.
 *
 * @param filter The filter to be removed.
 * @note This method has no effect if the engine is running.
 */
- (void)removeFilter:(NSString *)filter;

/**
 * Remove the given filters from this project.
 *
 * @param oldFilters An array of filters that are to be removed.
 * @note This method has no effect if the engine is running.
 */
- (void)removeFilters:(NSArray *)oldFilters;

/**
 * Remove all filters from this project.
 *
 * @note This method has no effect is the engine is running.
 */
- (void)removeAllFilters;

/**
 * Remove the filters at given indices from this project.
 *
 * @param indices An array of indices of the filters that are to be removed.
 * @note This method has no effect if the engine is running.
 */
- (void)removeFiltersAtIndexes:(NSIndexSet *)indices;

@end

/**
 * The `ProjectDelegate` protocol allows a project delegate to be notified of various occurences.
 */
@protocol ProjectDelegate <NSObject>
@optional

/**
 * Called when a project started.
 *
 * @param project The very project.
 */
- (void)projectDidStart:(Project *)project;

/**
 * Called when a project ended.
 *
 * @param project The very project.
 * @param error A string of characters representing an error description. This is nil if no error occured before the project ended.
 */
- (void)projectDidEnd:(Project *)project error:(NSString *)error;

/**
 * Called when a project resumed.
 *
 * @param project The very project that resumed.
 */
- (void)projectDidResume:(Project *)project;

/**
 * Called when a project was successfully paused.
 *
 * @param project The very project that paused.
 */
- (void)projectDidPause:(Project *)project;

/**
 * Called when a project saved a file to the disk.
 *
 * @param project The very project that is responsible for saving the file.
 * @param file The file that was saved to disk.
 */
// - (void)project:(Project *)project savedFile:(ProjectFile *)file; // Currently not used (delegation of the ProjectFileList is used instead)

@end