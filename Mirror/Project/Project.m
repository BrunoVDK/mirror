//
//  Project.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 12/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//


#import <time.h>

#include "htslib.h"

#import "CircularBuffer.h"
#import "Globals.h"
#import "NSString+Additions.h"
#import "PreferencesConstants.h"
#import "Project.h"
#import "ProjectFile.h"
#import "ProjectFileList.h"
#import "ProjectNotification.h"
#import "ProjectNotificationList.h"
#import "ProjectOptionsDictionary.h"
#import "ProjectSocket.h"
#import "ProjectSocketList.h"
#import "ProjectStatsDictionary.h"
#import "ProjectStatsWindowController.h"
#import "ProjectURL.h"
#import "ProjectWindowController.h"

#pragma mark - Project

NSString *const ProjectDidAddFileNotification = @"ProjectDidAddFileNotification";

int fexist(const char *s);
off_t fsize(const char *s);

typedef struct engineOptions { // Project options structure
    int argc;
    char** argv;
} engineOptionsArguments;

@interface Project()

@property (readwrite) BOOL shouldCancel;
@property (readwrite) int addRetries;
@property (nonatomic, readonly) CircularBuffer *addURLBuffer;

- (ProjectWindow *)window;
- (void)mirrorInBackground;

int __cdecl httrack_start(t_hts_callbackarg *carg, httrackp *opt);
int __cdecl httrack_end(t_hts_callbackarg *carg, httrackp *opt);
int __cdecl httrack_loop(t_hts_callbackarg *carg, httrackp *opt, lien_back *back, int back_max, int back_index, int lien_n, int lien_tot, int stat_time, hts_stat_struct * stats);

// void __cdecl httrack_filesave2(t_hts_callbackarg *carg, httrackp *opt, const char *adr, const char *file, const char *save, int is_new, int is_modified, int not_updated);
void __cdecl httrack_filesave(t_hts_callbackarg * carg, httrackp * opt, const char *file, const char *adr, const char *save, LLint size);

int __cdecl httrack_savename(t_hts_callbackarg *carg, httrackp *opt, const char *adr, const char *file, const char *referer_adr, const char *referer, char *save);
void __cdecl httrack_baseupdated(t_hts_callbackarg *carg, httrackp *opt, uint8_t base_id, LLint bytes_received, LLint bytes_written, int links_written);
void __cdecl httrack_log(t_hts_callbackarg *carg, httrackp *opt, int type, const char *format, va_list args);

@end

@implementation Project

@synthesize windowController = _windowController, options = _options, statistics = _statistics, shouldCancel = _shouldCancel, addURLBuffer = _addURLBuffer, started = _started, delegate = _delegate, exportDirectory = _exportDirectory, URLs = _URLs, addRetries = _addRetries, completed = _completed, writingPermission = _writingPermission, files = _files, sockets = _sockets, notifications = _notifications;

#pragma mark Class Methods

+ (BOOL)autosavesInPlace {
    
    return false;
    
}

#pragma mark Constructors

- (id)init { // All the project properties are truly initialized in '-readFromData:ofType:error:'
    
    self = [super init]; // "If you override init, make sure that your override never returns nil." - Apple docs
    
    _URLs = [NSMutableArray new];
    _addURLBuffer = [[CircularBuffer alloc] initWithCapacity:MAX_URLS];
    _cancelURLBuffer = [[CircularBuffer alloc] initWithCapacity:MAX_URLS];
    
    _options = [ProjectOptionsDictionary new]; // A new dictionary means that the default options are used (options are set when reading a document)
    filters = [NSMutableArray new];
    engineOptions = hts_create_opt();
    assert(engineOptions->size_httrackp == sizeof(httrackp));
    
    _statistics = [ProjectStatsDictionary new];
    
    _files = [ProjectFileList new];
    _sockets = [ProjectSocketList new];
    _notifications = [ProjectNotificationList new];
    
    _started = _completed = false;
    
    _shouldCancel = false;
    self.hasUndoManager = false;
    
    return self;
    
}

#pragma mark Model

