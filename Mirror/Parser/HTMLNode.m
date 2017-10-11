//
//  HTMLNode.m
//  Mirror
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import "HTMLNode.h"
#import <libxml/HTMLtree.h>

@implementation HTMLNode

#pragma mark Constructors

- (id)initWithXMLNode:(xmlNode *)xmlNode {
    
    if (self = [super init])
        _node = xmlNode;
    
    return self;
    
}

#pragma mark Getters

- (HTMLNodeType)nodetype {
    
    return nodeType(_node);
    
}

HTMLNodeType nodeType(xmlNode *_node) {
    
    if (_node == NULL || _node->name == NULL)
        return HTMLUnkownNode;
    
    const char *tagName = (const char *)_node->name;
    
    if (strcmp(tagName, "a") == 0)
        return HTMLHrefNode;
    else if (strcmp(tagName, "text") == 0)
        return HTMLTextNode;
    else if (strcmp(tagName, "code") == 0)
        return HTMLCodeNode;
    else if (strcmp(tagName, "span") == 0)
        return HTMLSpanNode;
    else if (strcmp(tagName, "p") == 0)
        return HTMLPNode;
    else if (strcmp(tagName, "ul") == 0)
        return HTMLUlNode;
    else if (strcmp(tagName, "li") == 0)
        return HTMLLiNode;
    else if (strcmp(tagName, "image") == 0)
        return HTMLImageNode;
    else if (strcmp(tagName, "ol") == 0)
        return HTMLOlNode;
    else if (strcmp(tagName, "strong") == 0)
        return HTMLStrongNode;
    else if (strcmp(tagName, "pre") == 0)
        return HTMLPreNode;
    else if (strcmp(tagName, "blockquote") == 0)
        return HTMLBlockQuoteNode;
    else
        return HTMLUnkownNode;
    
}

-(NSString *)contents {
    
    if (_node->children && _node->children->content)
        return [NSString stringWithCString:(void *)_node->children->content encoding:NSUTF8StringEncoding];
    
    return nil;
    
}

- (NSString *)allContents {
    
    return allNodeContents(_node);
    
}

NSString *allNodeContents(xmlNode *node) {
    
    if (node == NULL)
        return nil;
    
    void *contents = xmlNodeGetContent(node);
    if (contents) {
        NSString *string = [NSString stringWithCString:contents encoding:NSUTF8StringEncoding];
        xmlFree(contents);
        return string;
    }
    
    return @"";
    
}

- (NSString *)rawContents {
    
    return rawContentsOfNode(_node);
    
}

NSString *rawContentsOfNode(xmlNode * node) {
    
    xmlBufferPtr buffer = xmlBufferCreateSize(1000);
    xmlOutputBufferPtr buf = xmlOutputBufferCreateBuffer(buffer, NULL);
    htmlNodeDumpOutput(buf, node->doc, node, (const char *)node->doc->encoding);
    xmlOutputBufferFlush(buf);
    NSString *string = nil;
    
    if (buffer->content)
        string = [[NSString alloc] initWithBytes:(const void *)xmlBufferContent(buffer) length:xmlBufferLength(buffer) encoding:NSUTF8StringEncoding];
    
    xmlOutputBufferClose(buf);
    xmlBufferFree(buffer);
    
    return string;
    
}

- (NSString *)className {
    
    return [self getAttributeNamed:@"class"];
    
}

- (NSString *)tagName {
    
    return [NSString stringWithCString:(void *)_node->name encoding:NSUTF8StringEncoding];
    
}

- (HTMLNode *)firstChild {
    
    return [[HTMLNode alloc] initWithXMLNode:_node->children];
    
}

- (NSArray *)children {
    
    xmlNode *cur_node = NULL;
    NSMutableArray *array = [NSMutableArray array];
    
    for (cur_node = _node->children ; cur_node ; cur_node = cur_node->next) {
        HTMLNode *node = [[HTMLNode alloc] initWithXMLNode:cur_node];
        [array addObject:node];
    }
    
    return array;
    
}

