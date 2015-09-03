//
//  ChannelView.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ChannelView_h__
#define __ChannelView_h__

#import <UIKit/UIKit.h>
#import "PlayRTCServiceHelperListener.h"

@protocol ChannelViewListener <NSObject>

- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
- (void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId;
- (void)getChannelList:(id<PlayRTCServiceHelperListener>)listener;
@end

@class BasePlayRTC;
@interface ChannelView : UIView
{
    __weak id<ChannelViewListener> deletgate;
}
@property (weak, nonatomic) id<ChannelViewListener> deletgate;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;
- (void)show:(NSTimeInterval)delayed;
- (void)hide;
- (void)setChannelId:(NSString*)channelId;
- (void)showChannelList;

@end
#endif
