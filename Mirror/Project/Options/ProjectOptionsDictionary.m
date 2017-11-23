//
//  ProjectOptionsDictionary.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 18/11/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "NSString+Additions.h"
#import "PreferencesConstants.h"
#import "Project.h"
#import "ProjectOptionsDictionary.h"
#import "ProjectStatsDictionary.h"

NSString *const ProjectOptionsDictionaryWillChange = @"ProjectOptionsDictionaryWillChange";
NSString *const ProjectOptionsDictionaryDidChange = @"ProjectOptionsDictionaryDidChange";
NSString *const ProjectOptionsDictionaryDidReset = @"ProjectOptionsDictionaryDidReset";
NSString *const ProjectOptionsPresetWasRemoved = @"ProjectOptionsPresetWasRemoved";
NSString *const CustomPresetName = @"Custom";
NSString *const DefaultPresetName = @"Defaults";
NSString *const PresetsPreferencesKey = @"Presets";
NSString *const DefaultPresetPreferencesKey = @"DefaultPreset";

#pragma mark Project Options Dictionary

@interface ProjectOptionsDictionary ()
@property (nonatomic, copy) NSString *presetIdentifier;
@end

@implementation ProjectOptionsDictionary

@synthesize project = _project, presetIdentifier = _presetIdentifier;

+ (void)initialize {
    
    if (self == [ProjectOptionsDictionary self]) { // Prevent this from being run twice
        
        [PREFERENCES registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionary], PresetsPreferencesKey, nil]]; // Register defaults
        
    }
    
}

#pragma mark Class Methods

+ (NSArray *)allOptionKeys { // All the option keys
    
    static NSArray *allOptionKeys = nil;
    
    if (!allOptionKeys)
        allOptionKeys = [[[ProjectOptionsDictionary allOptions] allKeys] retain] ;
    
    return allOptionKeys;
    
}

+ (NSDictionary *)generalOptionKeys { // All the general option keys, in categories (<Category Name> : <Array of Keys>)
    
    static NSDictionary *generalOptionKeys = nil;
    
    if (!generalOptionKeys) {
        
        NSMutableDictionary *mutableGeneralOptionKeys = [NSMutableDictionary new];
        NSArray *definedOptionsArrays = [[NSMutableArray alloc] initWithObjects:
                                         @"Build", [ProjectOptionsDictionary buildOptions],
                                         @"Cache", [ProjectOptionsDictionary cacheOptions],
                                         @"Crawler", [ProjectOptionsDictionary crawlerOptions],
                                         @"Java", [ProjectOptionsDictionary javaOptions],
                                         @"Dangerous", [ProjectOptionsDictionary dangerousOptions],
                                         nil];
        
        for (int i=0 ; i<[definedOptionsArrays count] ; i+=2) {
            
            NSMutableArray *optionsList = [NSMutableArray new];
            NSString *categoryName = [definedOptionsArrays objectAtIndex:i];
            NSArray *optionsArray = [definedOptionsArrays objectAtIndex:i+1];
            
            for (int j=0 ; j<[optionsArray count] ; j+=4)
                [optionsList addObject:[optionsArray objectAtIndex:j]]; // Only add the keys
            
            [mutableGeneralOptionKeys setObject:optionsList forKey:categoryName];
            [optionsList release];
            
        }
        
        generalOptionKeys = [[NSDictionary alloc] initWithDictionary:mutableGeneralOptionKeys];
        
    }
    
    return generalOptionKeys;
    
}

+ (NSString *)descriptionForGeneralOptionKey:(NSString *)key {
    
    static NSDictionary *generalOptionDescriptions = nil;
    
    if (!generalOptionDescriptions) {
        
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
        NSDictionary *generalOptions = [ProjectOptionsDictionary generalOptionKeys];
        
        for (NSString *category in [generalOptions allKeys]) {
            NSArray *optionKeys = (NSMutableArray *)[generalOptions valueForKey:category];
            for (NSString *optionKey in optionKeys)
                [mutableDictionary setValue:[NSString formattedStringFromCamelCasing:optionKey] forKey:optionKey];
        }
        
        generalOptionDescriptions = [[NSDictionary alloc] initWithDictionary:mutableDictionary];
        [mutableDictionary release];
        
    }
    
    return [generalOptionDescriptions objectForKey:key];
    
}

+ (NSArray *)savedPresetNames {
    
    return [[PREFERENCES dictionaryForKey:PresetsPreferencesKey] allKeys];
    
}

