//
//  AppDelegate.h
//  teamarks
//
//  Created by Xinrong Guo on 12-11-11.
//  Copyright (c) 2012年 Xinrong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SendWindowController.h"

@interface AppDelegate : NSObject
<
NSApplicationDelegate,
SendWindowControllerDelegate,
NSURLConnectionDataDelegate,
NSURLConnectionDelegate
>


@end