- (HTMLNode *)parent {
    
	return [[HTMLNode alloc] initWithXMLNode:_node->parent];
    
}

- (HTMLNode *)nextSibling {
    
	return [[HTMLNode alloc] initWithXMLNode:_node->next];
    
}

- (HTMLNode *)previousSibling {
    
	return [[HTMLNode alloc] initWithXMLNode:_node->prev];
    
}

- (NSString *)description {
    
    NSString *string = [NSString stringWithFormat:@"<%s>%@\n", _node->name, [self contents]];
    for (HTMLNode * child in [self children])
        string = [string stringByAppendingString:[child description]];
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<%s>\n", _node->name]];
    
    return string;
    
}

#pragma mark Searching

- (HTMLNode *)findChildOfClass:(NSString *)className {
    
    HTMLNode *node = [self findChildWithAttribute:"class" matchingName:[className UTF8String] inXMLNode:_node->children allowPartial:false];
    return node;
    
}

- (NSArray *)findChildrenOfClass:(NSString *)className {
    
    return [self findChildrenWithAttribute:@"class" matchingName:className allowPartial:false];
    
}

- (HTMLNode *)findChildWithAttribute:(NSString *)attribute matchingName:(NSString *)className allowPartial:(BOOL)partial {
    
    return [self findChildWithAttribute:[attribute UTF8String] matchingName:[className UTF8String] inXMLNode:_node->children allowPartial:partial];
    
}

- (HTMLNode *)findChildWithAttribute:(const char *)attribute matchingName:(const char *)name inXMLNode:(xmlNode *)node allowPartial:(BOOL)partial {
    
    xmlNode *cur_node = NULL;
    const char *classNameStr = name;
    
    if (node == NULL)
        return NULL;
    
    for (cur_node = node; cur_node; cur_node = cur_node->next) {
        
        for(xmlAttrPtr attr = cur_node->properties ; NULL != attr ; attr = attr->next) {
            if (strcmp((char *)attr->name, attribute) == 0) {
                for(xmlNode *child = attr->children ; NULL != child ; child = child->next) {
                    
                    BOOL match = false;
                    if (!partial && strcmp((char *)child->content, classNameStr) == 0)
                        match = true;
                    else if (partial && strstr ((char *)child->content, classNameStr) != NULL)
                        match = true;
                    
                    if (match)
                        return [[HTMLNode alloc] initWithXMLNode:cur_node];
                    
                }
                
                break;
                
            }
            
        }
        
        HTMLNode *cNode = [self findChildWithAttribute:attribute matchingName:name inXMLNode:cur_node->children allowPartial:partial];
        if (cNode != NULL)
            return cNode;
        
    }
    
    return NULL;
    
}

-(NSArray *)findChildrenWithAttribute:(NSString *)attribute matchingName:(NSString *)className allowPartial:(BOOL)partial {
    
    NSMutableArray * array = [NSMutableArray array];
    [self findChildrenWithAttribute:[attribute UTF8String] matchingName:[className UTF8String] inXMLNode:_node->children inArray:array allowPartial:partial];
    return array;
    
}

- (void)findChildrenWithAttribute:(const char *)attribute
                    matchingName:(const char *)className
                       inXMLNode:(xmlNode *)node
                         inArray:(NSMutableArray *)array
                    allowPartial:(BOOL)partial {
    
    xmlNode *cur_node = NULL;
    const char *classNameStr = className;
    
    for (cur_node = node ; cur_node ; cur_node = cur_node->next) {
        
        for(xmlAttrPtr attr = cur_node->properties ; NULL != attr ; attr = attr->next) {
            if (strcmp((char *)attr->name, attribute) == 0) {
                for(xmlNode *child = attr->children ; NULL != child ; child = child->next) {
                    
                    BOOL match = false;
                    if (!partial && strcmp((char *)child->content, classNameStr) == 0)
                        match = true;
                    else if (partial && strstr ((char *)child->content, classNameStr) != NULL)
                        match = true;
                    
                    if (match) {
                        HTMLNode *nNode = [[HTMLNode alloc] initWithXMLNode:cur_node];
                        [array addObject:nNode];
                        break;
                    }
                    
                }
                
                break;
                
            }
        }
        
        [self findChildrenWithAttribute:attribute matchingName:className inXMLNode:cur_node->children inArray:array allowPartial:partial];
        
    }	
    
}

