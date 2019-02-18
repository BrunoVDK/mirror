//
//  ProjectDatabase.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 29/08/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "ProjectDatabase.h"

#pragma mark Project Database

@interface ProjectDatabase (Private)

- (BOOL)handleResult:(NSError **)errorPtr;

@end

@implementation ProjectDatabase

@synthesize connection;

#pragma mark Constructors

+ (id)databaseWithFile:(NSString *)filename error:(NSError **)errorPtr {
    
    return [[[self alloc] initWithFile:filename error:errorPtr] autorelease];
    
}

- (id)initWithFile:(NSString *)filename error:(NSError **)errorPtr {
    
    if (self == [super init]) {
        
        [self openFile:filename error:errorPtr];
        
        if (*errorPtr != nil) {
            [self release];
            return nil;
        }
        
    }
    
    return self;
    
}

#pragma mark Databse Handling

- (void)openFile:(NSString *)filename error:(NSError **)errorPtr {

    self->resultCode = sqlite3_open(filename.UTF8String, &self->connection);
    
    if (self->resultCode != SQLITE_OK && errorPtr) {
        if (self->connection)
            *errorPtr = [ProjectDatabaseError errorWithDatabase:self->connection];
        else
            *errorPtr = [ProjectDatabaseError errorWithDomain:@"sqlite" code:0 userInfo:@{@"description" : @"Failed to initialization"}];
    }
    
}

- (BOOL)close {
    
    NSError *error = nil;
    [self close:&error];
    return error == nil;
    
}

- (void)close:(NSError **)errorPtr {
    
    self->resultCode = sqlite3_close(self->connection);
    
    if (self->resultCode != SQLITE_OK && errorPtr)
        *errorPtr = [ProjectDatabaseError errorWithDatabase:self->connection];
    else
        self->connection = nil;
    
}

- (BOOL)executeQuery:(NSString *)sql {
    
    self->resultCode = sqlite3_exec(self->connection, [sql UTF8String], NULL, NULL, (char **)&self->errorMessage);
    return self->resultCode == SQLITE_OK || self->resultCode == SQLITE_DONE || self->resultCode ==SQLITE_ROW;
    
}

- (ProjectDatabaseStatement *)prepareQuery:(NSString *)sql error:(NSError **)errorPtr {
    
    return [[[ProjectDatabaseStatement alloc] initWithDatabase:self query:sql error:errorPtr] autorelease];
    
}

- (NSArray *)prepareQueries:(NSString *)sql error:(NSError **)errorPtr {
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    const char *query = sql.UTF8String, *head = query;
    sqlite3_stmt *statement;
    
    while (1) {
        
        self->resultCode = sqlite3_prepare_v2(self->connection, head, -1, &statement, &head);
        
        if ([self handleResult:errorPtr])
            break;
        
        [mutableArray addObject:[ProjectDatabaseStatement statementWithSQLite:self->connection statement:statement freeWhenDone:true]];
        
    }
    
    return [NSArray arrayWithArray:mutableArray];
    
}

#pragma mark Private Methods

- (BOOL)handleResult:(NSError **)errorPtr {
    
    if (self->resultCode != SQLITE_OK) {
        
        if (errorPtr)
            *errorPtr = [ProjectDatabaseError errorWithDatabase:self->connection];
        
        return true;
        
    }
    
    return false;
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    if (nil != self->connection)
        [self close];

    [super dealloc];
    
}

@end

#pragma mark - Project Database Statement

@interface ProjectDatabaseStatement (Private)

- (BOOL)handleResult:(NSError **)errorPtr;

@end

@implementation ProjectDatabaseStatement

@synthesize resultCode;

#pragma mark Constructors

+ (id)statementWithSQLite:(sqlite3 *)sqlite3 statement:(sqlite3_stmt *)statement freeWhenDone:(BOOL)flag {
    
    return [[[self alloc] initWithSQLite:sqlite3 statement:statement freeWhenDone:flag] autorelease];
    
}

- (id)initWithSQLite:(sqlite3 *)sqlite3 {
    
    if (sqlite3 != NULL && self == [super init]) {
        self->connection = sqlite3;
        return self;
    }
    
    [self release];
    return nil;
    
}

- (id)initWithSQLite:(sqlite3 *)sqlite3 statement:(sqlite3_stmt *)statement freeWhenDone:(BOOL)flag {
    
    if (statement == NULL) {
        [self release];
        return nil;
    }
    
    if (self == [self initWithSQLite:sqlite3]) {
        self->_statement = statement;
        self->statementFlags.freeWhenDone = flag;
    }
    
    return self;
    
}

- (id)initWithDatabase:(ProjectDatabase *)database query:(NSString *)query error:(NSError **)errorPtr {
    
    if (database != nil && query != nil && self == [self initWithSQLite:database.connection]) {
        
        [self prepareQuery:query error:errorPtr];
        
        if (self->_statement != NULL)
            return self;
            
    }
    
    [self release];
    return nil;
    
}

#pragma mark Statement Handling

- (void)prepareQuery:(NSString *)query error:(NSError **)errorPtr {
    
    const char *sql = query.UTF8String;
    self->resultCode = sqlite3_prepare_v2(self->connection, sql, -1, &self->_statement, NULL);
    
    if (![self handleResult:errorPtr])
        self->statementFlags.freeWhenDone = true;

}

- (void)step:(NSError **)errorPtr {
    
    self->resultCode = sqlite3_step(self->_statement);
    [self handleResult:errorPtr];
    
}

