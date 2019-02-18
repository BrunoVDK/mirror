//
//  ProjectDatabase.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 29/08/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class ProjectDatabaseStatement;

/**
 * The `ProjectDatabase` class represents an SQLite database connection associated with a project.
 */
@interface ProjectDatabase : NSObject {
    
    int resultCode; // Result code for queries
    const char *errorMessage; // Error message
    sqlite3 *connection; // SQLite connection
    
}

/**
 * The SQLite connection for this database.
 */
@property(nonatomic, readonly) sqlite3 *connection;

/**
 * Instantiate a new database with given file.
 *
 * @param filename The file to instantiate the new database with.
 * @param errorPtr A pointer to an error. If something fails during instantiation, this pointer will point to an error describing the problem.
 * @return A newly instantiated database with given parameters, or nil if an error occured.
 */
+ (id)databaseWithFile:(NSString*)filename error:(NSError **)errorPtr;

/**
 * Instantiate a new database with given file.
 *
 * @param filename The file to instantiate the new database with.
 * @param errorPtr A pointer to an error. If something fails during instantiation, this pointer will point to an error describing the problem.
 * @return A newly instantiated database with given parameters, or nil if an error occured.
 */
- (id)initWithFile:(NSString*)filename error:(NSError **)errorPtr;

/**
 * Close this database connection.
 *
 * @return True if and only if the connection closure was succesful.
 */
- (BOOL)close;

/**
 * Close this database connection.
 *
 * @param errorPtr A pointer to an error. If something fails during closing, this pointer will point to an error describing the problem.
 */
- (void)close:(NSError **)errorPtr;

/**
 * Execute the given SQL query.
 *
 * @param sql The SQL query to execute.
 * @return True if and only if the query exection was succesful.
 */
- (BOOL)executeQuery:(NSString *)sql;

/**
 * Prepare the given SQL query.
 *
 * @param sql The SQL query that is to be prepared.
 * @param errorPtr A pointer to an error. If something fails during preparation, this pointer will point to an error describing the problem.
 * @return A statement representing the given query.
 */
- (ProjectDatabaseStatement *)prepareQuery:(NSString *)sql error:(NSError **)errorPtr;

/**
 * Prepare the given SQL query.
 *
 * @param sql The SQL query that is to be prepared.
 * @param errorPtr A pointer to an error. If something fails during preparation, this pointer will point to an error describing the problem.
 * @return An array of statements representing the given queries.
 */
- (NSArray *)prepareQueries:(NSString *)sql error:(NSError **)errorPtr;

@end

/**
 * The `ProjectDatabaseStatement` class is a wrapper clase for an SQLite database statement object.
 */
@interface ProjectDatabaseStatement : NSObject<NSFastEnumeration> {
    
    sqlite3 *connection; // SQLite connection
    sqlite3_stmt *_statement; // SQLite statement
    int resultCode; // Result code
    
    struct {
        int freeWhenDone: 1; // Free when done flag
    } statementFlags;
    
}

/**
 * The result code for this statement.
 */
@property(nonatomic, readonly) int resultCode;

/**
 * Instantiate a new database statement with given SQLite statement.
 *
 * @param sqlite3 The connection this statement applies to.
 * @param statement The SQLite statement to instantiate the new statement with.
 * @param flag A flag denoting whether or not.
 * @return A newly instantiated statement with given parameters, or nil if an error occured.
 */
+ (id)statementWithSQLite:(sqlite3 *)sqlite3 statement:(sqlite3_stmt *)statement freeWhenDone:(BOOL)flag;

/**
 * Instantiate a new database statement with given database.
 *
 * @param database The database this statement applies to.
 * @param query The SQL query to instantiate the new statement with.
 * @param errorPtr A pointer to an error, which will point to an error if one occurred.
 * @return A newly instantiated statement with given parameters, or nil if an error occured.
 *          In case of an error the given error pointer will point to that error.
 */
- (id)initWithDatabase:(ProjectDatabase *)database query:(NSString *)query error:(NSError **)errorPtr;

/**
 * Fetch all rows in the response to this query.
 *
 * @return An array of database records returned by this query.
 */
- (NSArray *)allRows;

@end

/**
 * The `ProjectDatabaseError` class represents an error that occured while handling a `ProjectDatabase`.
 */
@interface ProjectDatabaseError : NSError

/**
 * Instantiate a new database error.
 *
 * @param db The connection this error applies to.
 * @return A newly instantiated database error with given parameters, or nil if an error occured.
 */
+ (id)errorWithDatabase:(sqlite3 *)db;

/**
 * Instantiate a new database error.
 *
 * @param db The connection this error applies to.
 * @return A newly instantiated database error with given parameters, or nil if an error occured.
 */
- (id)initWithDatabase:(sqlite3 *)db;

@end