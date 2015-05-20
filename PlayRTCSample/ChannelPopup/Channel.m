//
//  AppDelegate.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
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
