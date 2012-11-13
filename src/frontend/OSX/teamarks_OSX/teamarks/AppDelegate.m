//
//  AppDelegate.m
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import "AppDelegate.h"
#import "LogTools.h"
#import "SendWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableSet *sendWindows;

@property (nonatomic, strong) SendWindowController *testSendWC;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign) IBOutlet NSMenu *statusMenu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Test only
    //_testSendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    //[_testSendWC showWindow:self];
    
    // init an empty set to store all the share windows
    _sendWindows = [NSMutableSet set];
    
    // set status item
    NSImage *statusIcon = [NSImage imageNamed:@"status_icon.png"];
    [statusIcon setTemplate:YES];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:statusIcon];
    [_statusItem setHighlightMode:YES];
    
    [_statusItem setMenu:_statusMenu];
    
}

- (IBAction)statusShare:(id)sender {
    DLog(@"share");
    
    SendWindowController *sendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    [sendWC showWindow:self];
    
    [_sendWindows addObject:sendWC];
}

- (IBAction)quit:(id)sender {
    //DLog(@"quit");
    [[NSApplication sharedApplication] terminate:nil];
}


@end
