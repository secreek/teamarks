//
//  SendWindowController.h
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SendWindowController : NSWindowController

@property (assign) IBOutlet NSButtonCell *sendButton;
@property (assign) IBOutlet NSProgressIndicator *sendingIndicator;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet NSTextView *textView;


@property (strong, nonatomic) NSString *rawText;

@end
