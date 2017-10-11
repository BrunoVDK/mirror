//
//  ProjectStatsPanelController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "ProjectStatsPanelController.h"

#pragma mark Project Statistics Panel Controller

@implementation ProjectStatsPanelController

@synthesize project = _project;

#pragma mark Constructors

- (instancetype)init {
    
    return [super initWithNibName:self.nibName bundle:nil];
    
}

- (NSString *)nibName {
    
    return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
    
}

- (NSString *)panelIdentifier {
    
    return [self.nibName stringByAppendingString:@"Identifier"];
}

- (NSString *)panelTitle {
    
    NSString *title = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"PanelController" withString:@""];
    return [title stringByReplacingOccurrencesOfString:@"ProjectStats" withString:@""];
    
}

- (NSImage *)panelIcon {
    
    return nil;
    
}

@end

#pragma mark Custom Project Stats Panel Controllers

@implementation ProjectStatsFilesPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNameMultipleDocuments];

}

@end

@implementation ProjectStatsOverviewPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Network"];

}

@end