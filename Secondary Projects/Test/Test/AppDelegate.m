//
//  AppDelegate.m
//  Test
//
//  Created by Bruno Vandekerkhove on 21/09/17.
//  Copyright (c) 2017 Bruno Vandekerkhove. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSArrayController *arrayController;
- (IBAction)fire:(NSTableView *)sender;
@end

@implementation AppDelegate

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.arrayController setContent:[NSMutableArray new]];
    
    [self performSelectorInBackground:@selector(updateController) withObject:nil];
    
}

- (void)updateController {
        
    NSMutableArray *newArray = [NSMutableArray array];
    int r = rand() % 3 + 1;
    for (int i=0 ; i<r ; i++)
        [newArray addObject:[NSString stringWithFormat:@"%i", rand()]];
    
    dispatch_sync(dispatch_get_main_queue(), ^{ // On main queue
        self.arrayController.content = newArray;
    });
    
    [NSThread sleepForTimeInterval:1.0/17.0]; // Do not use integers or it gets rounded as integer, can be zero which means instantaneous
    
    [self updateController];
    
}

- (IBAction)fire:(NSTableView *)view {
    
    NSUInteger clickedRow = [view clickedRow];
    if (clickedRow != NSNotFound && clickedRow < ((NSArray *)(self.arrayController.arrangedObjects)).count)
        NSLog(@"%@", [self.arrayController.arrangedObjects objectAtIndex:clickedRow]);
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    return false;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return true;
    
}

@end