- (ProjectURL *)rootURL {
    
    return (self.URLs.count > 0 ? [[self URLs] objectAtIndex:0] : nil);
    
}

- (ProjectURL *)addURL:(NSURL *)url {
    
    for (ProjectURL *projectURL in self.URLs)
        if ([projectURL.URL.absoluteString isEqualToString:url.absoluteString])
            return nil; // Initial duplicate filtering
    
    ProjectURL *newURL = [[ProjectURL alloc] initWithURL:url identifier:self.URLs.count];
    if (newURL) {
        
        // Register URL
        [[self URLs] insertObject:newURL atIndex:0];
        if ([self hasStarted])
            [self.addURLBuffer addObject:newURL]; // If the project is already running, add the URL to a waiting queue
        [newURL release];
        
        [self mirror];
        
        return [self.URLs firstObject];
        
    }
    
    return nil;
    
}

- (BOOL)cancelURL:(ProjectURL *)url {
    
    NSUInteger index = [self.URLs indexOfObject:url];
    
    if (index == NSNotFound)
        return false;
    
    NSString *address = [url URL].absoluteString;
    NSLog(@"%@", address);
    BOOL success = hts_cancel_file_push(self.engineOptions, [address UTF8String]);
    if (success)
        [url setCancelled:true];
    
    return success;
    
}

#pragma mark Reading & Writing

- (void)getWritingPermission:(void(^)(BOOL success))completion { // Called when a project starts
    
    NSError *error = nil;
    
    if (!self.exportDirectory) { // No permission to write to export directory, request a new one
        
        if (bookmarkData) { // Bookmark data has been used, check for access
            
            // Bookmarks supported since 10.7.3, condition checks for this
            // If method not available, export directory will remain nil and permission will be requested
            if ([[NSURL URLWithString:@""] respondsToSelector:@selector(startAccessingSecurityScopedResource)]) {
                
                self.exportDirectory = [NSURL URLByResolvingBookmarkData:bookmarkData
                                                                 options:(NSURLBookmarkResolutionWithSecurityScope)
                                                           relativeToURL:nil
                                                     bookmarkDataIsStale:false
                                                                   error:&error]; // Error can be ignored
                
                if (!error) {
                    [self.exportDirectory startAccessingSecurityScopedResource];
                    return completion(true);
                }
                
            }
            
        }
                
        [[self windowController] requestExportDirectory:^(BOOL success) {
            NSError *error = nil;
            if (success) // Add security-scoped bookmark
                bookmarkData = [[self.exportDirectory bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error] retain];
            completion(success && error == nil);
        }];
        
    }
    else
        completion(true);
    
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError {
    
    // Fetch & read incoming data
    NSData *projectData = [NSData dataWithContentsOfURL:url options:NULL error:outError];
    NSDictionary *properties = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
    
    // Read properties
    bookmarkData = [[properties objectForKey:@"BookmarkData"] retain];
    _completed = [[properties objectForKey:@"Completed"] boolValue];
    for (ProjectURL *url in [properties objectForKey:@"URLs"])
        [[self URLs] addObject:url];
    
    if (_files)
        [_files release];
    _files = [[properties objectForKey:@"Files"] retain];
    if (_notifications)
        [_notifications release];
    _notifications = [[properties objectForKey:@"Notifications"] retain];
    
    // Update window controller
    //  I do not understand this yet ; why do I need to use 'setDocument:' and 'showWindow:'? (otherwise document is nil and URLs do not show)
    [[self windowController] setDocument:self];
    [[self windowController] showWindow:self];
    [[self windowController] updateInterface];
    
    // Start mirroring
    [self mirror];
    
    return true;
    
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                // self.options, @"Options", // Keeps track of preset identifier
                                // self.statistics, @"Statistics", // Keeps track of all stats except number of files for each type
                                _files, @"Files",
                                _notifications, @"Notifications",
                                [NSNumber numberWithBool:_completed], @"Completed", // Avoid continuing a finished project
                                bookmarkData, @"BookmarkData",
                                self.URLs, @"URLs",
                                nil];
    
    return [NSKeyedArchiver archivedDataWithRootObject:properties];
    
}

