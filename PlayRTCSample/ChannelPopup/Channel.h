//
//  Channel.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
{
    NSString* channelId;
    NSString* channelName;
    NSString* userId;
}

@property (strong, nonatomic)NSString* channelId;
@property (strong, nonatomic)NSString* channelName;
@property (strong, nonatomic)NSString* userId;
@end
