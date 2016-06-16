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

/**
 * PlayRTC 인스턴스를 생성하고, PlayRTC객체의 이벤트 처리를 위해 PlayRTCObserver 인터페이스를 구현
 * PlayRTC 구현 방법
 *
 * 1. 영상 출력을 위한 PlayRTCVideoView 생성
 *    - (void)createMainView:(CGRect)frame;
 *      PlayRTCViewController_UILayout.m
 *
 * 2. PlayRTCConfig 생성
 *    - (PlayRTCConfig*)createPlayRTCConfiguration;
 *      PlayRTCViewController_PlayRTC.m
 *
 * 3. PlayRTC 인스턴스를 생성
 *   PlayRTCConfig, PlayRTCObserver 구현체 전달
 *   -(void)createPlayRTCHandler;
 *    PlayRTCViewController_PlayRTC.m
 *
 *
 * 4. 채널 서비스에 채널 생성/입장 요청 -> ChannelView 팝업에서 채널 생성 또는 입장 버튼 리스너 ChannelViewListener 구현
 *  - 채널 생성 후 입장하는 USER-A
 *     - ChannelViewListener#onClickCreateChannel
 *       PlayRTCViewController.m
 *     - (void)createChannel:(NSString*)channelName userId:(NSString*)userId;
 *       PlayRTCViewController_PlayRTC.m
 *  - 생성 된 채널에 입장하는 USER-B
 *     - ChannelViewListener#onClickConnectChannel
 *       PlayRTCViewController.m
 *     - (void)connectChannel:(NSString*)chId userId:(NSString*)userId
 *       PlayRTCViewController_PlayRTC.m
 *
 * 6. 채널 서비스에 채널 생성/입장 성공 이벤트 확인 : Channel-ID 확인
 *   - (void)onConnectChannel:(PlayRTC*)obj channelId:(NSString*)chId reason:(NSString*)reason;
 *      PlayRTCViewController_PlayRTC.m
 *      채널을 생성한 경우에 신규 발급된 channelId로 다른 사용자가 채널에 입장해야한다.
 *
 * 7. 로컬 미디어 처리를 위한 PlayRTCMedia 수신 이벤트 처리
 *   -(void)onAddLocalStream:(PlayRTC*)obj media:(PlayRTCMedia*)media
 *     PlayRTCViewController_PlayRTC.m
 *     PlayRTCMedia 수신 시 영상 출력을 위해 PlayRTCVideoView의 renderer 인터페이스 등록
 *     PlayRTCMedia#setVideoRenderer(PlayRTCVideoView의#getVideoRenderer());
 *
 * 8. P2P 연결 시 상대방 미디어 처리를 위한 PlayRTCMedia 수신 이벤트 처리
 *   -(void)onAddRemoteStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid media:(PlayRTCMedia*)media;
 *     PlayRTCViewController_PlayRTC.m
 *     PlayRTCMedia 수신 시 영상 출력을 이해 PlayRTCVideoView의 renderer 인터페이스 등록
 *     PlayRTCMedia#setVideoRenderer(PlayRTCVideoView의#getVideoRenderer());
 *
 * 9. Data 송수신을 위한  PlayRTCData 수신 이벤트 처리 -> 데이터 채널 사용 설정 시
 *   -(void)onAddDataStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(PlayRTCData*)data;
 *     PlayRTCViewController_PlayRTC.m
 *   PlayRTCData 수신 시 수신 이벤트 처리를 이해 PlayRTCDataObserver를 구현한 PlayRTCDataChannelHandler 등록
 *     PlayRTCDataChannelHandler#setDataChannel(data);
 *
 * 10. 채널(P2P) 연결 종료
 *   채널연결을 종료하면 P2P연결 시 P2P연결도 간이 종료된다.
 *   - USER-A 채널 퇴장
 *     USER-A가  PlayRTC#disconnectChannel을 호출하면 PlayRTCObserver#onDisconnectChannel 콜백 함수가 호출(P2P 내부 객체 해제)된다.
 *     - (void)disconnectChannel;
 *       PlayRTCViewController_PlayRTC.m
 *     -(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason;
 *       PlayRTCViewController_PlayRTC.m, reason="disconnect"
 *     USER-B는 PlayRTCObserver#onOtherDisconnectChannel 콜백 함수가 호출됨(채널에 남아 있으므로 새로운 사용자가 채널에 입장하념 P2P 연결됨).
 *     -(void)onOtherDisconnectChannel:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
 *       PlayRTCViewController_PlayRTC.m, reason="disconnect"
 *
 *   - USER-A 채널 종료
 *     USER-A가 PlayRTC#deleteChannel을 호출하면 모든 사용자는 PlayRTCObserver#onDisconnectChannel 콜백 함수가 호출(P2P 내부 객체 해제)된다.
 *     - (void)deleteChannel;
 *       PlayRTCViewController_PlayRTC.m
 *     -(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason;
 *       PlayRTCViewController_PlayRTC.m, reason="delete"
 *
 */
