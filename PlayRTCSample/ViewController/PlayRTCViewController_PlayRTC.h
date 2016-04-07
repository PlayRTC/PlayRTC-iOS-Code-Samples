//
//  PlayRTCViewController_PlayRTC.h
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#ifndef __PlayRTCViewController_PlayRTC_h__
#define __PlayRTCViewController_PlayRTC_h__

#import "PlayRTCViewController.h"
#import "PlayRTCViewController_UILayout.h"

@interface PlayRTCViewController(PlayRTC)

/**
 * SDK 설정 객체인 PlayRTCConfig를 생성한 후 PlayRTC 인스턴스를 생성.
 */
- (void)createPlayRTCHandler;
- (PlayRTCConfig*)createPlayRTCConfiguration;
- (void)createChannel:(NSString*)channelName userId:(NSString*)userId;
- (void)connectChannel:(NSString*)channelId userId:(NSString*)userId;
- (void)disconnectChannel;
- (void)deleteChannel;
- (void)sendDataChannelText;
- (void)sendDataChannelBinary;
- (void)sendDataChannelFile;
- (void)switchCamera;
////////////////////////////////////////////////////////

@end
#endif
