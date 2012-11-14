//
//  SendWindowController.h
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSHTMLParser.h"

@interface SendWindowController : NSWindowController
<
GSHTMLParserDelegate,
NSTextFieldDelegate
>

@property (assign) IBOutlet NSButtonCell *sendButton;
@property (assign) IBOutlet NSProgressIndicator *sendingIndicator;
@property (assign) IBOutlet NSProgressIndicator *titleIndicator;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet NSTextView *textView;


@property (strong, nonatomic) NSString *rawText;

@end
