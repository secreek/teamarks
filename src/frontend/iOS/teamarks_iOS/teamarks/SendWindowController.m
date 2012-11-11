//
//  SendWindowController.m
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import "SendWindowController.h"
#import "LogTools.h"

@interface SendWindowController ()

@end

@implementation SendWindowController

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
    
    [self.window setTitle:@"Teamarks"];
    
    [_textView setFont:[NSFont systemFontOfSize:13.0f]];
    
    [_sendingIndicator setHidden:YES];
    
    [self fillTextFields];
}


- (void)fillTextFields
{
    _rawText = @"Safari Books Online (www.safaribooksonline.com) is an on-demand digital library that delivers expert content in both book and video form from the world’s leading authors in technology and business.";
    
    NSError *error = NULL;
    NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSArray *matches = [urlDetector matchesInString:_rawText options:0 range:NSMakeRange(0, [_rawText length])];
    
    DLog(@"matches count [%lu]", [matches count]);
    
    if ([matches count] > 0) {
        NSTextCheckingResult *firstMatch = [matches objectAtIndex:0];
        
        NSURL *url = [firstMatch URL];
        
        
        DLog(@"URL [%@]", [url absoluteString]);
        //DLog(@"range [%lu, %lu]", [firstMatch range].location, [firstMatch range].length);
        
        NSString *titlePart = [_rawText substringWithRange:NSMakeRange(0, firstMatch.range.location)];
        NSString *textPart = [_rawText substringWithRange:NSMakeRange(firstMatch.range.location + firstMatch.range.length, _rawText.length - titlePart.length - firstMatch.range.length)];
        
        DLog(@"1: [%@]", titlePart);
        DLog(@"2: [%@]", textPart);
        
        // TODO: trim the title and text
        
        [_titleField setStringValue:titlePart];
        [_urlField setStringValue:[url absoluteString]];
        [_textView setString:textPart];
    }
}

@end
