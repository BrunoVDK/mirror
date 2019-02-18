//
//  AppDelegate.h
//  SpeedTests
//
//  Created by Bruno Vandekerkhove on 20/09/17.
//  Copyright (c) 2017 Bruno Vandekerkhove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    
    NSMutableArray *sockets;
    
}


@end