+ (NSString *)defaultPresetName {
    
    NSString *preferencesDefault = [PREFERENCES stringForKey:DefaultPresetPreferencesKey];
    return (preferencesDefault ? preferencesDefault : DefaultPresetName);
    
}

+ (id)defaultValueForOptionKey:(NSString *)key {
    
    NSArray *option = [[ProjectOptionsDictionary allOptions] objectForKey:key];
    
    if (option)
        return [option objectAtIndex:0];
    
    return nil; // Returns nil if key is invalid
    
}

+ (void(^)(httrackp *, id))mutatingBlockForOptionKey:(NSString *)key {
    
    NSArray *option = [[ProjectOptionsDictionary allOptions] objectForKey:key];
    
    if (option)
        return [option objectAtIndex:1];
    
    return nil; // Returns nil if key is invalid
    
}

+ (BOOL)optionCanBeAltered:(NSString *)key {
    
    NSArray *option = [[ProjectOptionsDictionary allOptions] objectForKey:key];
    
    if (option)
        return [[option objectAtIndex:2] boolValue];
    
    return false; // Returns false if key is invalid
    
}

#pragma mark Presets

+ (void)addPresetWithName:(NSString *)presetName values:(NSDictionary *)values {
    
    NSMutableDictionary *currentPresets = [[PREFERENCES dictionaryForKey:PresetsPreferencesKey] mutableCopy];
    [currentPresets setObject:values forKey:presetName];
    [PREFERENCES setObject:currentPresets forKey:PresetsPreferencesKey];
    [currentPresets release];
    
}

+ (void)removePresetWithName:(NSString *)presetName {
    
    [ProjectOptionsDictionary removePresetsWithNames:[NSArray arrayWithObject:presetName]];
    
}

+ (void)removePresetsWithNames:(NSArray *)presetNames {
    
    NSMutableDictionary *currentPresets = [[PREFERENCES dictionaryForKey:PresetsPreferencesKey] mutableCopy];
    for (NSString *presetName in presetNames) {
        [currentPresets removeObjectForKey:presetName];
        [NOTIFICATION_CENTER postNotificationName:ProjectOptionsPresetWasRemoved
                                           object:self
                                         userInfo:[NSDictionary dictionaryWithObject:presetName
                                                                              forKey:@"presetName"]];
    }
    
    // [currentPresets removeObjectsForKeys:presetNames];
    
    [PREFERENCES setObject:currentPresets forKey:PresetsPreferencesKey];
    [currentPresets release];
    
}

+ (NSDictionary *)optionsForPresetWithName:(NSString *)presetName {
    
    return [[PREFERENCES dictionaryForKey:PresetsPreferencesKey] objectForKey:presetName]; // Returns nil for custom/defaults/nonexistent preset
    
}

#pragma mark Private Class Methods

+ (NSDictionary *)allOptions { // Has entry for each option key (<Key> : <Default Value - Mutating Block - Alterable Flag>)
    
    static NSMutableDictionary *allOptions = nil; // This can be mutable because it is only used privately
    
    if (!allOptions) {
        
        allOptions = [NSMutableDictionary new];
        NSMutableArray *definedOptionsArrays = [[NSMutableArray alloc] initWithObjects:
                                                [ProjectOptionsDictionary buildOptions],
                                                [ProjectOptionsDictionary cacheOptions],
                                                [ProjectOptionsDictionary crawlerOptions],
                                                [ProjectOptionsDictionary javaOptions],
                                                [ProjectOptionsDictionary dangerousOptions],
                                                [ProjectOptionsDictionary structureOptions],
                                                [ProjectOptionsDictionary designOptions],
                                                [ProjectOptionsDictionary identityOptions],
                                                [ProjectOptionsDictionary engineOptions],
                                                [ProjectOptionsDictionary miscOptions],
                                                nil];
        
        for (NSArray *optionsArray in definedOptionsArrays)
            for (int i=0 ; i<[optionsArray count] ; i+=4)
                [allOptions setObject:[NSArray arrayWithObjects:
                                       [optionsArray objectAtIndex:i+1],
                                       [optionsArray objectAtIndex:i+2],
                                       [optionsArray objectAtIndex:i+3],
                                       nil] // Option details
                               forKey:[optionsArray objectAtIndex:i]]; // Option keys
        
        [definedOptionsArrays release];
        
    }
    
    return allOptions;
    
}

