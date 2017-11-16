//
//  ProjectStatsDictionary.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 27/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "Globals.h"
#import "NSString+Additions.h"
#import "Project.h"
#import "ProjectFile.h"
#import "ProjectNotification.h"
#import "ProjectStatsDictionary.h"
#import "WindowAdaptedCell.h"
#include "VerticallyCenteredTextFieldCell.h"

/**
 * An enumeration for statistics keeping the number of files saved by a `Project`.
 */
enum {
    /**
     * A type of statistic denoting the amount of HTML files saved by a project.
     */
    ProjectStatisticHTMLFiles = 0,
    /**
     * A type of statistic denoting the amount of images saved by a project.
     */
    ProjectStatisticImageFiles,
    /**
     * A type of statistic denoting the amount of audio files saved by a project.
     */
    ProjectStatisticAudioFiles,
    /**
     * A type of statistic denoting the amount of movie files saved by a project.
     */
    ProjectStatisticMovieFiles,
    /**
     * A type of statistic denoting the amount of miscellaneous files saved by a project.
     */
    ProjectStatisticOtherFiles,
    /**
     * The number of statistics that have been defined.
     */
    ProjectStatisticFileCount,
} typedef ProjectStatisticFileType;

#pragma mark Project Stats Custom Cells (Private Helper Classes)

@interface ProjectStatsFileTypeCell : WindowAdaptedTextFieldCell {
    
    NSColor *_bulletColor;
    
}

@property (nonatomic, copy) NSColor *bulletColor;

@end

#pragma mark - Project Statistic (Private Helper Class)

@interface ProjectStat : NSObject<NSCoding> {
    
    NSInteger _type;
    id _value;
    
}

@property (nonatomic, readonly) NSInteger type;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, retain) id value;

- (id)initWithType:(NSInteger)type value:(id)value;
- (void)incrementValue; // Only for numerical stats

@end

@interface ProjectStatFileType : ProjectStat
@end

#pragma mark - Project Statistics Dictionary

@implementation ProjectStatsDictionary

@synthesize project = _project, outlineView = _outlineView;

#pragma mark Auxiliary Class Methods (Private)

+ (NSString *)descriptionForStatisticType:(ProjectStatisticType)type {
    
    static NSString *statisticDescriptions[] = {@"Transfer Rate", @"Files", @"Active Sockets", @"Warnings", @"Errors", @"Updates", @"Bytes scanned", @"Received bytes", @"Links", @"Elapsed time"};
    
    return statisticDescriptions[type];
    
}

+ (NSString *)keyForStatisticType:(ProjectStatisticType)type {
    
    static NSString *statisticKeys[] = {@"TransferRate", @"Files", @"Sockets", @"Warnings", @"Errors", @"Updates", @"BytesScanned", @"ReceivedBytes", @"Links", @"ElapsedTime"};
    
    return statisticKeys[type];
    
}

+ (NSString *)descriptionForFileType:(ProjectStatisticFileType)type {
    
    static NSString *fileDescriptions[] = {@"HTML files", @"Image files", @"Audio files", @"Video files", @"Other files"};
    
    return fileDescriptions[type];
    
}

+ (NSString *)keyForFileType:(ProjectStatisticType)type {
    
    static NSString *statisticKeys[] = {@"HTMLFiles", @"ImageFiles", @"AudioFiles", @"VideoFiles", @"OtherFiles"};
    
    return statisticKeys[type];
    
}

#pragma mark Constructors

- (id)init {
    
    return [self initWithProject:nil];
    
}

- (id)initWithProject:(Project *)project {
    
    return [self initWithProject:project usingDictionary:nil];
    
}

- (id)initWithProject:(Project *)project usingDictionary:(ProjectStatsDictionary *)dictionary {
    
    if (self = [super init]) {
        
        [self reset];
        [self adoptDictionary:dictionary]; // Read dictionary and copy its values into the newly created dictionary
        _project = project; // Assign
        
    }
    
    return self;
    
}

