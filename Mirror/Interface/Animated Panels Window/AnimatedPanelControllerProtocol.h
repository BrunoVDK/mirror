//
//  AnimatedPanelControllerProtocol.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

//
//  Adapted from Frank Gregor's CCNPreferencesWindowControllerProtocol
//  The MIT License (MIT)
//  Copyright © 2014 Frank Gregor, <phranck@cocoanaut.com>
//  http://cocoanaut.mit-license.org
//

@protocol AnimatedPanelControllerProtocol <NSObject>

- (NSString *)panelIdentifier;
- (NSString *)panelTitle;
- (NSImage *)panelIcon;

@optional
- (NSString *)panelToolTip;

@end
