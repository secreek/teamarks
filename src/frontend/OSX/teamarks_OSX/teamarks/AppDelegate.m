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
#import "PreferencesWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableSet *sendWindowControllers;

@property (nonatomic, strong) SendWindowController *testSendWC;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) PreferencesWindowController *preferencesWC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    Test only
//    _testSendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
//    [_testSendWC showWindow:self];
//    [self testCrash];
    
    //register hotkey
    [self registerHotkey];
    
    // init an empty set to store all the share windows
    _sendWindowControllers = [NSMutableSet set];
    
    // set status item
    NSImage *statusIcon = [NSImage imageNamed:@"status_icon.tiff"];
    [statusIcon setTemplate:YES];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:statusIcon];
    [_statusItem setHighlightMode:YES];
    
    [_statusItem setMenu:_statusMenu];
    
    _preferencesWC = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kPreferencesUserID];
    if (!userID || userID.length == 0) {
        [self preferences:nil];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [self unregisterHotkey];
}

- (IBAction)preferences:(id)sender {
    [_preferencesWC showWindow:self];
}

- (IBAction)statusShare:(id)sender {
    DLog(@"share");
    
    SendWindowController *sendWC = [[SendWindowController alloc] initWithWindowNibName:@"SendWindowController"];
    [sendWC setDelegate:self];
    [sendWC showWindow:self];
    
    [_sendWindowControllers addObject:sendWC];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (IBAction)help:(id)sender {
    NSString *howToUse = @"How To Use:\n1. Copy the URL you want to share.\n2. Clik \"Share\" in the menu or use a short cut key Ctrl+V.\n3. Title of the web page will be automatically filled.\n4. Make possible changes you want.\n5. Click \"Share\" button.";
    NSAlert *alert = [NSAlert alertWithMessageText:howToUse defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
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

#pragma mark - Test Crash

// 100% Crash in Debug mode, Release mode won't, Other project won't, Possible Reason: AFNetworking

- (void)testCrash {
    NSURL *url = [NSURL URLWithString:@"https://developers.google.com/live/shows/116425520/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17" forHTTPHeaderField:@"User-Agent"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn start];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"canAuthenticateAgainstProtectionSpace");
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"%@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    DLog(@"");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"");
}

@end