+ (NSArray *)buildOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"ConvertLinksToUTF8", @YES, ^(httrackp *options, id value) {options->convert_utf8 = [value intValue];}, @NO,
            @"ReplaceExternalLinksWithErrorPages", @NO, ^(httrackp *options, id value) {options->external = [value intValue];}, @NO,
            @"GenerateMIME-HTML", @NO, ^(httrackp *options, id value) {options->mimehtml = [value intValue];}, @NO,
            @"HidePasswords", @NO, ^(httrackp *options, id value) {options->passprivacy = [value intValue];}, @NO,
            @"HideQueryStrings", @NO, ^(httrackp *options, id value) {options->includequery = ![value intValue];}, @NO,
            @"GenerateErrorPages", @YES, ^(httrackp *options, id value) {options->errpage = [value intValue];}, @NO,
            @"PurgeOldFiles", @YES, ^(httrackp *options, id value) {options->delete_old = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)cacheOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"UseCache", @YES, ^(httrackp *options, id value) {options->cache = [value intValue];}, @NO,
            @"CacheEverything", @NO, ^(httrackp *options, id value) {options->all_in_cache = [value intValue];}, @NO,
            @"IgnoreLocallyErasedFiles", @NO, ^(httrackp *options, id value) {options->norecatch = [value intValue];}, @NO,
            @"MakeIndex", @YES, ^(httrackp *options, id value) {options->makeindex = [value intValue];}, @NO,
            // @"CreateLogs", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)crawlerOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            // @"TestAllLinks", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"ForceHTTP1-0", @NO, ^(httrackp *options, id value) {options->http10 = [value intValue];}, @NO,
            // @"PrioritiseHTML", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"EnableUrlHacks", @YES, ^(httrackp *options, id value) {options->urlhack = [value intValue];}, @NO,
            @"EnableUpdateHacks", @NO, ^(httrackp *options, id value) {options->sizehack = [value intValue];}, @NO,
            @"AcceptCookies", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"TolerantRequests", @NO, ^(httrackp *options, id value) {options->tolerant = [value intValue];}, @NO,
            @"ParseAll", @YES, ^(httrackp *options, id value) {options->parseall = [value intValue];}, @YES,
            // @"GetNearbyFiles", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            nil];
    
}

+ (NSArray *)javaOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"ParseJava", @YES, ^(httrackp *options, id value) {options->parsejava = ([value intValue] ? HTSPARSE_DEFAULT : HTSPARSE_NONE);}, @NO,
            // @"ParseJavaClasses", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            // @"ParseJavaScript", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            // @"ParseJavaNon-Aggressively", @NO, ^(httrackp *options, id value) {if ([value intValue]) options->parsejava = HTSPARSE_NO_AGGRESSIVE;}, @NO,
            nil];
    
}

+ (NSArray *)dangerousOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"BypassSecurityLimits", @NO, ^(httrackp *options, id value) {options->bypass_limits = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)structureOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    static int savenameMapping[] = {0,1,2,3,4,5,99,100,101,102,103,104,105,199,1001,1002,1003,1004,1005,1099};
    
    return [NSArray arrayWithObjects:
            @"LocalStructure", [NSNumber numberWithDouble:0], ^(httrackp *options, id value) {options->savename_type = savenameMapping[[value intValue]];}, @NO,
            @"FileNames", [NSNumber numberWithDouble:0], ^(httrackp *options, id value) {options->savename_83 = [value intValue];}, @NO,
            @"Links", [NSNumber numberWithDouble:2], ^(httrackp *options, id value) {options->urlmode = [value intValue];if (options->urlmode > 0) options->urlmode++;}, @NO,
            nil];
    
}

+ (NSArray *)designOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    NSDictionary *defaultCSSAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSColor colorWithCalibratedWhite:0.1 alpha:1.0], NSForegroundColorAttributeName, [NSFont systemFontOfSize:11.0], NSFontAttributeName, nil];
    NSString *defaultCSS = @"body {background-color: white;}\n.footer {text-align: center;font-size:11px;}";
    
    NSArray *designOptions = [NSArray arrayWithObjects:
            @"IndexHTMLTitle", @"Index", ^(httrackp *options, id value) {
                if (options->template_htmltitle)
                    free(options->template_htmltitle);
                NSString *string = (NSString *)value;
                const char *dest = string.UTF8String;
                if (dest == NULL) dest = "";
                options->template_htmltitle = malloc(strlen(dest) + 1);
                strcpybuff(options->template_htmltitle, dest);}, @NO,
            @"IndexTitle", @"Index", ^(httrackp *options, id value) {
                if (options->template_title)
                    free(options->template_title);
                NSString *string = (NSString *)value;
                const char *dest = string.UTF8String;
                if (dest == NULL) dest = "";
                options->template_title = malloc(strlen(dest) + 1);
                strcpybuff(options->template_title, dest);}, @NO,
            @"IndexCSS", defaultCSS, ^(httrackp *options, id value) {
                if (options->template_css)
                    free(options->template_css);
                NSString *string = value;
                const char *dest = string.UTF8String;
                if (dest == NULL) dest = "";
                options->template_css = malloc(strlen(dest) + 1);
                strcpybuff(options->template_css, dest);}, @NO,
            @"PieTheme", [NSNumber numberWithInt:0], ^(httrackp *options, id value) {}, @YES,
            nil];
    
    [defaultCSS release];
    [defaultCSSAttributes release];
    return designOptions;
    
}

