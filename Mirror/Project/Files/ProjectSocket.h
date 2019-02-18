//
//  ProjectSocket.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 10/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An enumeration for types of sockets held by a `Project` instance.
 */
enum {
    ProjectSocketParsing = 0,
    ProjectSocketReception,
    ProjectSocketRequesting,
    ProjectSocketConnection,
    ProjectSocketSearch,
    ProjectSocketReady,
    ProjectSocketError,
    ProjectSocketOther,
} typedef ProjectSocketType;

/**
 * A `ProjectSocket` represents a socket of a `Project`, with a type, an address, a file, a size and a total size.
 */
@interface ProjectSocket : NSObject <NSCopying> {
    
    ProjectSocketType _type;
    NSString *_address, *_file;
    unsigned long long _size, _totalSize;
    
}

/**
 * This project socket's icon.
 */
@property (nonatomic, readonly) NSImage *icon;

/**
 * The type of this socket.
 */
@property (nonatomic, readwrite) ProjectSocketType type;

/**
 * The address this socket refers to.
 */
@property (nonatomic, retain) NSString *address;

/**
 * The file this socket refers to.
 */
@property (nonatomic, retain) NSString *file;

/**
 * The size of this socket's associated file.
 */
@property (nonatomic, readwrite) unsigned long long size;

/**
 * The size of this socket's associated total size.
 */
@property (nonatomic, readwrite) unsigned long long totalSize;

/**
 * The progress of this socket.
 */
@property (nonatomic, readonly) float progress;

/**
 * Create a new socket with given address, file path, size and total size.
 *
 * @param address The source address of the new socket.
 * @param file The file associated with the new socket.
 * @param size The size for the socket's associated file.
 * @param totalSize The total size for the socket's associated file.
 * @return A nproject file with the given attributes.
 */
+ (id)socketWithAddress:(NSString *)address file:(NSString *)file size:(unsigned long long)size totalSize:(unsigned long long)totalSize;

/**
 * Initialize a new socket with given address, file path, size and total size.
 *
 * @param address The source address of the new socket.
 * @param file The file associated with the new socket.
 * @param size The size for the socket's associated file.
 * @param totalSize The total size for the socket's associated file.
 * @return A newly allocated project file with the given attributes.
 */
- (id)initWithAddress:(NSString *)address file:(NSString *)file size:(unsigned long long)size totalSize:(unsigned long long)totalSize;

/**
 * A description of this socket, that is, its type followed by the associated file's name.
 */
- (NSString *)socketDescription;

/**
 * Returns the file name of this socket's associated file.
 *
 * @return The filename of this socket's associated file.
 */
- (NSString *)fileName;

@end