- (void)reset {
    
    if (statistics)
        [statistics release];
    statistics = [[NSMutableArray alloc] initWithCapacity:ProjectStatisticCount];
    for (int type=0 ; type<ProjectStatisticCount ; type++)
        [statistics addObject:[[ProjectStat alloc] initWithType:type value:@"--"]];
    
    if (fileTypes)
        [fileTypes release];
    fileTypes = [[NSMutableArray alloc] initWithCapacity:ProjectStatisticFileCount];
    for (int type=0 ; type<ProjectStatisticFileCount ; type++)
        [fileTypes addObject:[[ProjectStatFileType alloc] initWithType:type value:[NSNumber numberWithInt:0]]];
    
    if (pieGraphView)
        [pieGraphView release];
    pieGraphView = [[PieGraphView alloc] init];
    while ([pieGraphView numberOfSlices] < [fileTypes count])
        [pieGraphView addSliceWithWeight:0];
    [pieGraphView adoptTheme:PieGraphThemeClassic];
    [self addPieGraphViewToOutlineView:_outlineView];
    
    int types[] = {ProjectStatisticWarnings, ProjectStatisticErrors, ProjectStatisticInfoMessages};
    for (int i=0 ; i<3 ; i++)
        [(ProjectStat *)[statistics objectAtIndex:types[i]] setValue:[NSNumber numberWithInt:0]];
    
    [_outlineView reloadData];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [self init]) {
        
        [statistics release];
        [fileTypes release];
        statistics = [[aDecoder decodeObjectForKey:@"Statistics"] mutableCopy];
        fileTypes = [[aDecoder decodeObjectForKey:@"FileTypes"] mutableCopy];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:statistics forKey:@"Statistics"];
    [aCoder encodeObject:fileTypes forKey:@"FileTypes"];
    
}

- (void)adoptDictionary:(ProjectStatsDictionary *)dictionary {
    
    if (dictionary) {
        
        for (int type=0 ; type<ProjectStatisticCount ; type++)
            [self setValue:[dictionary valueForStatisticOfType:(ProjectStatisticType)type] forStatisticOfType:(ProjectStatisticType)type];
        
        for (int type=0 ; type<ProjectStatisticFileCount ; type++)
            [(ProjectStatFileType *)[fileTypes objectAtIndex:type] setValue:[NSNumber numberWithInt:[dictionary nbOfFilesOfType:type]]];
        
    }
    
}

#pragma mark Statistics

- (id)valueForStatisticOfType:(ProjectStatisticType)type {
    
    if (type < [statistics count])
        return [(ProjectStat *)[statistics objectAtIndex:type] value];
    
    return nil;
    
}

- (void)setValue:(id)value forStatisticOfType:(ProjectStatisticType)type {
    
    if (type < [statistics count]) {
        [(ProjectStat *)[statistics objectAtIndex:type] setValue:value];
        // [_outlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:type] columnIndexes:[NSIndexSet indexSetWithIndex:2]];
    }
    
}

- (int)nbOfFilesOfType:(ProjectStatisticFileType)type {
    
    if (type < [fileTypes count])
        return [(ProjectStatFileType *)[fileTypes objectAtIndex:type] value];
    
    return 0;
    
}

#pragma mark Interface

- (void)setPieGraphTheme:(PieGraphTheme)theme {
    
    [_outlineView reloadData];
    [pieGraphView adoptTheme:theme];
    
}

#pragma mark Notification Center

- (void)registerFile:(ProjectFile *)file {
    
    if (file) { // Adapt file type stats
        
        ProjectStatisticFileType fileType = ProjectStatisticOtherFiles;
        CFStringRef fileUTI = (CFStringRef)[file.path UTI]; // Get Uniform Type Identifier to determine file type
        if (UTTypeConformsTo(fileUTI, kUTTypeImage))
            fileType = ProjectStatisticImageFiles;
        else if (UTTypeConformsTo(fileUTI, kUTTypeMovie))
            fileType = ProjectStatisticMovieFiles;
        else if (UTTypeConformsTo(fileUTI, kUTTypeHTML))
            fileType = ProjectStatisticHTMLFiles;
        else if (UTTypeConformsTo(fileUTI, kUTTypeAudio))
            fileType = ProjectStatisticAudioFiles;
        
        [(ProjectStat *)[fileTypes objectAtIndex:fileType] incrementValue];
        [pieGraphView addWeight:1 toSliceAtIndex:fileType];
        [(ProjectStat *)[statistics objectAtIndex:ProjectStatisticWritten] incrementValue];
        
        [_outlineView reloadData];
        
    }
    
}

- (void)registerNotification:(ProjectNotification *)notification {
    
    switch (notification.type) {
        case ProjectNotificationWarning:
            [(ProjectStat *)[statistics objectAtIndex:ProjectStatisticWarnings] incrementValue];
            break;
        case ProjectNotificationError:
            [(ProjectStat *)[statistics objectAtIndex:ProjectStatisticErrors] incrementValue];
            break;
        case ProjectNotificationUpdate:
            [(ProjectStat *)[statistics objectAtIndex:ProjectStatisticInfoMessages] incrementValue];
            break;
        default:
            break;
    }
    
}

