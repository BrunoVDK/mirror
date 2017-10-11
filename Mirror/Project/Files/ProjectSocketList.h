//
//  ProjectSocketList.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_SOCKETS 14

@class LabeledProgressCell;

/**
 * A `ProjectSocketList` represents an array controller for a list of active sockets of a `Project`.
 */
@interface ProjectSocketList : NSArrayController {
    
    Project *_project;
    
    // Interface
    LabeledProgressCell *progressCell;
    
}

/**
 * The project associated with this socket list.
 */
@property (nonatomic, readwrite, assign) Project *project;

/**
 * The status of this socket list.
 */
@property (nonatomic, readonly) NSString *status;

@end