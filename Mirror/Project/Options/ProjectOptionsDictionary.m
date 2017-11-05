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
NSString *const CustomPresetName = @"Custom";
NSString *const DefaultPresetName = @"Defaults";
NSString *const PresetsPreferencesKey = @"Presets";
NSString *const DefaultPresetPreferencesKey = @"DefaultPreset";

#pragma mark Project Options Dictionary

@implementation ProjectOptionsDictionary

@synthesize project = _project;

+ (void)initialize {
    
    if (self == [ProjectOptionsDictionary self]) { // Prevent this from being run twice
        
        [PREFERENCES registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionary], PresetsPreferencesKey, nil]]; // Register defaults
        
    }
    
}

#pragma mark Class Methods

+ (NSArray *)allOptionKeys { // All the option keys
    
    static NSArray *allOptionKeys = nil;
    
    if (!allOptionKeys)
        allOptionKeys = [[ProjectOptionsDictionary allOptions] allKeys];
    
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
    
    for (NSString *presetName in presetNames)
        [currentPresets setObject:nil forKey:presetName];
    
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
            @"UTF8Links", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ReplaceExternal", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"GenerateMHT", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"HidePasswords", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"HideQueryStrings", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"GenerateErrorHTML", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"PurgeOldFiles", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)cacheOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"UseCache", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"CacheAll", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"LocallyErased", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"MakeIndex", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"CreateLogs", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)crawlerOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"TestAllLinks", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"ForceHTTP10", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"PrioritiseHTML", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"EnableUrlHacks", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"EnableUpdateHacks", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"AcceptCookies", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"TolerantRequests", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ParseAll", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"GetNearbyFiles", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            nil];
    
}

+ (NSArray *)javaOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"ParseJavaDefault", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ParseJavaClass", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ParseJavaJS", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ParseJavaAggressive", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)dangerousOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"BypassSecurity", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)structureOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"LocalStructure", [NSNumber numberWithDouble:0], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"FileNames", [NSNumber numberWithDouble:0], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"Links", [NSNumber numberWithDouble:0], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)designOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"IndexHTMLTitle", @"Index", ^(httrackp *options, id value) {
                if (options->template_htmltitle)
                    free(options->template_htmltitle);
                NSString *string = (NSString *)value;
                const char *dest = string.UTF8String;
                options->template_htmltitle = malloc(strlen(dest) + 1);
                strcpybuff(options->template_htmltitle, dest);}, @NO,
            @"IndexTitle", @"Index", ^(httrackp *options, id value) {
                if (options->template_title)
                    free(options->template_title);
                NSString *string = (NSString *)value;
                const char *dest = string.UTF8String;
                options->template_title = malloc(strlen(dest) + 1);
                strcpybuff(options->template_title, dest);}, @NO,
            @"IndexCSS", @"body {background-color: gray;}\n.footer {text-align: center;}", ^(httrackp *options, id value) {
                if (options->template_css)
                    free(options->template_css);
                NSString *string = [value string];
                const char *dest = string.UTF8String;
                options->template_css = malloc(strlen(dest) + 1);
                strcpybuff(options->template_css, dest);}, @NO,
            @"PieTheme", [NSNumber numberWithInt:0], ^(httrackp *options, id value) {}, @YES,
            nil];
    
}

+ (NSArray *)identityOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            // Identity
            @"Language", @"en, *", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"FooterString", @"<!-- Mirrored from %s%s by Mirror, %s -->", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"UserAgent", @"Mozilla/4.5 (compatible; Mirror 1.0; Windows 98)", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"FromEmailAddress", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"DefaultRefererURL", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"Headers", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            // Proxy
            @"UseProxy", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ProxyAddress", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ProxyPort", @"8080", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ProxyUsername", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ProxyPassword", @"", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ProxyFTP", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)engineOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            // Network
            @"Connections", [NSNumber numberWithInt:4], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"PersistentConnections", @YES, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"Timeout", @"120", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"AbandonTimeoutHosts", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"Retries", [NSNumber numberWithInt:2], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MinTransferRate", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"AbandonSlowHosts", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            // Limits
            @"MirroringDepth", @"9999", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"ExternalDepth", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"UseMaximumHTMLSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumHTMLSize", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"UseMaximumNonHTMLSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumNonHTMLSize", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"UseMaximumOverallSize", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumOverallSize", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"UsePauseMilestone", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"PauseMilestoneBytes", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"UseMaximumTime", @NO, ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumTime", @"0", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumTransferRate", @"25000", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumConnectionsSecond", @"4", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @YES,
            @"MaximumLinks", @"100000", ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            nil];
    
}

+ (NSArray *)miscOptions { // Key - Default Value - Mutating Block - Alterable when Engine Runs (YES/NO - use -boolValue to check value)
    
    return [NSArray arrayWithObjects:
            @"FollowRobots", [NSNumber numberWithInt:2], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
            @"CheckType", [NSNumber numberWithInt:1], ^(httrackp *options, id value) {options->accept_cookie = [value intValue];}, @NO,
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
        _presetIdentifier = [presetName copy];
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
                _presetIdentifier = [CustomPresetName copy];
            else
                _presetIdentifier = [[NSString stringWithFormat:@"%@ (%@)", CustomPresetName, dictionaryPresetName] copy];
            
        }
        
    }
    
    return self;
    
}

- (id)initWithProject:(Project *)project usingValues:(NSDictionary *)values {
    
    if (self = [super init]) {
        
        if (values) {
            optionsDictionary = [values mutableCopy];
            _presetIdentifier = [CustomPresetName copy];
        }
        else {
            optionsDictionary = [NSMutableDictionary new];
            _presetIdentifier = [DefaultPresetName copy];
        }
        
        _project = project;
        
    }
    
    return self;
    
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
        
        if (![_presetIdentifier isEqualToString:CustomPresetName]) {
            [_presetIdentifier release];
            _presetIdentifier = CustomPresetName;
        }
        
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
    
    [_presetIdentifier release];
    _presetIdentifier = [presetName copy];
    
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
    
    _project = nil;
    
    [optionsDictionary release];
    [_presetIdentifier release];
    
    [super dealloc];
    
}

@end
