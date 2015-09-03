//
//  Sample2PlayRTC.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 5. 6..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample2PlayRTC_h__
#define __Sample2PlayRTC_h__

#import <Foundation/Foundation.h>
#import "PlayRTCFactory.h"
#import "PlayRTCVideoView.h"
#import "PlayRTCMedia.h"
#import "PlayRTCServiceHelperListener.h"
#import "PlayRTCObserver.h"

#import "ExTextView.h"


@interface Sample2PlayRTC : NSObject<PlayRTCObserver>
{
    BOOL isConnect;
    PlayRTC* playRTC;
    NSString* channelId;
    NSString* channelName;
    NSString* token;
    NSString* userUid;
    NSString* userPid;
    NSString* otherPeerId;
    NSString* otherPeerUid;
    PlayRTCVideoView* localVideoView;
    PlayRTCVideoView* remoteVideoView;
    CGSize _localVideoSize;
    CGSize _remoteVideoSize;
    
    __weak PlayRTCMedia* localMedia;
    __weak PlayRTCMedia* remoteMedia;
    __weak ExTextView* logView;
    __weak ExTextView* dataView;
    __weak id controller;
    
}
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, copy) NSString* channelName;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userUid;
@property (nonatomic, copy) NSString* userPid;
@property (nonatomic, copy) NSString* otherPeerId;
@property (nonatomic, copy) NSString* otherPeerUid;
@property (nonatomic, strong) PlayRTC* playRTC;
@property (nonatomic, strong) PlayRTCVideoView* localVideoView;
@property (nonatomic, strong) PlayRTCVideoView* remoteVideoView;
@property (nonatomic, weak) PlayRTCData* dataChannel;
@property (nonatomic, weak) PlayRTCMedia* localMedia;
@property (nonatomic, weak) PlayRTCMedia* remoteMedia;
@property (nonatomic, weak) ExTextView* logView;
@property (nonatomic, weak) ExTextView* dataView;
@property (nonatomic, weak) id controller;

+(NSString*)getPlayRTCStatusString:(PlayRTCStatus)status;
+(NSString*)getPlayRTCCodeString:(PlayRTCCode)code;

+(PlayRTCSettings*)createConfiguration;

-(id)initWithSettings:(PlayRTCSettings*)settings;
/**
 * AVAudioSession 제어 기능을 활성화 시키는 인터페이스
 * @return BOOL, 서비스 실패 시 false
 */
- (BOOL)enableAudioSession;
/**
 * 음성을 출력하는 Speaker를 지정하는 인터페이스
 * enableAudioSession를 호출하여 AudioSession Manager를 활성화 시켜야 한다.
 * @param enable BOOL, TRUE 지정 시 외부 Speaker로 소리가 출력되고, FALSE 시 EAR-Speaker로 출력. 기본은 EAR-Speaker
 * @return BOOL, 서비스 호출 실패 시 false
 */
- (BOOL)setLoudspeakerEnable:(BOOL)enable;

- (void)createChannel:(NSString*)chName userId:(NSString*)userId;
- (void)connectChannel:(NSString*)chId userId:(NSString*)userId;
- (void)disconnectChannel;
- (void)deleteChannel;

- (void)userCommand:(NSString*)peerId command:(NSString*)command;
- (void)getChannelList:(id<PlayRTCServiceHelperListener>)listener;

#pragma mark - PlayRTCDataObserver
// PlayRTCObserver 인터페이스, PlayRTC의 주요 상태를 전달 받는다.
// PlayRTC의 createChannel/connectChannel을 호출한 결과를 받는다.
-(void)onConnectChannel:(PlayRTC*)obj channelId:(NSString*)channelId reason:(NSString*)reason;
// 상대방의 연결 요청을 받는다.
-(void)onRing:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
// 상대방의 연결 요청에 대한 수락 시
-(void)onAccept:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
// 상대방의 연결 요청에 대한 거부 시
-(void)onReject:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
// 상대방이 User-Defined Command를 보냈을 때 데이터 가공없이 그대로 받는다.
-(void)onUserCommand:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(NSString*)data;
// 단말기의 영상/음성 미디어 객체가 생성됐을 때
-(void)onAddLocalStream:(PlayRTC*)obj media:(PlayRTCMedia*)media;
// P2P 상대방의 영상/음성 미디어 객체가 생성됐을 때
-(void)onAddRemoteStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid media:(PlayRTCMedia*)media;
// 데이터 통신을 위한 Data Channel 객체가  생성됐을 때
-(void)onAddDataStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(PlayRTCData*)data;
// 채널 서비스에서 퇴장을 알리는 이벤트를 받을 때. deleteChannel 또는 자신이 disconnectChannel를 호출한 경우
-(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason;
// 상대방이 채널에서 퇴장할 때. 상대방이 disconnectChannel를 호출한 경우
-(void)onOtherDisconnectChannel:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
// PlayRTC에서 오류가 발생 시
-(void)onError:(PlayRTC*)obj status:(PlayRTCStatus)status code:(PlayRTCCode)code desc:(NSString*)desc;
// PlayRTC의 주요 상태 변경 이벤트
-(void)onStateChange:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid status:(PlayRTCStatus)status desc:(NSString*)desc;

@end

#endif
