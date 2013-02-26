//
//  PreferencesWindowController.m
//  teamarks
//
//  Created by Xinrong Guo on 13-2-26.
//  Copyright (c) 2013年 Xinrong Guo. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "LogTools.h"

@interface PreferencesWindowController ()

@property (assign) IBOutlet NSTextField *userIDTextField;

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window setDelegate:self];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kPreferencesUserID];
    if (userID) {
        [_userIDTextField setStringValue:userID];
    }
}

#pragma mark - NSWindow Delegate

- (void)windowWillClose:(NSNotification *)notification {
    DLog(@"Preferences window close")
    if (_userIDTextField.stringValue.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:_userIDTextField.stringValue forKey:kPreferencesUserID];
    }
}

@end
