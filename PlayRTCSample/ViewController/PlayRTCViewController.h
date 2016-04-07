//
//  PlayRTCViewController.h
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#ifndef __PlayRTCViewController_h__
#define __PlayRTCViewController_h__

#import <UIKit/UIKit.h>
#import "ChannelView.h"

#import "PlayRTCFactory.h"
#import "PlayRTCVideoView.h"
#import "PlayRTCMedia.h"
#import "PlayRTCData.h"



@interface PlayRTCViewController : UIViewController<UIAlertViewDelegate, ChannelViewListener>
{
    NSString* channelId;
    NSString* token;
    NSString* userUid;
    PlayRTCVideoView* localVideoView;
    PlayRTCVideoView* remoteVideoView;
    CGSize _localVideoSize;
    CGSize _remoteVideoSize;
    
    // PlayRTC 인스턴스
    PlayRTC* playRTC;
    
    // 로컬 PlayRTCMedia 인스턴스
    __weak PlayRTCMedia* localMedia;
    
    // 상대방 PlayRTCMedia 인스턴스
    __weak PlayRTCMedia* remoteMedia;
    
    // P2P 데이터 통신 인스턴스
    __weak PlayRTCData* dataChannel;

    
    // 화면 Layout , PlayRTCViewController(Layout)
    UIView* mainAreaView;
    UITextView* leftTopView;
    UIView* rightTopView;
    UIView* videoAreaView;
    UIView* bottomAreaView;
    
    // 채널 생성 및 채널 입장 팝업
    ChannelView* channelPopup;

    
    NSFileHandle *myHandle;
    NSString *recvFile;

    // PlayRTC
    // 1 : 영상 + 음성 + Data Type
    // 2 : 영상 + 음성
    // 3 : 음성
    // 4 : Data
    int playrtcType;
    
    // 로깅 관련
    NSString* prevText;
    BOOL hasPrevText;
    
    // 채널 서비스 연결 여부 
    BOOL isChannelConnected;
    
}

@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userUid;
@property (nonatomic, strong) PlayRTC* playRTC;
@property (nonatomic, strong) PlayRTCVideoView* localVideoView;
@property (nonatomic, strong) PlayRTCVideoView* remoteVideoView;
@property (nonatomic, weak) PlayRTCMedia* localMedia;
@property (nonatomic, weak) PlayRTCMedia* remoteMedia;
@property (nonatomic, weak) PlayRTCData* dataChannel;
@property (nonatomic, copy) NSString* ringPid;
@property (assign, nonatomic)int playrtcType;
@property (nonatomic, copy)NSString* prevText;
@property (nonatomic, copy)NSString *recvFile;

- (id)initWithType:(int)type;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

/* ChannelViewListener */
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
- (void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId;
- (void)didSessionRouteChange:(NSNotification *)notification;
@end

#endif


