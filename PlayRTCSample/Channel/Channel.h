//
//  Channel.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
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