+ (NSArray *)identityOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            // Identity
            @"Language", @"en, *", ^(httrackp *options, id value) {
                StringCopy(options->lang_iso, [value UTF8String]);
            }, @NO,
            @"FooterString", @"<!-- Mirrored from %s%s by Mirror, %s -->", ^(httrackp *options, id value) {
                StringCopy(options->footer, [value UTF8String]);
            }, @NO,
            @"UserAgent", @"Mozilla/4.5 (compatible; Mirror 1.0; Windows 98)", ^(httrackp *options, id value) {
                StringCopy(options->user_agent, [value UTF8String]);
            }, @YES,
            @"FromEmailAddress", @"", ^(httrackp *options, id value) {
                StringCopy(options->from, [value UTF8String]);
            }, @NO,
            @"DefaultRefererURL", @"", ^(httrackp *options, id value) {
                StringCopy(options->referer, [value UTF8String]);
            }, @NO,
            @"Headers", @"", ^(httrackp *options, id value) {
                StringCopy(options->headers, [value UTF8String]);
            }, @NO,
            // Proxy
            @"UseProxy", @NO, ^(httrackp *options, id value) {
                options->proxy.active = [value intValue];
            }, @NO,
            @"ProxyAddress", @"", ^(httrackp *options, id value) {
                StringCopy(options->proxy.bindhost, [value UTF8String]);
            }, @NO,
            @"ProxyPort", @"8080", ^(httrackp *options, id value) {
                int port = [value intValue];
                options->proxy.port = (port ==0 ? 8080 : port);
            }, @NO,
            @"ProxyUsername", @"", ^(httrackp *options, id value) {
                StringCopy(options->proxy.name, [value UTF8String]);
            }, @NO,
            @"ProxyFTP", @YES, ^(httrackp *options, id value) {
                options->ftp_proxy = [value intValue];
            }, @NO,
            nil];
    
}

+ (NSArray *)engineOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            // Network
            @"Connections", [NSNumber numberWithInt:4], ^(httrackp *options, id value) {options->maxsoc = [value intValue];}, @YES,
            @"PersistentConnections", @YES, ^(httrackp *options, id value) {options->nokeepalive = ![value boolValue];}, @NO,
            @"Timeout", @"120", ^(httrackp *options, id value) {options->timeout = [value intValue];}, @YES,
            @"AbandonHosts", [NSNumber numberWithInt:0], ^(httrackp *options, id value) {options->hostcontrol = [value intValue];}, @YES,
            @"Retries", [NSNumber numberWithInt:2], ^(httrackp *options, id value) {options->retry = [value intValue];}, @YES,
            @"MinTransferRate", @"0", ^(httrackp *options, id value) {options->rateout = [value intValue];}, @YES,
            // Limits
            @"MirroringDepth", @"9999", ^(httrackp *options, id value) {options->depth = [value intValue];}, @NO,
            @"ExternalDepth", @"0", ^(httrackp *options, id value) {options->extdepth = [value intValue];}, @NO,
            // @"UseMaximumHTMLSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumHTMLSize", @"-1", ^(httrackp *options, id value) {options->maxfile_html = [value intValue];}, @YES,
            // @"UseMaximumNonHTMLSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumNonHTMLSize", @"-1", ^(httrackp *options, id value) {options->maxfile_nonhtml = [value intValue];}, @YES,
            // @"UseMaximumOverallSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumOverallSize", @"-1", ^(httrackp *options, id value) {options->maxsite = [value intValue];}, @YES,
            // @"UsePauseMilestone", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"PauseMilestoneBytes", @"-1", ^(httrackp *options, id value) {options->fragment = [value intValue];}, @NO,
            // @"UseMaximumTime", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumTime", @"-1", ^(httrackp *options, id value) {options->maxtime = [value intValue];}, @YES,
            @"MaximumTransferRate", @"25000", ^(httrackp *options, id value) {options->maxrate = [value intValue];}, @YES,
            @"MaximumConnectionsSecond", @"4", ^(httrackp *options, id value) {options->maxsoc = [value intValue];}, @YES,
            @"MaximumLinks", @"100000", ^(httrackp *options, id value) {options->maxlink = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)miscOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"FollowRobots", [NSNumber numberWithInt:2], ^(httrackp *options, id value) {options->robots = [value intValue];}, @NO,
            @"CheckType", [NSNumber numberWithInt:1], ^(httrackp *options, id value) {options->check_type = [value intValue];}, @NO,
            nil];
    
}

