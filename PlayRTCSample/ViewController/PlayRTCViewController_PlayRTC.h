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

- (void)createPlayRTCHandler;
- (PlayRTCSettings*)createConfiguration;
- (void)createChannel:(NSString*)channelName userId:(NSString*)userId;
- (void)connectChannel:(NSString*)channelId userId:(NSString*)userId;
- (void)disconnectChannel:(NSString*)peerId;
- (void)deleteChannel;
- (void)sendDataChannelText;
- (void)sendDataChannelBinary;
- (void)sendDataChannelFile;
- (void)switchCamera;
////////////////////////////////////////////////////////

@end
#endif
