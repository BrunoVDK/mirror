//
//  ProjectOptions.h
//  Defines project options and methods to work with them
//  Mirror
//
//  Created by Bruno Vandekerkhove on 29/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#pragma mark -
#pragma mark Option names

// Build options

#define LocalStructure @"LocalStructure"

#define DOSNames @"DOSNames"
#define ExcludeErrorPages @"ExcludeErrorPages"
#define ExcludeExternalPages @"ExcludeExternalPages"
#define PurgeOldFiles @"PurgeOldFiles"
#define ISO9660Names @"ISO9660Names"
#define HidePasswords @"HidePasswords"
#define HideQueryStrings @"HideQueryStrings"
#define MakeIndex @"MakeIndex"

#define CreateLogs @"CreateLogs"

#define UseCache @"UseCache"
#define StoreFilesInCache @"StoreFilesInCache"
#define DoNotRedownloadLocallyErased @"DoNotRedownloadLocallyErased"

// Download options

#define NumberOfConnections @"NumberOfConnections"
#define PersistentConnections @"PersistentConnections"
#define Timeout @"Timeout"
#define RemoveHostIfTimeout @"RemoveHostIfTimeout"
#define Retries @"Retries"
#define MinimumTransferRate @"MinimumTransferRate"
#define RemoveHostIfLowTransferRate @"RemoveHostIfLowTransferRate"

// Identity options

#define Proxy @"Proxy"
#define ProxyAddress @"ProxyAddress"
#define ProxyPort @"ProxyPort"
#define ProxyUsername @"ProxyUsername"
#define ProxyPassword @"ProxyPortPassword"
#define ProxyHidePassword @"ProxyHidePassword"
#define UseProxyForFTP @"UseProxyForFTP"

#define BrowserIdentity @"BrowserIdentity"
#define HTMLFooter @"HTMLFooter"
#define Language @"Language"
#define AdditionalHTTPHeaders @"AdditionalHTTPHeaders"
#define DefaultRefererURL @"DefaultRefererURL"

// Limits options

#define MaximumDepth @"MaximumDepth"
#define MaximumExternalDepth @"MaximumExternalDepth"
#define MaximumHTMLSize @"MaximumHTMLSize"
#define MaximumNonHTMLSize @"MaximumNonHTMLSize"
#define MaximumHTMLSizeCheck @"MaximumHTMLSizeCheck"
#define MaximumNonHTMLSizeCheck @"MaximumNonHTMLSizeCheck"

#define SiteSizeLimit @"SiteSizeLimit"
#define PauseAfterDownloading @"PauseAfterDownloading"
#define SiteSizeLimitCheck @"SiteSizeLimitCheck"
#define PauseAfterDownloadingCheck @"PauseAfterDownloadingCheck"
#define MaximumOverallTime @"MaximumOverallTime"
#define MaximumTransferRate @"MaximumTransferRate"
#define MaximumConnectionsSecond @"MaximumConnectionsSecond"
#define MaximumNumberOfLinks @"MaximumNumberOfLinks"

// Spider options

#define ParseRobots @"ParseRobotsTxt"
#define DetectAllLinks @"DetectAllLinks"
#define GetNonHTML @"GetNonHTML"
#define TestValidity @"TestValidity"
#define GetHTMLFirst @"GetHTMLFirst"
#define ParseJava @"ParseJava"

#define AcceptCookies @"AcceptCookies"
#define UpdateHack @"UpdateHack"
#define TolerantRequests @"TolerantRequests"
#define ForceOldHTTP @"ForceOldHTTP"

// Rules options

#define IncludeImages @"IncludeImages"
#define IncludeArchives @"IncludeArchives"
#define IncludeAudio @"IncludeAudio"
#define IncludeVideo @"IncludeVideo"

#define IncludeExclude @"IncludeExclude"

#pragma mark -
#pragma mark Option functions

// Parse optons dicitonary to command line argument list