#pragma mark Constructors

- (id)init {
    
    return [self initWithProject:nil];
    
}

- (id)initWithProject:(Project *)project {
    
    return [self initWithProject:project usingValues:nil];
    
}

- (id)initWithProject:(Project *)project usingPresetWithName:(NSString *)presetName {
    
    if (self = [self initWithProject:project usingValues:[ProjectOptionsDictionary optionsForPresetWithName:presetName]]) {
        self.presetIdentifier = presetName;
    }
    
    return self;
    
}

- (id)initWithProject:(Project *)project usingDictionary:(ProjectOptionsDictionary *)dictionary {
    
    if (self = [self initWithProject:project usingValues:nil]) {
        
        if (dictionary && [dictionary isCustom]) {
            
            for (NSString *optionKey in [dictionary customisedOptionKeys])
                [optionsDictionary setObject:[dictionary valueForKey:optionKey] forKey:optionKey];
            
            NSString *dictionaryPresetName = [dictionary presetName];
            if ([dictionaryPresetName isEqualToString:CustomPresetName])
                self.presetIdentifier = CustomPresetName;
            else
                self.presetIdentifier = [NSString stringWithFormat:@"%@ (%@)", CustomPresetName, dictionaryPresetName];
            
        }
        
    }
    
    return self;
    
}

- (id)initWithProject:(Project *)project usingValues:(NSDictionary *)values {
    
    if (self = [super init]) {
        
        optionsDictionary = (values ? [values mutableCopy] : [NSMutableDictionary new]);
        
        _project = project;
        
        if (project) { // This block makes dictionary (temporarily) 'custom'
            NSArray *designOptions = [ProjectOptionsDictionary designOptions];
            NSString *optionKey = nil;
            for (int i=0 ; i<[designOptions count] ; i+=4) {
                optionKey = [designOptions objectAtIndex:i];
                [self setValue:[self valueForKey:optionKey] forKey:optionKey];
            }
        }
        
        self.presetIdentifier = (values ? CustomPresetName : DefaultPresetName);
        
        [NOTIFICATION_CENTER addObserver:self
                                selector:@selector(presetWasRemoved:)
                                    name:ProjectOptionsPresetWasRemoved
                                  object:nil];
        
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSDictionary *codedDictionary = [[aDecoder decodeObjectForKey:@"Options"] mutableCopy];
    
    if (codedDictionary)
        if (self = [self initWithProject:nil usingValues:codedDictionary])
            self.presetIdentifier = [aDecoder decodeObjectForKey:@"Preset"];
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:optionsDictionary forKey:@"Options"];
    [aCoder encodeObject:_presetIdentifier forKey:@"Preset"];
    
}

- (void)adoptDictionary:(ProjectOptionsDictionary *)dictionary {
    
    if (dictionary) {
        
        for (NSString *optionKey in [dictionary customisedOptionKeys])
            [self setValue:[dictionary valueForKey:optionKey] forKey:optionKey];
        
        NSString *dictionaryPresetName = [dictionary presetName];
        if (!dictionaryPresetName
            || dictionaryPresetName.length < 1
            || [dictionaryPresetName isEqualToString:CustomPresetName])
            self.presetIdentifier = CustomPresetName;
        else if ([[ProjectOptionsDictionary savedPresetNames] containsObject:dictionaryPresetName])
            self.presetIdentifier = dictionaryPresetName;
        else
            [[NSString stringWithFormat:@"%@ (%@)", CustomPresetName, dictionaryPresetName] copy];
        
    }
    
}

