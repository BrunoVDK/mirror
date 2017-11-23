//
//  Globals.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 24/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//
//  Global variables and functions.
//

#import <SystemConfiguration/SystemConfiguration.h>

/**
 * An enumeration for window themes for OSs >= Yosemite.
 */
enum {
    /**
     * The Yosemite-like theme. It displays a typical Yosemite window with a vibrant sidebar.
     */
    WindowThemeYosemite,
    /**
     * The classic theme. This presents a normal window with a toolbar and a footer.
     */
    WindowThemeClassic,
    /**
     * The white theme. It differs from the classic theme only in that it is white rather than gray.
     */
    WindowThemeWhite,
} typedef WindowTheme;

#pragma mark - Utility Functions

/**
 * Check whether an internet connection is available.
 *
 * @return True if and only if an internet connection is available.
 */
static int hasInternetConnection() {
    
    int returnValue = 0;
    
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    
    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&zeroAddress);
    
    if (reachabilityRef != NULL)
    {
        SCNetworkReachabilityFlags flags = 0;
        
        if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        {
            int isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
            int connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
            returnValue = (isReachable && !connectionRequired) ? 1 : 0;
        }
        
        CFRelease(reachabilityRef);
    }
    
    return returnValue;
    
}

#define CLOCK_REALTIME 0 
#define CLOCK_MONOTONIC 0

#ifdef __MACH__
#include <sys/time.h>
/**
 * Get the current time using the given clock identifier.
 *
 * @param clk_id The identifier of the clock that is to be used.
 * @param t A pointer to a timespec structure. Its values are set to the current time.
 */
static int clock_gettime(int clk_id, struct timespec *t) {
    
    struct timeval now;
    int rv = gettimeofday(&now, NULL);
    
    if (rv)
        return rv;
    
    t->tv_sec  = now.tv_sec;
    t->tv_nsec = now.tv_usec * 1000;
    
    return 0;
    
}
#endif

/**
 * Prints the current timestamp.
 */
static void printTimestamp() { // For speed testing purposes
    
    long milliSeconds;
    time_t seconds;
    struct timespec spec;
    
    clock_gettime(CLOCK_REALTIME, &spec);
    seconds  = spec.tv_sec;
    milliSeconds = round(spec.tv_nsec / 1.0e6); // Conversion from nanoseconds to milliseconds
    
    printf("Current time: %"PRIdMAX".%ld seconds since the Epoch\n", (intmax_t)seconds, milliSeconds);
    
}

static long getMilliSeconds() {
    
    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    return round(spec.tv_nsec / 1.0e6);
    
}

static long getNanoSeconds() {
    
    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    return spec.tv_nsec;
    
}

#define LOG_POINT(point) NSLog(@"(%f, %f)", point.x, point.y)
#define LOG_SIZE(size) NSLog(@"(%f, %f)", size.width, size.height)
#define LOG_RECT(rect) NSLog(@"(%f, %f, %f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#pragma mark - Constants

#define CHANGE_NONKEY_WINDOW_DESIGN 1
#define CHANGE_NONKEY_MAIN_WINDOW_DESIGN 1
#define IS_MAIN(window) ([window isMainWindow] || [window isKindOfClass:[NSPanel class]])
#define IS_MAIN2(window) ([window isMainWindow] || ([window isKindOfClass:[NSPanel class]] && [window isKeyWindow]))
#define USE_CUSTOM_SEGMENTED_CONTROL false

#define ABOUT_TEXT @" \
Mirror allows you to copy websites for offline use. It wraps around Xavier Roche's HTTrack, so here's the latter's license : \
\n \
\n \
HTTrack Website Copier, Offline Browser for Windows and Unix \
Copyright (C) 1998-2015 Xavier Roche and other contributors \
\n \
\n \
This program is free software: you can redistribute it and/or modify \
it under the terms of the GNU General Public License as published by \
the Free Software Foundation, either version 3 of the License, or \
(at your option) any later version. \
\n \
\n \
This program is distributed in the hope that it will be useful, \
but WITHOUT ANY WARRANTY; without even the implied warranty of \
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the \
GNU General Public License for more details. \
\n \
\n \
You should have received a copy of the GNU General Public License \
along with this program. If not, see <http://www.gnu.org/licenses/>. \
\n \
\n \
Important notes: \
\n \
\n \
- We hereby ask people using this source NOT to use it in purpose of grabbing \
e-mail addresses, or collecting any other private information on persons. \
This would disgrace our work, and spoil the many hours we spent on it. \
\n \
Please visit our Website: http://www.httrack.com \
\n \
\n \
"

#define STATS_BASE_HEIGHT 36.0
#define STATS_SUB_HEIGHT 12.0

#define MAX_URLS 128
#define BASE_URL @"http://www.domain.com"
#define BASE_URL_SELECT_RANGE NSMakeRange(11, 0)

#define TITLE_FONT [NSFont systemFontOfSize:11.0]
#define STATS_FONT [NSFont systemFontOfSize:9.0]

#define PREFERENCES [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

#define IS_PRE_YOSEMITE (NSClassFromString(@"NSVisualEffectView") == nil) // Checks whether the current OS is < macOS 10.10 (Yosemite)

#define DOCUMENT_EXTENSION @"mirror"
#define DOCUMENT_TYPE @"Mirror Project"

#define SQLITE3_DEBUG FALSE

#define CHECK_INTERNET_CONNECTION TRUE