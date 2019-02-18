//
//  HTMLDocument.h
//  Mirror
//
//  Created by Ben Reeves on 09/03/2010. Slightly adapted by Bruno Vandekerkhove on 03/09/2016.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>
#import "HTMLNode.h"

@class HTMLNode;

/**
 * The `HTMLDocument` class represents an HTML document. It is parsed on initialization.
 */
@interface HTMLDocument : NSObject {
	@public
	htmlDocPtr _doc;
}

/**
 * Initializes a new HTML document with the contents of the given URL.
 *
 * @param url The URL pointing to the contents for the new HTML document.
 * @param error A pointer to an error object, used for reporting any error occurring along the way.
 * @return A new HTML document or nil if an error occurred.
 */
- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error;

/**
 * Initializes a new HTML document using the given data.
 *
 * @param data The data to initialize the HTML document with.
 * @param error A pointer to an error object, used for reporting any error occurring along the way.
 * @return A new HTML document or nil if an error occurred.
 */
- (id)initWithData:(NSData *)data error:(NSError **)error;

/**
 * Initializes a new HTML document with the contents of the given string.
 *
 * @param string A string having HTML code.
 * @param error A pointer to an error object, used for reporting any error occurring along the way.
 * @return A new HTML document or nil if an error occurred.
 */
- (id)initWithString:(NSString *)string error:(NSError **)error;

/**
 * Returns the contents of this HTML document.
 */
- (HTMLNode *)doc;

/**
 * Returns that part of this HTML document that is enclosed in <html>...</html> tags.
 */
- (HTMLNode *)html;

/**
 * Returns that part of this HTML document that is enclosed in <body>...</body> tags.
 */
- (HTMLNode *)body;

/**
 * Returns that part of this HTML document that is enclosed in <head>...</head> tags.
 */
- (HTMLNode *)head;

@end