#pragma mark Menu

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    
    if ([menuItem.title hasPrefix:@"Save"] && !self.fileURL)
        return false;
    
    return [super validateMenuItem:menuItem];
    
}

#pragma mark View

- (ProjectWindow *)window {
    
    return (ProjectWindow *)[[self windowController] window];
    
}

- (void)makeWindowControllers {
    
    [self addWindowController:[self windowController]];
    
}

- (ProjectWindowController *)windowController {
    
    if (!_windowController) { // Lazy loading
        
        if (IS_PRE_YOSEMITE)
            _windowController = [ProjectWindowControllerLion new];
        else
            _windowController = [ProjectWindowControllerYosemite new];
        
    }
    
    return _windowController;
    
}

- (void)setWindowController:(ProjectWindowController *)windowController {
    
    [self removeWindowController:_windowController];
    [self addWindowController:windowController];
    
    if (_windowController) {
        
        [_windowController close];
        [windowController restoreInterface:_windowController]; // Restore before release
        [_windowController release];
        
    }
    
    _windowController = [windowController retain];
    
}

#pragma mark Engine

- (void)mirror {
    
    // [self performSelector:@selector(cancel) withObject:nil afterDelay:10.0];
    
    if (![self isMirroring]) {
        
        _started = true;
        
        if (self.URLs.count < 1)
            return;
        
        [self getWritingPermission:^(BOOL success) { // Guarantee writing permission
            
            if (success) {
                
                _writingPermission = true;
                
                NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.exportDirectory.lastPathComponent,DOCUMENT_EXTENSION];
                self.fileURL = [self.exportDirectory URLByAppendingPathComponent:fileName];
                self.fileType  = DOCUMENT_TYPE;
                [self saveToURL:self.fileURL ofType:self.fileType forSaveOperation:NSSaveOperation completionHandler:^(NSError *error) {}];
                
                // Create cache directory
                NSError *error = nil;
                NSURL *cacheDirectory = [self.exportDirectory URLByAppendingPathComponent:@CACHE_DIRECTORY_NAME isDirectory:true];
                [[NSFileManager defaultManager] createDirectoryAtURL:[self.exportDirectory URLByAppendingPathComponent:@CACHE_DIRECTORY_NAME isDirectory:true]
                                         withIntermediateDirectories:true
                                                          attributes:nil
                                                               error:&error];
                if (!error && [PREFERENCES boolForKey:HideCache])
                    [cacheDirectory setResourceValue:[NSNumber numberWithBool:true] forKey:NSURLIsHiddenKey error:&error];
                
                // if (error)
                //     [self.delegate projectDidEnd:self error:@"Couldn't create cache directory"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self.window standardWindowButton:NSWindowDocumentIconButton] setImage:[NSImage imageNamed:@"documenticon"]]; // Bit crude, icon doesn't show otherwise (not sure why)
                    
#if CHECK_INTERNET_CONNECTION
                    if (hasInternetConnection())
#endif
                        [self performSelectorInBackground:@selector(mirrorInBackground) withObject:nil];
#if CHECK_INTERNET_CONNECTION
                    else
                        [self.delegate projectDidEnd:self error:@"No internet connection."];
#endif
                });
                
            }
            else {
                _writingPermission = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate projectDidEnd:self error:@"No writing permission."];
                });
            }
            
        }];
        
    }
    
}