static NSArray *argumentsForOptions(NSURL *baseURL, NSURL *exportDirectory, BOOL shouldContinue, NSDictionary *options) {
    
    // General options
    
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"httrack",
                                 (shouldContinue ? @"-i" : @"-w"),
                                 [baseURL absoluteString],
                                 @"-O",
                                 [exportDirectory path],
                                 nil];
    
    // Build options
    
    NSInteger lsids[20] = {0,1,2,3,4,5,99,100,101,102,103,104,105,199,1000,1001,1002,1003,1004,1099};
    [arguments addObject:[NSString stringWithFormat:@"-N%li", (long)lsids[[[options objectForKey:LocalStructure] integerValue]]]];
    
    if ([[options objectForKey:DOSNames] boolValue])
        [arguments addObject:@"-L0"];
    else if ([[options objectForKey:ISO9660Names] boolValue])
        [arguments addObject:@"-L2"];
    else
        [arguments addObject:@"-L1"];
    
    if ([[options objectForKey:ExcludeErrorPages] boolValue])
        [arguments addObject:@"-o0"];
    
    if ([[options objectForKey:ExcludeExternalPages] boolValue])
        [arguments addObject:@"-x"];
    
    if ([[options objectForKey:PurgeOldFiles] boolValue])
        [arguments addObject:@"-X"];
    else
        [arguments addObject:@"-X0"];
    
    if ([[options objectForKey:HidePasswords] boolValue])
        [arguments addObject:@"-%x"];
    else
        [arguments addObject:@"-%x0"];
    
    if ([[options objectForKey:HideQueryStrings] boolValue])
        [arguments addObject:@"-%q0"];
    else
        [arguments addObject:@"-%q"];
    
    if (![[options objectForKey:MakeIndex] boolValue])
        [arguments addObject:@"-I0"];
    
    if (![[options objectForKey:CreateLogs] boolValue])
        [arguments addObject:@"-Q"];
    
    if ([[options objectForKey:UseCache] boolValue]) {
        [arguments addObject:@"-C2"];
    }
    else {
        [arguments addObject:@"-C0"];
    }
    
    if ([[options objectForKey:StoreFilesInCache] boolValue])
        [arguments addObject:@"-k"];
    
    if ([[options objectForKey:DoNotRedownloadLocallyErased] boolValue])
        [arguments addObject:@"-%n"];
    
    // Download options
    
    switch ([[options objectForKey:NumberOfConnections] intValue]) {
        case 1:[arguments addObject:@"-c1"];break;
        case 2:[arguments addObject:@"-c2"];break;
        case 3:[arguments addObject:@"-c3"];break;
        case 4:[arguments addObject:@"-c4"];break;
        case 5:[arguments addObject:@"-c5"];break;
        case 6:[arguments addObject:@"-c6"];break;
        case 7:[arguments addObject:@"-c7"];break;
        default:[arguments addObject:@"-c8"];break;
    }
    
    switch ([[options objectForKey:Timeout] intValue]) {
        case 1:[arguments addObject:@"-T1"];break;
        case 2:[arguments addObject:@"-T3"];break;
        case 3:[arguments addObject:@"-T6"];break;
        case 4:[arguments addObject:@"-T30"];break;
        case 5:[arguments addObject:@"-T60"];break;
        case 6:[arguments addObject:@"-T300"];break;
        case 7:[arguments addObject:@"-T600"];break;
        case 8:[arguments addObject:@"-T1200"];break;
        default:break;
    }
    
    switch ([[options objectForKey:Retries] intValue]) {
        case 1:[arguments addObject:@"-R0"];break;
        case 3:[arguments addObject:@"-R2"];break;
        case 4:[arguments addObject:@"-R3"];break;
        default:[arguments addObject:@"-R1"];break;
    }
    
    [arguments addObject:[NSString stringWithFormat:@"-J%llu", [[options objectForKey:MinimumTransferRate] unsignedLongLongValue]]];
    
    int removehost = 0;
    if ([[options objectForKey:RemoveHostIfTimeout] boolValue]) removehost++;
    if ([[options objectForKey:RemoveHostIfLowTransferRate] boolValue]) removehost+=2;
        [arguments addObject:[NSString stringWithFormat:@"-H%i", removehost]];
    
    // Identity options
    
    if ([[options objectForKey:Proxy] boolValue]) {
        
        NSString *user = [options objectForKey:ProxyUsername];
        NSString *pass = [options objectForKey:ProxyPassword];
        NSString *address = [options objectForKey:ProxyAddress];
        NSString *port = [options objectForKey:ProxyPort];
        if (address && port) {
            if (user && [user length] > 0) {
                [arguments addObject:[NSString stringWithFormat:@"-P%@:%@@%@:%@", user, (pass ? pass : @""), (address ? address : @""), (port ? port : @"")]];
            }
            else {
                [arguments addObject:[NSString stringWithFormat:@"-P%@:%@", (address ? address : @""), (port ? port : @"")]];
            }
        }
        
        if (![[options objectForKey:UseProxyForFTP] boolValue]) [arguments addObject:@"%f0"];
        
    }
    
    NSString *footer = @"<!-- Mirrored from %s by HTTrack Website Copier/3.x [XR&CO'2014], %s -->";
    NSString *language = [options objectForKey:Language];
    NSString *headers = [options objectForKey:AdditionalHTTPHeaders];
    NSString *referer = [options objectForKey:DefaultRefererURL];
    
    [arguments addObject:[NSString stringWithFormat:@"-%%F \"%@\"", footer]];
    if (language)
        [arguments addObject:[NSString stringWithFormat:@"-%%l \"%@\"", language]];
    if ([headers length] > 0)
        [arguments addObject:[NSString stringWithFormat:@"-%%X \"%@\"", headers]];
    if ([referer length] > 0)
        [arguments addObject:[NSString stringWithFormat:@"-%%R \"%@\"", referer]];
    
    // Limits options
    
    switch ([[options objectForKey:MaximumDepth] intValue]) {
        case 1:[arguments addObject:@"-r0"];break;
        case 2:[arguments addObject:@"-r1"];break;
        case 3:[arguments addObject:@"-r2"];break;
        case 4:[arguments addObject:@"-r3"];break;
        case 5:[arguments addObject:@"-r4"];break;
        case 6:[arguments addObject:@"-r5"];break;
        case 7:[arguments addObject:@"-r10"];break;
        case 8:[arguments addObject:@"-r20"];break;
        default:[arguments addObject:@"-r9999"];break;
    }
    
    switch ([[options objectForKey:MaximumExternalDepth] intValue]) {
        case 1:[arguments addObject:@"-%e1"];break;
        case 2:[arguments addObject:@"-%e2"];break;
        case 3:[arguments addObject:@"-%e3"];break;
        default:[arguments addObject:@"-%e0"];break;
    }
    
    BOOL msnh = [[options objectForKey:MaximumNonHTMLSizeCheck] boolValue];
    BOOL msh = [[options objectForKey:MaximumHTMLSizeCheck] boolValue];
    unsigned long long msnhv = [[options objectForKey:MaximumNonHTMLSize] unsignedLongLongValue];
    unsigned long long mshv = [[options objectForKey:MaximumHTMLSize] unsignedLongLongValue];
    if ((msnh && msnhv > 0) || (msh && mshv > 0))
        [arguments addObject:[NSString stringWithFormat:@"-m%llu,%llu",(msnh ? msnhv : ULLONG_MAX),(msh ? mshv : ULLONG_MAX)]];
    
    if ([[options objectForKey:SiteSizeLimitCheck] boolValue])
        [arguments addObject:[NSString stringWithFormat:@"-M%llu", [[options objectForKey:SiteSizeLimit] unsignedLongLongValue]]];
    
    if ([[options objectForKey:PauseAfterDownloadingCheck] boolValue])
        [arguments addObject:[NSString stringWithFormat:@"-G%llu", [[options objectForKey:PauseAfterDownloading] unsignedLongLongValue]]];
    
    switch ([[options objectForKey:MaximumOverallTime] intValue]) {
        case 1:[arguments addObject:@"-E180"];break;
        case 2:[arguments addObject:@"-E360"];break;
        case 3:[arguments addObject:@"-E720"];break;
        case 4:[arguments addObject:@"-E1800"];break;
        case 5:[arguments addObject:@"-E3600"];break;
        case 6:[arguments addObject:@"-E7200"];break;
        default:;break;
    }
    
    switch ([[options objectForKey:MaximumTransferRate] intValue]) {
        case 1:[arguments addObject:@"-A10"];break;
        case 2:[arguments addObject:@"-A50"];break;
        case 3:[arguments addObject:@"-A200"];break;
        case 4:[arguments addObject:@"-A500"];break;
        case 5:[arguments addObject:@"-A2000"];break;
        case 6:[arguments addObject:@"-A5000"];break;
        case 7:[arguments addObject:@"-A25000"];break;
        case 8:[arguments addObject:@"-A100000"];break;
        case 9:[arguments addObject:@"-A250000"];break;
        default:break;
    }
    
    switch ([[options objectForKey:MaximumConnectionsSecond] intValue]) {
        case 1:[arguments addObject:@"-%c0"];break;
        case 2:[arguments addObject:@"-%c0.017"];break;
        case 3:[arguments addObject:@"-%c0.1"];break;
        case 4:[arguments addObject:@"-%c1"];break;
        case 5:[arguments addObject:@"-%c2"];break;
        case 6:[arguments addObject:@"-%c5"];break;
        default:[arguments addObject:@"-%c10"];break;
    }
    
    switch ([[options objectForKey:MaximumNumberOfLinks] intValue]) {
        case 1:[arguments addObject:@"-#L10000"];break;
        case 2:[arguments addObject:@"-#L20000"];break;
        case 3:[arguments addObject:@"-#L50000"];break;
        case 4:[arguments addObject:@"-#L100000"];break;
        case 5:[arguments addObject:@"-#L500000"];break;
        case 6:[arguments addObject:@"-#L1000000"];break;
        case 7:[arguments addObject:@"-#L5000000"];break;
        case 8:[arguments addObject:@"-#L10000000"];break;
        default:break;
    }
    
    // Spider options
    
    if (![[options objectForKey:ParseRobots] boolValue])
        [arguments addObject:@"-s0"];
    
    if (![[options objectForKey:DetectAllLinks] boolValue])
        [arguments addObject:@"-%P0"];
    
    if ([[options objectForKey:GetNonHTML] boolValue])
        [arguments addObject:@"-n"];
    
    if ([[options objectForKey:TestValidity] boolValue])
        [arguments addObject:@"-t"];
    
    if ([[options objectForKey:GetHTMLFirst] boolValue])
        [arguments addObject:@"-p7"];
    
    if (![[options objectForKey:ParseJava] boolValue])
        [arguments addObject:@"-j0"];
    
    if (![[options objectForKey:AcceptCookies] boolValue])
        [arguments addObject:@"-b0"];
    
    if ([[options objectForKey:UpdateHack] boolValue])
        [arguments addObject:@"-%s"];
    
    if ([[options objectForKey:TolerantRequests] boolValue])
        [arguments addObject:@"-%B"];
    
    if ([[options objectForKey:ForceOldHTTP] boolValue])
        [arguments addObject:@"-%h"];
    
    // Rules options
    
    for (NSString *rule in [options objectForKey:IncludeExclude])
        [arguments addObject:rule];
    
    return arguments;
    
}