- (void)presetWasRemoved:(NSNotification *)notification {

    NSString *presetName = (NSString *)[[notification userInfo] objectForKey:@"presetName"];

    if ([_presetIdentifier isEqualToString:presetName])
        self.presetIdentifier = CustomPresetName;
        
}

- (BOOL)adoptPresetWithName:(NSString *)presetName {
    
    BOOL ok = true, isDefaults = [presetName isEqualToString:DefaultPresetName];
    NSString *key = nil;
    
    for (key in [ProjectOptionsDictionary allOptionKeys])
        [self willChangeValueForKey:key];
    
    [optionsDictionary removeAllObjects]; // Revert to defaults
    self.presetIdentifier = DefaultPresetName;
    
    NSDictionary *newOptions = [ProjectOptionsDictionary optionsForPresetWithName:presetName];
    if (newOptions) { // Only if options are set
        for (NSString *optionKey in [newOptions allKeys])
            [self setValue:[newOptions valueForKey:optionKey] forKey:optionKey];
        self.presetIdentifier = presetName;
    }
    else if (!isDefaults)
        ok = false;
    
    if (isDefaults)
        [NOTIFICATION_CENTER postNotificationName:ProjectOptionsDictionaryDidReset object:self];
    
    for (key in [ProjectOptionsDictionary allOptionKeys])
        [self didChangeValueForKey:key];
    
    return ok;
    
}

#pragma mark KVO

- (id)valueForKey:(NSString *)key { // This will return nil for invalid keys
    
    id setValue = [optionsDictionary valueForKey:key];
    return (setValue ? setValue : [ProjectOptionsDictionary defaultValueForOptionKey:key]);
    
}

- (void)setValue:(id)value forKey:(NSString *)key { // Value is never set if the given key is not valid
    
    if ([ProjectOptionsDictionary defaultValueForOptionKey:key]) { // Make sure key has default value (which means it is valid)
                
        [NOTIFICATION_CENTER postNotificationName:ProjectOptionsDictionaryWillChange object:self];
        
        [optionsDictionary setValue:value forKey:key]; // Alter the dictionary itself
        
        if ([key isEqualToString:@"PieTheme"])
            [self.project.statistics setPieGraphTheme:[value unsignedIntValue]];
        else {
            void(^mutatingBlock)(httrackp *, id) = [ProjectOptionsDictionary mutatingBlockForOptionKey:key];
            mutatingBlock(self.project.engineOptions, value); // Alter the project engine's options structure
        }
        
        if (![_presetIdentifier isEqualToString:CustomPresetName])
            self.presetIdentifier = CustomPresetName;
        
        [NOTIFICATION_CENTER postNotificationName:ProjectOptionsDictionaryDidChange object:self];
        
    }
    
}

#pragma mark Preset Saving

- (BOOL)isValidPresetName:(NSString *)presetName error:(NSString **)error {
    
    if ([presetName isEqualToString:DefaultPresetName]
        || [presetName hasPrefix:CustomPresetName])
        *error = @"This name is reserved!";
    else if (![presetName isAlphaNumeric])
        *error = @"Alphanumerical characters only.";
    else if ([presetName length] < 1)
        *error = @"Please enter a name.";
    else {
        for (NSString *takenName in [[PREFERENCES dictionaryForKey:PresetsPreferencesKey] allKeys])
            if ([presetName isEqualToString:takenName])
                *error = @"This name is already taken.";
    }
    
    return (*error == nil);
    
}

- (BOOL)saveAsPresetWithName:(NSString *)presetName error:(NSString **)error {
    
    if (!([_presetIdentifier isEqualTo:CustomPresetName]
          && [PREFERENCES dictionaryForKey:PresetsPreferencesKey].allKeys.count < MAX_PRESETS)) {
        *error = @"These options cannot be saved!";
        return false;
    }
    
    if (![self isValidPresetName:presetName error:error])
        return false;
    
    [ProjectOptionsDictionary addPresetWithName:presetName values:optionsDictionary];
    
    self.presetIdentifier = presetName;
    
    return true;
    
}

- (NSString *)presetName {
    
    return _presetIdentifier;
    
}

- (BOOL)isCustom {
    
    return [_presetIdentifier isEqualToString:CustomPresetName];
    
}

- (NSArray *)customisedOptionKeys {
    
    return [optionsDictionary allKeys];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [NOTIFICATION_CENTER removeObserver:self
                                   name:ProjectOptionsDictionaryWillChange
                                 object:_project.options];
    
    _project = nil;
    
    [optionsDictionary release];
    self.presetIdentifier = nil;
    
    [super dealloc];
    
}

@end