- (void)mirrorInBackground {
    
    NSString *error = @"";
    
    if (!self.completed) {
        
        // Indicate that project started mirroring
        engineOptions->state._hts_in_mirror = 1;
        dispatch_async(dispatch_get_main_queue(), ^{[self.delegate projectDidStart:self];});
        
        // Make string with list of URLs in the project
        NSString *urlString = @"";
        for (int i=0 ; i<[[self URLs] count] ; i++) {
            ProjectURL *url = [[self URLs] objectAtIndex:0];
            [url fetchAttributes];
            dispatch_async(dispatch_get_main_queue(), ^{[[self windowController] updateURLAtIndex:i];});
            urlString = [urlString stringByAppendingString:[[[url URL] absoluteString] stringByAppendingString:@" "]];
        }
        for (NSString *filter in filters) // Add string with list of filters to previous string of urls
            urlString = [urlString stringByAppendingString:[filter stringByAppendingString:@" "]];
        if ([urlString length] > 0) // Cut last character
            urlString = [urlString substringWithRange:NSMakeRange(0, [urlString length] - 1)];
        
        // Initialize project
        hts_init();
        engineOptions->debug_head = 0;
        [self readExportDirectory]; // Put the export directory in the options structure
        [self setupCache]; // Check if there's a cache
        
        // Chain event functions (stored in linked list by httrack)
        CHAIN_FUNCTION(engineOptions, start, httrack_start, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, end, httrack_end, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, loop, httrack_loop, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, filesave, httrack_filesave, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, linkdetected, httrack_linkdetected, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, savename, httrack_savename, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, log, httrack_log, (__bridge void *)self);
        CHAIN_FUNCTION(engineOptions, baseupdated, httrack_baseupdated, (__bridge void *)self); // Custom callback function for intercepting an update of a base URL
        
        // Start mirror
        if (httpmirror((char *)[urlString UTF8String], engineOptions) == 0) // Typecast to make function work, url string isn't modified by function
            error = @"Error during operation (see log file), site has not been successfully mirrored";
        engineOptions->state._hts_in_mirror = 0;
        
        // End (uninitialize) mirror
        hts_uninit();
        
        // Beep, quit
        NSBeep();
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _completed = true;
        [self.delegate projectDidEnd:self error:error];
        [[self windowController] updateInterface]; // Completion
    });
    
}

- (void)pause {
    
    if ([self isMirroring])
        hts_setpause(engineOptions, 1);
    
}

- (void)resume {
    
    if ([self isMirroring]) {
        hts_setpause(engineOptions, 0);
        [self.delegate projectDidResume:self];
    }
    
}

- (void)cancel {
    
    if ([self isMirroring]) {
        
        // hts_request_stop(engineOptions, 1);
        hts_setpause(engineOptions, 0);
        [self setShouldCancel:true];
        
    }
    
}

- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo {
    
    BOOL shouldClose = true;
    
    // http://stackoverflow.com/questions/34032032/how-can-you-implement-the-nsdocument-method-canclosedocumentwithdelegateshould
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[delegate methodSignatureForSelector:shouldCloseSelector]];
    invocation.target = delegate;
    invocation.selector = shouldCloseSelector;
    [invocation setArgument:&self atIndex:2]; // Index 0 = target, Index 1 = selector
    [invocation setArgument:&shouldClose atIndex:3];
    [invocation setArgument:&contextInfo atIndex:4];
    [invocation invoke];
    
}

- (BOOL)isMirroring {
    
    return engineOptions != NULL && engineOptions->state._hts_in_mirror > 0;
    
}

- (BOOL)isPaused {
    
    return [self isMirroring] && engineOptions->state._hts_setpause && engineOptions->stats.stat_nsocket == 0;
    
}

#pragma mark Options

- (httrackp *)engineOptions {
    
    return engineOptions;
    
}