// NSString to C String

static void CStringFromNSString(NSString *string, char* cstring_pointer) {
    
    NSUInteger length = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1;
    char cstring [length];
    
    if ([string getCString:cstring maxLength:length encoding:NSUTF8StringEncoding])
        strncpy(cstring_pointer, cstring, length);
    else
        NSLog(@"Error converting %@ to CString", string); // Error
    
}

// Numerical NSString to unsigned long long

static unsigned long long stringToUnsignedLongLong(NSString *string) {
    
    if (!string || [string length] < 1)
        return 0; // Empty string
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber * number = [numberFormatter numberFromString:string];
    
    return [number unsignedLongLongValue];
    
}

#pragma mark -
#pragma mark Default options

// Dictionary with default project options

static NSDictionary *defaultProjectOptions() {
    
    static NSDictionary *dict = nil;
    
    if (!dict) {
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                
                // Build options
                
                [NSNumber numberWithInt:0], LocalStructure,
                @NO, DOSNames,
                @NO, ExcludeErrorPages,
                @NO, ExcludeExternalPages,
                @NO, PurgeOldFiles,
                @NO, ISO9660Names,
                @NO, HidePasswords,
                @NO, HideQueryStrings,
                @NO, MakeIndex,
                @NO, CreateLogs,
                
                @YES, UseCache,
                @NO, StoreFilesInCache,
                @NO, DoNotRedownloadLocallyErased,
                
                // Download options
                
                 // nil, NumberOfConnections,
                @YES, PersistentConnections,
                 // nil, Timeout,
                @NO, RemoveHostIfTimeout,
                 // nil, Retries,
                [NSNumber numberWithInt:1000], MinimumTransferRate,
                @NO, RemoveHostIfLowTransferRate,
                
                // Identity options
                
                @NO, Proxy,
                 // nil, ProxyAddress,
                 // nil, ProxyPort,
                 // nil, ProxyUsername,
                 // nil, ProxyPortPassword,
                @NO, ProxyHidePassword,
                @YES, UseProxyForFTP,
                @"Mozilla/4.5 (compatible; HTTrack 3.0x; Windows 98)", BrowserIdentity,
                @"<!-- Mirrored by Miroir -->", HTMLFooter,
                @"en, *", Language,
                @"", AdditionalHTTPHeaders,
                @"", DefaultRefererURL,
                
                // Limits options
                
                [NSNumber numberWithInt:0], MaximumDepth,
                [NSNumber numberWithInt:0], MaximumExternalDepth,
                @NO, MaximumHTMLSizeCheck,
                @NO, MaximumNonHTMLSizeCheck,
                @NO, SiteSizeLimitCheck,
                @NO, PauseAfterDownloadingCheck,
                [NSNumber numberWithInt:1000], MaximumHTMLSize,
                [NSNumber numberWithInt:1000], MaximumNonHTMLSize,
                [NSNumber numberWithInt:1000], SiteSizeLimit,
                [NSNumber numberWithInt:1000], PauseAfterDownloading,
                [NSNumber numberWithInt:0], MaximumOverallTime,
                [NSNumber numberWithInt:7], MaximumTransferRate,
                [NSNumber numberWithInt:0], MaximumConnectionsSecond,
                [NSNumber numberWithInt:0], MaximumNumberOfLinks,
                
                // Spider options
                
                 @YES, ParseRobots,
                 @YES, DetectAllLinks,
                 @NO, GetNonHTML,
                 @NO, TestValidity,
                 @NO, GetHTMLFirst,
                 @YES, ParseJava,
                 @YES, AcceptCookies,
                 @YES, UpdateHack,
                 @NO, TolerantRequests,
                 @NO, ForceOldHTTP,
                
                // Rules options
                
                [NSMutableArray arrayWithObjects:
                 @"+*.png",@"+*.gif",@"+*.jpg",@"+*.jpeg",@"+*.css",@"+*.js",@"-ad.doubleclick.net/*",@"-mime:application/foobar", nil], IncludeExclude,
                
                nil];
        
    }
    
    return dict;
    
}

static NSDictionary *userDefaultGeneralOptions() {
    
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DefaultOptions"];
    
}