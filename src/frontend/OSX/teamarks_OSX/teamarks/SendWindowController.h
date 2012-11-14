//
//  SendWindowController.h
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSHTMLParser.h"

@protocol  SendWindowControllerDelegate;

@interface SendWindowController : NSWindowController
<
GSHTMLParserDelegate,
NSTextFieldDelegate,
NSWindowDelegate
>

@property (weak, nonatomic) id<SendWindowControllerDelegate> delegate;

@property (assign) IBOutlet NSButtonCell *sendButton;
@property (assign) IBOutlet NSProgressIndicator *sendingIndicator;
@property (assign) IBOutlet NSProgressIndicator *titleIndicator;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet NSTextView *textView;
@property (readonly, getter = isSending) BOOL sending;

@property (strong, nonatomic) NSString *rawText;

@end


@protocol  SendWindowControllerDelegate <NSObject>

- (void)sendWindowControllerDidSend:(SendWindowController *)windowController;

@end