- (NSString *)getAttributeNamed:(NSString *)name {
    
    const char *nameStr = [name UTF8String];
    return getAttributeNamed(_node, nameStr);
    
}

void setAttributeNamed(xmlNode *node, const char *nameStr, const char *value) {
	
	char *newVal = (char *)malloc(strlen(value) + 1);
	memcpy(newVal, value, strlen(value) + 1);

	for(xmlAttrPtr attr = node->properties ; NULL != attr ; attr = attr->next) {
		if (strcmp((char *)attr->name, nameStr) == 0) {
            
			for(xmlNode *child = attr->children ; NULL != child ; child = child->next) {
				free(child->content);
				child->content = (xmlChar *)newVal;
				break;
			}
            
			break;
            
		}
	}
	
}

NSString *getAttributeNamed(xmlNode *node, const char *nameStr) {
    
	for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next) {
		if (strcmp((char *)attr->name, nameStr) == 0) {
            
			for(xmlNode *child = attr->children; NULL != child; child = child->next) {
				return [NSString stringWithCString:(void *)child->content encoding:NSUTF8StringEncoding];
			}
            
			break;
            
		}
	}
	
	return NULL;
}

- (HTMLNode *)findChildOfType:(NSString *)tagName {
    
    return [self findChildOfType:tagName inXMLNode:_node->children];
    
}

- (HTMLNode *)findChildOfType:(NSString *)tagName inXMLNode:(xmlNode *)node {
    
    xmlNode *cur_node = NULL;
    const char *tagNameStr =  [tagName UTF8String];
    
    for (cur_node = node ; cur_node ; cur_node = cur_node->next) {
        
        if (cur_node && cur_node->name && strcmp((char *)cur_node->name, tagNameStr) == 0)
            return [[HTMLNode alloc] initWithXMLNode:cur_node];
        
        HTMLNode *cNode = [self findChildOfType:tagName inXMLNode:cur_node->children];
        if (cNode != NULL)
            return cNode;
        
    }
    
    return NULL;
    
}

-(NSArray *)findChildrenOfType:(NSString *)tagName {
    
    NSMutableArray *array = [NSMutableArray array];
    [self findChildrenOfType:tagName inXMLNode:_node->children inArray:array];
    
    return array;
    
}

- (void)findChildrenOfType:(NSString *)tagName inXMLNode:(xmlNode *)node inArray:(NSMutableArray *)array {
    
    xmlNode *cur_node = NULL;
    const char *tagNameStr =  [tagName UTF8String];
    
    if (tagNameStr == nil)
        return;
    
    for (cur_node = node ; cur_node ; cur_node = cur_node->next) {
        
        if (cur_node->name && strcmp((char *)cur_node->name, tagNameStr) == 0) {
            HTMLNode *node = [[HTMLNode alloc] initWithXMLNode:cur_node];
            [array addObject:node];
        }
        
        [self findChildrenOfType:tagName inXMLNode:cur_node->children inArray:array];
        
    }
    
}


#pragma mark Misc

- (void)appendChildContentsToString:(NSMutableString *)string inNode:(xmlNode *)node {
    
	if (node == NULL)
		return;
	
	xmlNode *cur_node = NULL;	
    for (cur_node = node ; cur_node ; cur_node = cur_node->next) {
        
		if (cur_node->content)
			[string appendString:[NSString stringWithCString:(void *)cur_node->content encoding:NSUTF8StringEncoding]];
		
		[self appendChildContentsToString:string inNode:cur_node->children];
        
	}
    
}

@end
