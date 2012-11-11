//
//  SendWindowController.m
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "SendWindowController.h"
#import "LogTools.h"

#define API_URL_BASE @"http://api.teamarks.com/"
#define API_PATH_SHARE @"v1/share.xml"
#define API_USERID @"2"
#define API_KEY @"daf16f1b028b3eed07ae7835fc049cdcdaf16f1b028b3eed07ae7835fc049cdc"

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
    
    // setup user interface
    [self.window setTitle:@"Teamarks"];
    
    [_textView setFont:[NSFont systemFontOfSize:13.0f]];
    
    [_sendingIndicator setHidden:YES];
    
    // setup action
    [_sendButton setTarget:self];
    [_sendButton setAction:@selector(send:)];
    
    // fill textFields and textView
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

- (void)send:(id)sender
{
    [_sendingIndicator setHidden:NO];
    [_sendingIndicator startAnimation:nil];
    
    NSString *title = [_titleField stringValue];
    NSString *url = [_urlField stringValue];
    NSString *text = [[_textView textStorage] string];
    
    //DLog(@"%@\n%@\n%@", title, url, text);
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:API_URL_BASE]];
    [client setStringEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_USERID, @"userid",
                                API_KEY, @"apikey",
                                title, @"title",
                                text, @"text",
                                url, @"url",
                                nil];
    
    [client postPath:API_PATH_SHARE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"send success");
        [_sendingIndicator setHidden:YES];
        [_sendingIndicator stopAnimation:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"[ERROR]: %@", [error localizedDescription]);
        [_sendingIndicator setHidden:YES];
        [_sendingIndicator stopAnimation:nil];
    }];
}
@end