#pragma mark Outline View Data Source & Delegation

- (void)setOutlineView:(NSOutlineView *)outlineView {
    
    if (outlineView) {
        
        if (outlineView != _outlineView) {
            
            outlineView.dataSource = self;
            outlineView.delegate = self;
            // [self addPieGraphViewToOutlineView:outlineView];
            outlineView.autoresizesSubviews = true;
            outlineView.outlineTableColumn.resizingMask = NSTableColumnAutoresizingMask;
            [outlineView expandItem:[statistics objectAtIndex:ProjectStatisticWritten]];
            
        }
        
    }
    else
        [pieGraphView removeFromSuperview];
    
    _outlineView = outlineView;
    
    
}
             
- (void)addPieGraphViewToOutlineView:(NSOutlineView *)outlineView {
    
    if (outlineView)
        return;
    
    if (pieGraphView.superview != nil)
        [pieGraphView removeFromSuperview];
    
    NSRect pieFrame = NSIntersectionRect([outlineView rectOfColumn:2], NSUnionRect([outlineView rectOfRow:1], [outlineView rectOfRow:3]));
    pieFrame = NSInsetRect(pieFrame, 0, 8);
    pieFrame.origin.y += 3;
    
    pieGraphView.enabled = true;
    [pieGraphView setHidden:false];
    [_outlineView addSubview:pieGraphView];
    pieGraphView.frame = pieFrame;
    pieGraphView.autoresizingMask = NSViewMinXMargin;
    
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    
    if (item == nil)
        return [statistics count];
        
    ProjectStat *stat = (ProjectStat *)item;
    if ([stat isMemberOfClass:[ProjectStat class]] && stat.type == ProjectStatisticWritten)
        return [fileTypes count];
    
    return 0;
    
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    if (item == nil)
        return [statistics objectAtIndex:index];
    
    ProjectStat *stat = (ProjectStat *)item;
    if (stat.type == ProjectStatisticWritten)
        return [fileTypes objectAtIndex:index];
    
    return nil;
    
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification { // Can currently assume this is the 'files written' item
    
    [pieGraphView setHidden:true];
    
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification { // Can currently assume this is the 'files written' item
    
    [pieGraphView setHidden:false];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    
    return IS_MAIN(outlineView.window);
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
        
    return [self outlineView:outlineView numberOfChildrenOfItem:item] > 0;
    
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    NSString *identifier = [tableColumn identifier];
    ProjectStat *stat = (ProjectStat *)item;
    [cell setFont:[NSFont systemFontOfSize:11.0]];
    
    if ([identifier isEqualToString:@"Title"]) {
        
        if ([stat isMemberOfClass:[ProjectStatFileType class]]) {
            [fileTypeCell setBulletColor:[pieGraphView colorOfSliceAtIndex:stat.type]];
            [cell setFont:[NSFont systemFontOfSize:8.0]];
        }
        
        [cell setStringValue:[item valueForKey:identifier.lowercaseString]];
        
    }
    else if ([identifier isEqualToString:@"Description"]) {
        
        // if ([stat type] == ProjectStatisticWritten && [outlineView isItemExpanded:item])
        //    [cell setStringValue:@""];
        // else if ([item isMemberOfClass:[ProjectStatFileType class]]) {
        if ([item isMemberOfClass:[ProjectStatFileType class]]) {
            
            NSInteger type = [(ProjectStatFileType *)item type];
            [cell setStringValue:[(ProjectStat *)[fileTypes objectAtIndex:type] value]];
            
            /*
            if (stat.type == ProjectStatisticAudioFiles)
                [cell setStringValue:[(ProjectStat *)[statistics objectAtIndex:ProjectStatisticWritten] description]];
             */
            
            [cell setFont:[NSFont systemFontOfSize:8.0]];
            
        }
        else
            [cell setStringValue:[item description]];
        
    }
        
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    
    return false;
    
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"Title"] && [item isMemberOfClass:[ProjectStatFileType class]]) { // For file counts per type
        
        if (!fileTypeCell) {
            
            fileTypeCell = [ProjectStatsFileTypeCell new];
            
            NSTextFieldCell *modelCell = [tableColumn dataCellForRow:0];
            [fileTypeCell setFont:modelCell.font];
            [fileTypeCell setTextColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]];
            [fileTypeCell setFont:[NSFont systemFontOfSize:10.0]];
            
        }
        
        return fileTypeCell;
        
    }
    
    return nil;
    
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    
    if ([item isMemberOfClass:[ProjectStatFileType class]])
        return 18.0;
    else if ([(ProjectStat *)item type] == ProjectStatisticTransferRate)
        return 20.0;
    else if ([(ProjectStat *)item type] == ProjectStatisticWritten)
        return 17.0;
    
    return 17.0;
    
}

