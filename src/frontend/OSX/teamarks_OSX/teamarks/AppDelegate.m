//
//  AppDelegate.m
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _sendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    [_sendWC showWindow:_sendWC.window];
}


@end