- (void)readExportDirectory {
    
    NSString *exportURL = [NSString stringWithFormat:@"%@/", [[self exportDirectory] path]];
    const char *exportPath = [exportURL UTF8String];
    
    StringClear(engineOptions->path_html);
    StringClear(engineOptions->path_log);
    StringCopyN(engineOptions->path_html, exportPath, [exportURL lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    if (StringLength(engineOptions->path_log) == 0)
        StringCopyS(engineOptions->path_log, engineOptions->path_html);
    
    StringCopyN(engineOptions->path_html_utf8, StringBuff(engineOptions->path_html), StringLength(engineOptions->path_html)); // Assume UTF-8
    
}

#pragma mark Sockets

- (void)cancelSocket:(ProjectSocket *)socket {
    
    // Sockets are cancelled in hts_mirror_wait_for_next_file() in htsparse.c
    // You can see there that url_sav is used to cancel the file.
    // The preprocessor flag called HTS_DEBUG_CLOSESOCK enables debugging of this part.
    hts_cancel_file_push(engineOptions, socket.file.UTF8String);
    
}

#pragma mark Filters

- (NSUInteger)nbOfFilters {
    
    return filters.count;
    
}

- (NSString *)filterAtIndex:(NSUInteger)index {
    
    if (index > [self nbOfFilters])
        return nil;
    
    return [filters objectAtIndex:index];
    
}

- (BOOL)hasFilter:(NSString *)filter {
    
    return [filters containsObject:filter];
    
}

- (void)addFilter:(NSString *)filter {
    
    if ([self hasStarted])
        return;
    
    if (![self hasFilter:filter])
        [filters addObject:filter];
    
}

- (void)addFilters:(NSArray *)newFilters {
    
    if ([self hasStarted])
        return;
    
    for (NSString *filter in newFilters) {
        
        if (filters.count >= MAX_FILTERS) {
            NSBeep();
            break;
        }
        
        if (![self hasFilter:filter])
            [filters addObject:filter];
        
    }
    
}

- (void)removeFilter:(NSString *)filter {
    
    if ([self hasStarted])
        return;
    
    [filters removeObject:filter];
    
}

- (void)removeFilters:(NSArray *)oldFilters {
    
    if ([self hasStarted])
        return;
    
    for (NSString *filter in oldFilters)
        [filters removeObject:filter];
    
}

- (void)removeAllFilters {
    
    [filters removeAllObjects];
    
}

- (void)removeFiltersAtIndexes:(NSIndexSet *)indices {
    
    [filters removeObjectsAtIndexes:indices];
    
}

#pragma mark Cache

- (void)setupCache { // Processes cache files, removing/renaming them based on info about them
    
    if (!fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.zip"))) {
        
        if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.zip")))
            rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions),StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.zip"),
                   fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.zip"));
        
    } else if ((!fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat")))
               || (!fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx")))) {
        
        if ((fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat")))
            && (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.ndx")))) {
            remove(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"));
            remove(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx"));
            //remove(fconcat(StringBuff(opt->path_log), CACHE_DIRECTORY_NAME"/new.lst"));
            rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat"),
                   fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"));
            rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.ndx"),
                   fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx"));
            //rename(fconcat(StringBuff(opt->path_log),CACHE_DIRECTORY_NAME"/old.lst"), fconcat(StringBuff(opt->path_log),CACHE_DIRECTORY_NAME"/new.lst"));
        }
        
    }
    
    if (engineOptions->cache) { // The cache is used. If there are 2 versions, the most advanced one (i.e. the one with the most files) is kept.
        
        if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), INPROGRESS_LOCK_NAME".lock"))) { // Problems...
            
            if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"))) {
                
                if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.zip"))
                    && fsize(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.zip")) < 32768
                    && fsize(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.zip")) > 65536) {
                    remove(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.zip"));
                    rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.zip"),
                           fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.zip"));
                }
                
            } else if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"))
                       && fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx"))) {
                
                if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat"))
                    && fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.ndx"))) {
                    
                    // If new < 32Ko and old > 65Ko, then they are switched (could be an error or a crash of an old mirror).
                    if (fsize(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat")) < 32768
                        && fsize(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat")) > 65536) {
                        
                        remove(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"));
                        remove(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx"));
                        rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat"),
                               fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.dat"));
                        rename(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.ndx"),
                               fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/new.ndx"));
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

- (BOOL)isInterrupted {
    
    if (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), INPROGRESS_LOCK_NAME".lock"))) {
        
        if ((fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.dat")))
            && (fexist(fconcat(OPT_GET_BUFF(engineOptions), OPT_GET_BUFF_SIZE(engineOptions), StringBuff(engineOptions->path_log), CACHE_DIRECTORY_NAME"/old.ndx")))) { // Old cache
            
            if (engineOptions->log != NULL)
                fprintf(engineOptions->log, "Warning!\nAn aborted mirror has been detected!\n The current temporary cache is required for any update operation and only contains data downloaded during the last aborted session.\n The former cache might contain more complete information; if you do not want to lose that information, you have to restore it and delete the current cache.\n This can easily be done here by erasing the "CACHE_DIRECTORY_NAME"/new.* files\n");
            
            return true;
            
        }
        
    }
    
    return false;
    
}

#pragma mark Key Value Coding

- (id)valueForKey:(NSString *)key {
        
    return [super valueForKey:key];
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    [super setValue:value forKeyPath:key];
    
}

#pragma mark Callbacks

int __cdecl httrack_start(t_hts_callbackarg *carg, httrackp *opt) { // Called when the engine starts
    
    Project *project = (__bridge Project *)carg->userdef;
    dispatch_async(dispatch_get_main_queue(), ^{[project.delegate projectDidStartEngine:project];});
    
    return 1;
    
}

int  httrack_end(t_hts_callbackarg *carg, httrackp *opt) { // Called when the engine ends
    
    // Project *project = (__bridge Project *)carg->userdef;
    // dispatch_async(dispatch_get_main_queue(), ^{[project.windowController updateStatus];}); // Updates on main queue
    
    Project *project = (__bridge Project *)carg->userdef;
    dispatch_async(dispatch_get_main_queue(), ^{[project.delegate projectDidEnd:project error:nil];});
    
    return 1;
    
}

int __cdecl httrack_loop(t_hts_callbackarg *carg, httrackp *opt, lien_back *back, int back_max, int back_index, int lien_n, int lien_tot, int stat_time, hts_stat_struct *stats) {
    
    Project *project = (__bridge Project *)carg->userdef;
    
    // Fill sockets array here
    int index = 0;
    if (back_index >= 0 && back_max > 0) {
        
        NSMutableArray *socketArray = [NSMutableArray arrayWithCapacity:MAX_SOCKETS];
        
        for (int k=0 ; k<2 ; k++) { // 0: Link being parsed 1: Other links
            
            // Go through links by increasing level of importance (first the ones with 0 < status < 99, then those with particular status codes, then remaining)
            //  This filter for j (priority level) is implemented in the switch-case block below ; first j = 0 (important), j = 1 (less important), j = 2 (least important)
            for (int j=0 ; (j<3) && (index<MAX_SOCKETS) ; j++) {
                
                int _i; // Index
                for (_i=k ; (_i<max(back_max*k,1)) && (index<MAX_SOCKETS) ; _i++) { // Go through all links
                    
                    int i = (back_index+_i) % back_max; // Calculate actual index - start with first = link being parsed
                    
                    if (back[i].status >= 0) { // Signifies active link
                        
                        ProjectSocketType socketType = ProjectSocketOther;
                        
                        switch (j) {
                            case 0: // Important links
                                if ((back[i].status>0) && (back[i].status<99))
                                    socketType = ProjectSocketReception;
                                break;
                            case 1: // Less important links
                                if (back[i].status == 99)
                                    socketType = ProjectSocketRequesting;
                                else if (back[i].status == STATUS_CONNECTING)
                                    socketType = ProjectSocketConnection;
                                else if (back[i].status == 101)
                                    socketType = ProjectSocketSearch;
                                else if (back[i].status == 1000) { // Ohh le beau ftp
                                    char proto[] = "ftp";
                                    if (back[i].url_adr[0]) {
                                        char *ep = strchr(back[i].url_adr, ':');
                                        char *eps = strchr(back[i].url_adr, '/');
                                        int count;
                                        if (ep != NULL && ep < eps && (count = (int) (ep - back[i].url_adr) ) < 4) {
                                            proto[0] = '\0';
                                            strncat(proto, back[i].url_adr, count);
                                        }
                                    }
                                }
                                else if (back[i].status == 102) // SSL handshake
                                    ;
                                else if (back[i].status == STATUS_ALIVE) // Waiting (keep-alive)
                                    ;
                                break;
                            default:
                                if (back[i].status == 0) { // Done
                                    
                                    if (back[i].r.statuscode == 200)
                                        socketType = ProjectSocketReady;
                                    else if ((back[i].r.statuscode>=100) && (back[i].r.statuscode<=599)) { // Tempo
                                        char tempo[256]; tempo[0]='\0';
                                        infostatuscode(tempo,back[i].r.statuscode);
                                    }
                                    else
                                        socketType = ProjectSocketError;
                                    
                                }
                                break;
                        }
                        
                        if (socketType != ProjectSocketOther) {
                            
                            static char s[HTS_URLMAXSIZE*2] = "";
                            s[0] = '\0';
                            if (strcmp(back[i].url_adr, "file://"))
                                strcatbuff(s, back[i].url_adr);
                            else
                                strcatbuff(s, "localhost");
                            if (back[i].url_fil[0] != '/')
                                strcatbuff(s, "/");
                            strcatbuff(s, back[i].url_fil);
                            char file[HTS_URLMAXSIZE];
                            *file = '\0';
                            char *a = strrchr(s, '/');
                            if (a) {
                                strncatbuff(file, a, 200);
                                *a='\0';
                            }
                            
                            // Calculate size and total size
                            LLint totsize, size;
                            if (back[i].r.totalsize>0) {  // Predefined size
                                totsize = back[i].r.totalsize;
                                size = back[i].r.size;
                            } else {  // No predefined size (totalsize == -1)
                                if (back[i].status==0) // Finished link (totalsize == size)
                                    totsize = size = back[i].r.size;
                                else {
                                    totsize = 8192;
                                    size = (back[i].r.size % 8192);
                                }
                            }
                            
                            ProjectSocket *socket = [ProjectSocket socketWithAddress:[NSString stringWithUTF8String:file]
                                                                                file:[NSString stringWithUTF8String:back[i].url_sav]
                                                                                size:size
                                                                           totalSize:totsize];
                            [socket setType:socketType];
                            [socketArray addObject:socket];
                            
                            index++;
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{ // On main queue
            [project.sockets remove:nil];
            [project.sockets setContent:socketArray];
        });
        
    }
    
    // Read statistics
    if (stats) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // if (stats->stat_files >= 0)
                // [project.statistics setValue:[NSNumber numberWithInt:stats->stat_files] forStatisticOfType:ProjectStatisticWritten];
            [project.statistics setValue:[NSNumber numberWithUnsignedInteger:project.files.count]
                      forStatisticOfType:ProjectStatisticWritten];
            [project.statistics setValue:[NSString stringForSpeed:stats->rate] forStatisticOfType:ProjectStatisticTransferRate];
            if (stats->stat_updated_files >= 0)
                [project.statistics setValue:[NSNumber numberWithInt:stats->stat_nsocket] forStatisticOfType:ProjectStatisticSockets];
            if (stats->stat_errors >= 0)
                [project.statistics setValue:[NSNumber numberWithInt:stats->stat_errors] forStatisticOfType:ProjectStatisticErrors];
            if (stats->stat_warnings >= 0)
                [project.statistics setValue:[NSNumber numberWithInt:stats->stat_warnings] forStatisticOfType:ProjectStatisticWarnings];
            if (stats->stat_infos >= 0)
                [project.statistics setValue:[NSNumber numberWithInt:stats->stat_infos] forStatisticOfType:ProjectStatisticInfoMessages];
            if (stats->nb >= 0)
                [project.statistics setValue:[NSString stringForByteCount:stats->nb] forStatisticOfType:ProjectStatisticBytes];
            if (stats->HTS_TOTAL_RECV >= 0)
                [project.statistics setValue:[NSString stringForByteCount:stats->HTS_TOTAL_RECV] forStatisticOfType:ProjectStatisticTotalReceived];
            if (lien_tot >= 0)
                [project.statistics setValue:[NSNumber numberWithLongLong:lien_tot] forStatisticOfType:ProjectStatisticLinks];
            
        });
        
    }
    
    // Check URL waiting queue and add any links that are in there (one by one)
    int retries = [project addRetries];
    
    if (hts_addurl(opt, NULL)) { // URL is in httrack queue
        
        if (retries < 100)
            [project setAddRetries:retries + 1];
        else
            if (!hts_resetaddurl(opt))
                ; // Error resetting
        
    }
    else if (!project.addURLBuffer.isEmpty) {
        
        char *url_addition[2];
        
        ProjectURL *url = (ProjectURL *)[project.addURLBuffer removeFirst];
        [url fetchAttributes];
        url_addition[0] = (char *)[[url.URL absoluteString] UTF8String];
        url_addition[1] = NULL;
        opt->state.hts_addurl_identifier = [url identifier];
        if (!hts_addurl(opt, url_addition))
            [url setFailed:true];
        [project setAddRetries:0];
        
    }
    
    // Check for pausing
    static BOOL paused = false; {
        if ([project isPaused]) {
            if (!paused)
                dispatch_async(dispatch_get_main_queue(), ^{[project.delegate projectDidPause:project];});
            paused = true;
        }
        else
            paused = false;
    }
    
    return !project.shouldCancel;
    
}

void __cdecl httrack_filesave(t_hts_callbackarg * carg, httrackp * opt, const char *file, const char *adr, const char *save, LLint size) {
    
    Project *project = (__bridge Project *)carg->userdef;
    
    // Get file properties
    NSString *address = [NSString stringWithUTF8String:adr], *path = [NSString stringWithUTF8String:save];
    address = [address stringByAppendingString:[NSString stringWithUTF8String:file]];
    if (size < 0) // Indeterminate files size, calculate now
        size = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    
    // Add project file to list
    ProjectFile *projectFile = [[[ProjectFile alloc] initWithAddress:address file:path size:size] autorelease];
    dispatch_async(dispatch_get_main_queue(), ^{
        [project.files addObject:projectFile];
        [project.statistics registerFile:projectFile];
        // [project.delegate project:project savedFile:projectFile];
    });
    
}

int __cdecl httrack_savename(t_hts_callbackarg *carg, httrackp* opt, const char *adr, const char *file, const char *referer_adr, const char *referer, char *save) {
    
    return 1;
    
}

int __cdecl httrack_linkdetected(t_hts_callbackarg *carg, httrackp *opt, char *link) {
    
    // Called when a link was detected
    return 1;
    
}

void __cdecl httrack_baseupdated(t_hts_callbackarg *carg, httrackp *opt, uint8_t base_id, LLint bytes_received, LLint bytes_written, int links_written) {
    
    Project *project = (__bridge Project *)carg->userdef;
    unsigned long index = project.URLs.count - 1 - base_id; // URLs are added at the front of the array, so the base_id is backwards
    
    ProjectURL *base_url = [[project URLs] objectAtIndex:index];
    base_url.bytesScanned += bytes_received;
    base_url.bytesWritten += bytes_written;
    base_url.linksDetected += links_written;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!project.shouldCancel)
            [[project windowController] updateURLAtIndex:index];
    });
    
}

void __cdecl httrack_log(t_hts_callbackarg *carg, httrackp *opt, int type, const char *format, va_list args) {
    
    Project *project = (__bridge Project *)carg->userdef;
    
    ProjectNotificationType notificationType;
    if (type == LOG_PANIC || type == LOG_ERROR)
        notificationType = ProjectNotificationError;
    else if (type == LOG_WARNING)
        notificationType = ProjectNotificationWarning;
    else if (type == LOG_NOTICE || type == LOG_INFO)
        notificationType = ProjectNotificationUpdate;
    else
        return; // Ignore debugging etc.
    
    NSString *formatString = [[[NSString alloc] initWithFormat:[NSString stringWithUTF8String:format] arguments:args] autorelease];
    ProjectNotification *notification = [ProjectNotification notificationOfType:notificationType content:formatString andDate:[NSDate date]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [project.notifications addObject:notification];
    });
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [self setDelegate:nil];
    
    if (_windowController) {
        [_windowController close];
        [_windowController release];
    }
    
    [self setExportDirectory:nil];
    
    [_addURLBuffer release];
    [_cancelURLBuffer release];
    
    [_options release];
    [_URLs release];
    [filters release];
    
    [_files release];
    [_sockets release];
    [_notifications release];
    
    [_statistics release];
    
    [bookmarkData release];
    
    if (engineOptions != NULL) {
        
        hts_free_opt(engineOptions);
        engineOptions = NULL;
        
    }
    
    hts_uninit();
    
    [super dealloc];
    
}

@end