//
//  ProjectStatsDictionary.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 27/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An enumeration for types of statistics referring to those of a `Project`.
 */
enum {
    /**
     * A type of statistic denoting the last transfer rate recorded for a project.
     */
    ProjectStatisticTransferRate = 0,
    /**
     * A type of statistic denoting the amount of files a project wrote to.
     */
    ProjectStatisticWritten,
    /**
     * A type of statistic denoting the amount of active sockets a project has.
     */
    ProjectStatisticSockets,
    /**
     * A type of statistic representing a list of warnings.
     */
    ProjectStatisticWarnings,
    /**
     * A type of statistic representing a list of errors.
     */
    ProjectStatisticErrors,
    /**
     * A type of statistic representing a list of informative messages.
     */
    ProjectStatisticInfoMessages,
    /**
     * A type of statistic denoting the amount of bytes a project scanned.
     */
    ProjectStatisticBytes,
    /**
     * A type of statistic denoting the total amount of bytes a project received.
     */
    ProjectStatisticTotalReceived,
    /**
     * A type of statistic denoting the total amount of links kept by a project.
     */
    ProjectStatisticLinks,
    /**
     * A type of statistic denoting the time that has elapsed since the launch of a project.
     */
    ProjectStatisticTime,
    /**
     * The number of statistics that have been defined.
     */
    ProjectStatisticCount,
} typedef ProjectStatisticType;

@class PieGraphView, Project, ProjectFile, ProjectStatsFileTypeCell;

/**
 * The `ProjectStatsDictionary` class keeps track of a project's statistics.
 *
 * This class conforms to the `NSOutlineViewDataSource` protocol so that the dictionary can readily
 *  be displayed in an `NSOutlineView`.
 */
@interface ProjectStatsDictionary : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate> {
    
    Project *_project;
    
    NSMutableArray *statistics;
    NSMutableArray *fileTypes; // Keeps number of files saved by a project (by type)
    
    ProjectStatsFileTypeCell *fileTypeCell;
    
    NSOutlineView *_outlineView;
    PieGraphView *pieGraphView;
    
}

/**
 * The project associated with this statistics dictionary.
 */
@property (nonatomic, readonly, assign) Project *project;

/**
 * An outline view this statistics dictionary associates with.
 */
@property (nonatomic, assign) NSOutlineView *outlineView;

/**
 * Create a new stats dictionary and associate it with the given project.
 *
 * @param project The project to associate the new project stats dictionary with.
 * @return A new project stats dictionary associated with the given project.
 */
- (id)initWithProject:(Project *)project;

/**
 * Create a new stats dictionary based on the given dictionary, and associate it with the given project.
 *
 * @param project The project to associate the new project stats dictionary to.
 * @param dictionary The dictionary to base the new one on.
 * @return  A new project stats dictionary associated to the given project, with the same stat values as the given
 *          dictionary.
 */
- (id)initWithProject:(Project *)project usingDictionary:(ProjectStatsDictionary *)dictionary;

/**
 * Return the value for the statistic of the given type.
 *
 * @param type The type of the statistic whose value is to be mutated.
 * @return The value of the statistic of the given type.
 */
- (id)valueForStatisticOfType:(ProjectStatisticType)type;

/**
 * Set the value of the statistic of the given type to the given one.
 *
 * @param value The new value to set.
 * @param type The type of the statistic that is to be set.
 */
- (void)setValue:(id)value forStatisticOfType:(ProjectStatisticType)type;

/**
 * Register the given project file, that is, update the stats dictionary to reflect the addition of this file.
 *
 * @param file The project file to take into account.
 */
- (void)registerFile:(ProjectFile *)file;

@end