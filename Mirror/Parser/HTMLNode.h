//
//  HTMLNode.h
//  Mirror
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>
#import "HTMLDocument.h"

#define ParsingDepthUnlimited 0
#define ParsingDepthSame -1
#define ParsingDepth size_t

/**
 * An enumeration for HTML node types.
 */
enum {
	HTMLHrefNode,
	HTMLTextNode,
	HTMLUnkownNode,
	HTMLCodeNode,
	HTMLSpanNode,
	HTMLPNode,
	HTMLLiNode,
	HTMLUlNode,
	HTMLImageNode,
	HTMLOlNode,
	HTMLStrongNode,
	HTMLPreNode,
	HTMLBlockQuoteNode,
} typedef HTMLNodeType;

/**
 * The `HTMLNode` class represents a node in an HTML document.
 */
@interface HTMLNode : NSObject {
    @public
	xmlNode * _node;
}

/**
 * Initializes a new HTML node with the given XML node.
 *
 * @param xmlNode An XML node.
 * @return A new HTML node or nil if an error occurred.
 */
- (id)initWithXMLNode:(xmlNode *)xmlNode;

/**
 * Returns the type of this node, if it is known.
 */
- (HTMLNodeType)nodetype;

/**
 * Returns the plain text contents of this node.
 */
- (NSString *)contents;

/**
 * Returns the plain text contents of this node, including the contents of all of its children.
 */
- (NSString *)allContents;

/**
 * Returns the HTML contents of this node.
 */
- (NSString *)rawContents;

/**
 * Returns the class name of this node.
 */
- (NSString *)className;

/**
 * Returns the tag name of this node.
 */
- (NSString *)tagName;

/**
 * Returns the first child node of this node.
 */
- (HTMLNode *)firstChild;

/**
 * Returns the first level of children of this node.
 */
- (NSArray *)children;

/**
 * Returns the parent of this node.
 */
- (HTMLNode *)parent;

/**
 * Returns the next sibling in the tree.
 */
- (HTMLNode *)nextSibling;

/**
 * Returns the previous sibling in the tree.
 */
- (HTMLNode *)previousSibling;

/**
 * Finds and returns a child of this node of given class.
 *
 * @param className The class name of the child to search for.
 * @return A HTML node, child of the given class, or nil if none was found.
 */
-(HTMLNode *)findChildOfClass:(NSString*)className;

/**
 * Finds and returns all children of this node of given class.
 *
 * @param className The class name of the child to search for.
 * @return An array of HTML nodes, children of the given class, or nil if none were found.
 */
- (NSArray *)findChildrenOfClass:(NSString *)className;

/**
 * Finds and returns a single child of this node, having a matching attribute.
 *
 * @param attribute The attribute that has to be matched.
 * @param className The class name of the child to look for.
 * @param partial Set to true if partial matches of the attribute are to be considered.
 * @return An HTML node, child of the given class, with an attribute (partially) matching the given one.
 */
- (HTMLNode *)findChildWithAttribute:(NSString *)attribute matchingName:(NSString *)className allowPartial:(BOOL)partial;

/**
 * Finds and returns all children of this node, having a matching attribute.
 *
 * @param attribute The attribute that has to be matched.
 * @param className The class name of the children to search for.
 * @param partial Set to true if partial matches of the attribute are to be considered.
 * @return An array of HTML nodes, children of the given class, each with an attribute (partially) matching the given one.
 */
- (NSArray *)findChildrenWithAttribute:(NSString *)attribute matchingName:(NSString *)className allowPartial:(BOOL)partial;

/**
 * Get the value of this node for the attribute matching the given name.
 *
 * @param name The name of the attribute.
 * @return The value of this node for the attribute matching the given name.
 */
- (NSString *)getAttributeNamed:(NSString *)name;

/**
 * Searches and returns a child of this node having the given tag name (eg. "pre" or "h1").
 *
 * @param tagName The name of the tag to look for.
 * @return An HTML node, child of the given class, with a tag name matching the given one.
 */
- (HTMLNode *)findChildOfType:(NSString *)tagName;

/**
 * Searches and returns the children of this node having the given tag name (eg. "pre" or "h1").
 *
 * @param tagName The name of the tag to look for.
 * @return An array of HTML nodes, children of the given class, with a tag name matching the given one.
 */
- (NSArray *)findChildrenOfType:(NSString *)tagName;

@end