- (void)reset:(NSError **)errorPtr {
    
    self->resultCode = sqlite3_reset(self->_statement);
    [self handleResult:errorPtr];
    
}

- (NSInteger)columnCount {
    
    return (NSInteger)sqlite3_column_count(self->_statement);
    
}

- (NSString *)nameAtColumnIndex:(NSInteger)index {
    
    return [NSString stringWithUTF8String:sqlite3_column_name(self->_statement, (int)index)];
    
}

- (int)typeForColumnIndex:(NSInteger)index {
    
    return sqlite3_column_type(self->_statement, (int)index);
    
}

- (NSString *)stringValueAtColumnIndex:(NSInteger)index {
    
    const char *text = (const char*)sqlite3_column_text(self->_statement, (int)index);
    
    if (text == NULL)
        return nil;
    
    return [NSString stringWithUTF8String:text];
    
}

- (NSInteger)integerValueAtColumnIndex:(NSInteger)index {
    
    return sqlite3_column_int(self->_statement, (int)index);
    
}

- (NSData *)dataValueAtColumnIndex:(NSInteger)index {
    
    NSUInteger size = sqlite3_column_bytes(self->_statement, (int)index);
    const void *blob = sqlite3_column_blob(self->_statement, (int)index);
    return [NSData dataWithBytes:blob length:size];
    
}

- (double)floatValueAtColumnIndex:(NSInteger)index {
    
    return sqlite3_column_double(self->_statement, (int)index);
    
}

- (BOOL)isNullAtColumnIndex:(NSInteger)index {
    
    return sqlite3_column_type(self->_statement, (int)index) == SQLITE_NULL;
    
}

- (NSNumber *)numberValueAtColumnIndex:(NSInteger)index {
    
    int type = sqlite3_column_type(self->_statement, (int)index);
    
    switch (type) {
        case SQLITE_NULL:
            return nil;
        case SQLITE_INTEGER:
            return [NSNumber numberWithInteger:[self integerValueAtColumnIndex:index]];
        case SQLITE_FLOAT:
            return [NSNumber numberWithDouble:[self floatValueAtColumnIndex:index]];
        default:
            return nil;
    }
    
    return nil;
    
}

- (id)valueAtColumnIndex:(NSInteger)index {
    
    int type = sqlite3_column_type(self->_statement, (int)index);
    
    switch (type) {
        case SQLITE_NULL:
            return [NSNull null];
        case SQLITE_INTEGER:
            return [NSNumber numberWithInteger:[self integerValueAtColumnIndex:index]];
        case SQLITE_FLOAT:
            return [NSNumber numberWithFloat:[self floatValueAtColumnIndex:index]];
        case SQLITE_TEXT:
            return [self stringValueAtColumnIndex:index];
        case SQLITE_BLOB:
            return [self dataValueAtColumnIndex:index];
        default:
            break;
    }
    
    return nil;
    
}

- (NSDictionary *)values {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSInteger columnCount = self.columnCount;
    
    for (NSInteger i = 0; i < columnCount; i++) {
        NSString *name = [self nameAtColumnIndex:i];
        NSString *value = [self valueAtColumnIndex:i];
        [dictionary setObject:value forKey:name];
    }
    
    return [dictionary copy];
    
}

- (NSArray *)valueArray {
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger columnCount = self.columnCount;
    
    for (NSInteger i = 0; i < columnCount; i++) {
        NSString *value = [self valueAtColumnIndex:i];
        [array addObject:value];
    }
    
    return [array copy];
    
}

#pragma mark Private Methods

- (BOOL)handleResult:(NSError **)errorPtr {
    
    if (self->resultCode != SQLITE_OK && self->resultCode != SQLITE_ROW && self->resultCode != SQLITE_DONE) {
        if (errorPtr)
            *errorPtr = [ProjectDatabaseError errorWithDatabase:self->connection];
        return true;
    }
    
    return false;
    
}

#pragma mark Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])buffer count:(NSUInteger)len {
    
    NSError *error = nil;
    
    if(state->state == 0) {
        
        state->state = 1;
        state->mutationsPtr = &state->extra[0];
        [self reset:&error];
        
        if (error != nil)
            return 0;
        
    }
    
    state->itemsPtr = buffer;
    
    if (self->resultCode == SQLITE_DONE) {
        [self reset:&error];
        return 0;
    }
    
    NSUInteger count = 0;
    
    while (count < len) {
        
        [self step:&error];
        if (error || self->resultCode == SQLITE_DONE)
            break;
        
        buffer[count] = [self values];
        count += 1;
        
    }
    
    return count;
    
}

- (NSDictionary *)firstRow {
    
    NSError *error = nil;
    
    [self step:&error];
    
    if ([self handleResult:&error])
        return nil;
    
    id result = [self values];
    [self reset:&error];
    
    return result;
    
}

- (NSArray *)allRows {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (id row in self)
        [array addObject:row];

    return [array copy];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    if (self->statementFlags.freeWhenDone)
        self->resultCode = sqlite3_finalize(self->_statement);

    [super dealloc];
    
}

@end

#pragma mark - Project Database Error

@implementation ProjectDatabaseError

+ (id)errorWithDatabase:(sqlite3 *)db {
    
    return [[[self alloc] initWithDatabase:db] autorelease];
    
}

- (id)initWithDatabase:(sqlite3 *)db {
    
    return [super initWithDomain:@"sqlite" code:sqlite3_errcode(db) userInfo:@{@"message" : [NSString stringWithUTF8String:sqlite3_errmsg(db)]}];

}

@end