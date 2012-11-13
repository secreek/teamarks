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
#define API_USERID @"5"
#define API_KEY @"3a2691d4a9cc4fe0c34cfb2c990bdecf"

@interface SendWindowController ()

@property (strong, nonatomic) NSXMLParser *titleParser;
@property (assign, nonatomic) BOOL foundTitle;

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
    [_sendingIndicator startAnimation:nil];
    [_titleIndicator setHidden:YES];
    [_titleIndicator startAnimation:nil];
    
    [_sendButton setEnabled:NO];
    
    
    // setup action
    
    [_sendButton setTarget:self];
    [_sendButton setAction:@selector(send:)];
    
    // urlField delegate
    [_urlField setDelegate:self];
    
    // get latest raw text form system pasteboard
    
    NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
    NSString *latestString = [pastboard stringForType:NSPasteboardTypeString];
    //DLog(@"%@", latestString);
    [self setRawText:latestString];
    
    // fill textFields and textView
    [self fillTextFields];
    
    
}


- (void)fillTextFields
{
    //_rawText = @"Safari Books Online (www.safaribooksonline.com) is an on-demand digital library that delivers expert content in both book and video form from the world’s leading authors in technology and business.";
    
    NSError *error = NULL;
    NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSArray *matches = [urlDetector matchesInString:_rawText options:0 range:NSMakeRange(0, [_rawText length])];
    
    DLog(@"matches count [%lu]", [matches count]);
    
    if ([matches count] > 0) {
        [_sendButton setEnabled:YES];
        
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
        
        [self updateTitleWithURL:url];
    }
}

- (void)updateTitleWithURL:(NSURL *)url {
    [_titleIndicator setHidden:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_titleParser != nil) {
            [_titleParser setDelegate:nil];
            [_titleParser abortParsing];
        }
        [self setTitleParser:[[NSXMLParser alloc] initWithContentsOfURL:url]];
        [_titleParser setDelegate:self];
        [_titleParser parse];
    });
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"title"]) {
        _foundTitle = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"title"]) {
        _foundTitle = NO;
        [_titleParser abortParsing];
        [self setTitleParser:nil];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_foundTitle) {
        DLog(@"%@", string);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_titleField setStringValue:string];
            [_titleIndicator setHidden:YES];
        });
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"endDocument");
    [_titleIndicator setHidden:YES];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"start parse");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseErrorOccurred [%@] line[%ld] col[%ld]", [parseError localizedDescription], parser.lineNumber, parser.columnNumber);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"validationErrorOccurred [%@]", [validationError localizedDescription]);
}

#pragma mark - Share

- (void)changeSendStatus:(BOOL)sending {
    if (sending) {
        [_sendingIndicator setHidden:NO];
        [_sendingIndicator startAnimation:nil];
        
        [_sendButton setEnabled:NO];
    }
    else {
        [_sendingIndicator setHidden:YES];
        [_sendingIndicator stopAnimation:nil];
        
        [_sendButton setEnabled:YES];
    }
}

- (void)send:(id)sender
{
    [self changeSendStatus:YES];
    
    NSString *title = [_titleField stringValue];
    NSString *url = [_urlField stringValue];
    NSString *text = [[_textView textStorage] string];
    
    //DLog(@"%@\n%@\n%@", title, url, text);
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:API_URL_BASE]];
    [client setStringEncoding:NSUTF8StringEncoding];
    [client setParameterEncoding:AFJSONParameterEncoding];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_USERID, @"userid",
                                API_KEY, @"apikey",
                                title, @"title",
                                text, @"text",
                                url, @"url",
                                nil];
    
    [client postPath:API_PATH_SHARE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"send success");
        [self changeSendStatus:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"[ERROR]: %@", [error localizedDescription]);
        [self changeSendStatus:NO];
    }];
}


#pragma mark - NSControlTextEditingDelegate

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = [obj object];
    if (textField == _urlField) {
        NSString *tempUrl = [_urlField stringValue];
        NSError *error = nil;
        NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *matches = [urlDetector matchesInString:tempUrl options:0 range:NSMakeRange(0, [tempUrl length])];
        if ([matches count] > 0) {
            NSTextCheckingResult *firstMatch = [matches objectAtIndex:0];
            NSURL *url = [firstMatch URL];
            
            [_urlField setStringValue:[url absoluteString]];
            [self updateTitleWithURL:url];
            
            [_sendButton setEnabled:YES];
        }
    }
    
}


@end