#pragma mark Memory Management

- (void)dealloc {
        
    _project = nil;
    
    [statistics release];
    [fileTypes release];
    
    [fileTypeCell release];
    
    [pieGraphView release];
    
    [super dealloc];
    
}

@end

#pragma mark - Project Statistic

@implementation ProjectStat

@dynamic title;
@synthesize type = _type, value = _value;

#pragma mark Constructors

- (id)init {
    
    return [self initWithType:ProjectStatisticCount value:nil];
    
}

- (id)initWithType:(NSInteger)type value:(id)value {
    
    if (self = [super init]) {
        
        _type = type;
        self.value = value;
        
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([super init]) {
        _type = [aDecoder decodeIntegerForKey:@"type"];
        _value = [[aDecoder decodeObjectForKey:@"value"] retain];
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:_type forKey:@"type"];
    [aCoder encodeObject:_value forKey:@"value"];
    
}

#pragma mark Accessors

- (NSString *)description {
    
    // if (self.type == ProjectStatisticWritten)
        // return [NSString stringWithFormat:@"%@ written", self.value];
    
    if ([self.value isKindOfClass:[NSString class]])
        return self.value;
    
    return [self.value stringValue];
    
}

- (NSString *)title {
    
    if (self.type == ProjectStatisticCount)
        return nil;
    
    return [ProjectStatsDictionary descriptionForStatisticType:(ProjectStatisticType)self.type];
    
}

#pragma mark Mutators

- (void)incrementValue {
    
    if ([self.value isKindOfClass:[NSNumber class]])
        self.value = [NSNumber numberWithInt:[self.value intValue] + 1];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    self.value = nil;
    
    [super dealloc];
    
}

@end

@implementation ProjectStatFileType

- (NSString *)title {
    
    if (self.type == ProjectStatisticFileCount)
        return nil;
    
    return [ProjectStatsDictionary descriptionForFileType:(ProjectStatisticFileType)self.type];
    
}

@end

#pragma mark - Project Statistic Custom Cells

@implementation ProjectStatsFileTypeCell

@synthesize bulletColor = _bulletColor;

- (id)copyWithZone:(NSZone *)zone {
    
    ProjectStatsFileTypeCell *copy = [super copyWithZone:zone];
    
    if (copy)
        copy.bulletColor = self.bulletColor;
    
    return copy;
    
}

#define RECTANGULAR_BULLETS 1
#define BULLET_SIZE 10

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    if (self.bulletColor) {
        
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextSaveGState(context);
        
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
        if (!IS_MAIN(controlView.window)) {
            CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1.0);
            CGContextSetRGBFillColor(context, 0.95, 0.95, 0.95, 1.0);
        }
        else {
#endif
            CGContextSetRGBStrokeColor(context, 0.50, 0.50, 0.50, 1.0);
            CGContextSetFillColorWithColor(context, self.bulletColor.CGColor);
#if CHANGE_NONKEY_MAIN_WINDOW_DESIGN
        }
#endif
        
        NSSize titleSize = [[self attributedStringValue] size];
        NSRect titleRect = NSZeroRect;
        titleRect.origin.x = (cellFrame.size.width - titleSize.width) / 2 + cellFrame.origin.x;
        titleRect.origin.y = (cellFrame.size.height - titleSize.height) / 2 + cellFrame.origin.y;
        titleRect.size = titleSize;
        
        CGRect outline = CGRectMake(titleRect.origin.x - BULLET_SIZE - 10,
                                    titleRect.origin.y + (titleRect.size.height - BULLET_SIZE) / 2,
                                    BULLET_SIZE,
                                    BULLET_SIZE);
        CGRect inside = CGRectInset(outline, 2, 2);
        
#if RECTANGULAR_BULLETS
        // CGContextStrokeRect(context, outline);
        CGContextFillRect(context, inside);
#else
        // CGContextStrokeEllipseInRect(context, outline);
        CGContextFillEllipseInRect(context, inside);
#endif
        
        [[self attributedStringValue] drawInRect:titleRect];
        
        CGContextRestoreGState(context);
        
    }
        
}

@end