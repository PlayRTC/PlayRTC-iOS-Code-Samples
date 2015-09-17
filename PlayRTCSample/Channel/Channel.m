//
//  AppDelegate.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import "Channel.h"


@implementation Channel
@synthesize channelId;
@synthesize channelName;
@synthesize userId;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        self.channelId = nil;
        self.channelName = nil;
        self.userId = nil;
    }
    return self;
}

- (void)dealloc
{
    self.channelId = nil;
    self.channelName = nil;
    self.userId = nil;
}
@end
