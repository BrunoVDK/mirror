//
//  AppDelegate.m
//  SpeedTests
//
//  Created by Bruno Vandekerkhove on 20/09/17.
//  Copyright (c) 2017 Bruno Vandekerkhove. All rights reserved.
//

#import "AppDelegate.h"
#import "ProjectSocket.h"

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

static long getMilliSeconds() {
    
    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    return spec.tv_nsec / 1.0e6;
    
}

static long getNanoSeconds() {
    
    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    return spec.tv_nsec;
    
}

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

@interface AppDelegate ()
@property (strong) IBOutlet NSTableView *table;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    printTimestamp();
    
    sockets = [NSMutableArray new];
    for (int i=0 ; i<100 ; i++) {
        [sockets addObject:[ProjectSocket socketWithAddress:@"azoerpuazeoi"
                                                       file:@"aeirpuazoi"
                                                       size:1024
                                                  totalSize:19403]];
        // NSMutableArray *test = [sockets mutableCopy];
    }
    
    
    [self.arrayController addObjects:sockets];
    
    
    [[self.table tableColumnWithIdentifier:@"Value"] bind:NSValueBinding toObject:self.arrayController withKeyPath:@"arrangedObjects.address" options:nil];
    
    printTimestamp();
    
    
    
}

@end
