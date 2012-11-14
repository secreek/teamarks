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
#import "DDHotKeyCenter.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableSet *sendWindowControllers;

@property (nonatomic, strong) SendWindowController *testSendWC;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign) IBOutlet NSMenu *statusMenu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Test only
    //_testSendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    //[_testSendWC showWindow:self];
    
    //register hotkey
    [self registerHotkey];
    
    // init an empty set to store all the share windows
    _sendWindowControllers = [NSMutableSet set];
    
    // set status item
    NSImage *statusIcon = [NSImage imageNamed:@"status_icon.png"];
    [statusIcon setTemplate:YES];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:statusIcon];
    [_statusItem setHighlightMode:YES];
    
    [_statusItem setMenu:_statusMenu];
    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [self unregisterHotkey];
}

- (IBAction)statusShare:(id)sender {
    DLog(@"share");
    
    SendWindowController *sendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    [sendWC setDelegate:self];
    [sendWC showWindow:self];
    
    [_sendWindowControllers addObject:sendWC];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (IBAction)quit:(id)sender {
    //DLog(@"quit");
    [[NSApplication sharedApplication] terminate:nil];
}

#pragma mark - SendWindowControllerDelegate

- (void)sendWindowControllerDidSend:(SendWindowController *)windowController {
    DLog(@"release a WC");
    [_sendWindowControllers removeObject:windowController];
}

#pragma mark - Hotkey

- (IBAction) registerHotkey {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithKeyCode:9 modifierFlags:NSControlKeyMask target:self action:@selector(hotkeyWithEvent:) object:nil]) {
	}
}

- (IBAction) unregisterHotkey {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:NSControlKeyMask];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent {
	[self statusShare:nil];
}


@end
