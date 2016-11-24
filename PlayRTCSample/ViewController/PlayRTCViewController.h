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
#import "SnapshotLayerView.h"

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
    // snapshot view
    SnapshotLayerView* snapshotView;
    
    NSFileHandle *myHandle;
    NSString *recvFile;
    NSString *recvText;

    // PlayRTC
    // 1 : 영상 + 음성 + Data Type
    // 2 : 영상 + 음성
    // 3 : 음성
    // 4 : Data
    int playrtcType;
    BOOL ringEnable;
    NSString* videoCodec;
    NSString* audioCodec;
    
    // 로깅 관련
    NSString* prevText;
    BOOL hasPrevText;
    
    // 채널 서비스 연결 여부 
    BOOL isChannelConnected;
    
    // v2.2.8 카메라 영상 회전 각도 표시 
    UILabel* degreelb;
    
}
@property (assign) int playrtcType;
@property (assign) BOOL ringEnable;
@property (nonatomic, copy) NSString* videoCodec;
@property (nonatomic, copy) NSString* audioCodec;
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
@property (nonatomic, copy)NSString* prevText;
@property (nonatomic, copy)NSString *recvFile;
@property (nonatomic, copy)NSString *recvText;

- (void)closeViewController;

#pragma mark - ChannelViewListener
/**
 * 채널 팝업에서 채널 생성 요청 버튼을 클릭 한 경우
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
/**
 * 채널 팝업에서 채널 입장 요청 버튼을 클릭 한 경우
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickConnectChannel:(NSString*)chId userId:(NSString*)userId;


// // PlayRTC의 enableAudioSession를 사용하지 않고 직접 하려면 아래 소스를 사용하세요.
- (void)didSessionRouteChange:(NSNotification *)notification;
@end

#endif