@interface PlayRTCViewController(PlayRTC)

/*
 PlayRTC 관련 인스턴스 해제
 */
- (void)closePlayRtc;

// SDK 설정 객체인 PlayRTCConfig를 생성한 후 PlayRTC 인스턴스를 생성.
- (void)createPlayRTCHandler;

/*
 * PlayRTCConfig 인스턴스 생성
 * playrtcType
 * 1. 영상, 음성, p2p data
 * 2. 영상, 음성
 * 3. 음성, only
 * 4. p2p data only
 */
- (PlayRTCConfig*)createPlayRTCConfiguration;

/**
 * 채널 서비스에 채널 생성 요청, 채널이 생성되면 채널에 입장
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)createChannel:(NSString*)channelName userId:(NSString*)userId;

/**
 * 채널 입장 요청
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)connectChannel:(NSString*)channelId userId:(NSString*)userId;

/**
 * 입장해 있는 채널에서 퇴장시킨다.
 * 채널에서 퇴장하는 사용자는 onDisconnectChannel
 * 채널에 있는 다른 시용자는 onOtherDisconnectChannel 이벤트를 받는다.
 * onOtherDisconnectChannel이 호출 되는 상대방 사용자는 채널 서비스에 입장해 있는 상태이므로,
 * 새로운 사용자가 채널에 입장하면 P2P연결을 할 수 있다.
 */
- (void)disconnectChannel;

/**
 * 입장해 있는 채널을 닫는다.
 * 채널 종료를 호출하면 채널에 있는 모든 사용자는 onDisconnectChannel이 호출된다.
 * onDisconnectChannel이 호출되면 PlayRTC 인스턴스는 더이상 사용할 수 없다.
 * P2P를 새로 연결하려면 PlayRTC 인스턴스를 다시 생성하여 채널 서비스에 입장해야 한다.
 */
- (void)deleteChannel;

/*
 * PlayRTCData 사용 시 텍스트 데이터를 전송한다.
 */
- (void)sendDataChannelText;

/*
 * PlayRTCData 사용 시 Binary 데이터를 전송한다.
 */
- (void)sendDataChannelBinary;

/*
 * PlayRTCData 사용 시 File 데이터를 전송한다.
 */
- (void)sendDataChannelFile;

/**
 * 전/후방 카메라 전환
 * 채널에 연결이 되어 있어야 동작한다.
 */
- (void)switchCamera;

/**
 * 후방 카메라 플래쉬 On/Off 전환
 * 후방 카메라 사용중에만 동작한다.
 */
- (void)switchFlash;
/**
 * 음성 Speaker 출력 시 Loud-Speaker <-> Ear-Speaker 전환 
 */
- (BOOL)switchLoudSpeaker;
/**
 * Local PlayRTCVideoView Snapshot 이미지 생성
 * 이미지 크기는 View Size와 동일
 */
- (void)localViewSnapshot;

/**
 * Remote PlayRTCVideoView Snapshot 이미지 생성
 * 이미지 크기는 View Size와 동일
 */
- (void)remoteViewSnapshot;
////////////////////////////////////////////////////////

@end
#endif
