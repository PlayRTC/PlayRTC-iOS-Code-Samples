//
//  PlayRTCViewController_PlayRTC.m
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayRTCViewController_PlayRTC.h"
#import "PlayRTCDataObserver.h"
#import "PlayRTCDataSendObserver.h"
#define LOG_TAG @"PlayRTCViewController"

#define TDCProjectId    @"60ba608a-e228-4530-8711-fa38004719c1"
#define TDCLicense      @"1"

uint64_t startElapsed;

// 상대방으로부터 Ring 요청을 받았을 때 사용자의 허락 여부를 붇기 위한 다이얼로그 관련 Delegate
@class RingAlertViewDelegate;
RingAlertViewDelegate* alertDelegate;

@interface RingAlertViewDelegate : NSObject<UIAlertViewDelegate>
{
    __weak PlayRTC* playRTC;
    NSString* tagetId;
}
@property (weak, nonatomic) PlayRTC* playRTC;
@property (strong, nonatomic) NSString* tagetId;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end

// 상대방으로부터 Ring 요청을 받았을 때 사용자의 허락 여부를 묻기 위한 다이얼로그 관련 Delegate 구현
@implementation RingAlertViewDelegate
@synthesize playRTC;
@synthesize tagetId;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // accept
    if (buttonIndex == 0) {
        [self.playRTC accept:self.tagetId];
    }
    // reject
    if (buttonIndex == 1) {
        [self.playRTC reject:self.tagetId];
    }
    alertDelegate = nil;
}

- (void) dealloc {
    self.playRTC = nil;
    self.tagetId = nil;
}
@end

/*
 * DataChannel의 Send dlqpsxm (PlayRTCDataSendObserver)를 받기 위한 객체 정의
 * PlayRTCDataSendObserver 인터페이스 구현
 */
@class PlayRTCDataChannelSendObserver;
PlayRTCDataChannelSendObserver* dataChannelDelegate;

@interface PlayRTCDataChannelSendObserver : NSObject<PlayRTCDataSendObserver>
{
    __weak PlayRTC* playRTC;
    __weak PlayRTCViewController* viewcontroller;
}
@property (weak, nonatomic) PlayRTC* playRTC;
@property (weak, nonatomic) PlayRTCViewController* viewcontroller;
// 데이터 전송 진행 상태를 받기 위한 인터페이스
-(void)onSending:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId size:(uint64_t)size send:(uint64_t)send index:(int)index count:(int)count;
// 데이터 전송 완료 상태를 받기 위한 인터페이스
-(void)onSendSuccess:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId size:(uint64_t)size;
// 데이터 전송 실패 상태를 받기 위한 인터페이스
-(void)onSendError:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId code:(PlayRTCDataCode)code desc:(NSString*)desc;

@end

/*
 * PlayRTCObserver와 PlayRTCDataObserver를 구현한 객체
 */
@interface PlayRTCViewController(PlayRTC_internal)<PlayRTCObserver, PlayRTCDataObserver, PlayRTCStatsReportObserver>

- (NSString*)getPlayRTCStatusString:(PlayRTCStatus)status;
- (NSString*)getPlayRTCCodeString:(PlayRTCCode)code;

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

// PlayRTCDataObserver 인터페이스, PlayRTCData의 주요 상태를 전달 받는다.
// 상대방이 전송한 데이터를 처음 수신할 경우 데이터의 헤더정보를 읽어 알려준다.
-(void)onDataReady:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header;
// 수신 데이터 진척 상황을 전달
-(void)onProgress:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header recvSize:(uint64_t)recvSize data:(NSData*)data;
// 수신 완료 시
-(void)onFinishLoading:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header;
//  PlayRTCData 오류 발생 시
-(void)onError:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId code:(PlayRTCDataCode)code desc:(NSString*)desc;
// PlayRTCData의 주요 상태를 전달 받는다.
-(void)onStateChange:(PlayRTCData*)obj peerId:(NSString*)peerId  peerUid:(NSString*)peerUid state:(PlayRTCDataStatus)state;

//PlayRTCStatsReportObserver
-(void)onStatsReport:(PlayRTCStatReport*)report;
-(id)formatFileSize:(int)value;

@end

@implementation PlayRTCViewController(PlayRTC)

#pragma mark - PlayRTCViewController(PlayRTC)


-(void)createPlayRTCHandler
{
    /*
    // v1.1.0
    // PlayRTCSettings 생성 및 설정
    PlayRTCSettings* settings = [self createPlayRTCSettings];
    self.playRTC = [PlayRTCFactory newInstance:settings observer:(id<PlayRTCObserver>)self];
    */
    // v2.2.0
    // PlayRTCConfig 생성 및 설정
    PlayRTCConfig* config = [self createPlayRTCConfiguration];
    self.playRTC = [PlayRTCFactory createPlayRTC:config observer:(id<PlayRTCObserver>)self];

    
}

/*
 * PlayRTCSettings 인스턴스 생성
 * sdk 1/1/0
 */
- (PlayRTCSettings*)createPlayRTCSettings
{
    PlayRTCSettings* settings = [[PlayRTCSettings alloc] init];
    [settings setTDCProjectId:TDCProjectId];
    [settings setTDCLicense:TDCLicense];
    [settings.channel setRing:FALSE];
    
    // PlayRTC 서비스의 TURN 서버 이외의 외부 TURN을 사용할 경우 아래와 같이 지정
    //[settings.iceServers resetIceServer:@"turn:IP:PORT" username:@"USER-ID" credential:@"PASSWORD"];
    
    
    /**
     * playrtcType : int Sample App 유형
     *      1: 영상 + 음성 + Data
     *      2: 영상 + 음성
     *      3: 음성 Only
     *      4: Data Only
     */
    if(self.playrtcType == 1) {
        //영상 + 음성 + Data
        [settings setVideoEnable:TRUE];
        [settings setAudioEnable:TRUE];
        [settings setDataEnable:TRUE];
        [settings.video setFrontCameraEnable:TRUE]; // 전면 카메라 사용, Default
        [settings.video setBackCameraEnable:FALSE]; // 후면 카메라 시용
    }
    else if(self.playrtcType == 2) {
        // 영상 + 음성
        [settings setVideoEnable:TRUE];
        [settings setAudioEnable:TRUE];
        [settings setDataEnable:FALSE];
        [settings.video setFrontCameraEnable:TRUE];
        [settings.video setBackCameraEnable:FALSE];
    }
    else if(self.playrtcType == 3) {
        // 음성 Only
        [settings setVideoEnable:FALSE];
        [settings setAudioEnable:TRUE];
        [settings setDataEnable:FALSE];
        [settings.video setFrontCameraEnable:FALSE];
        [settings.video setBackCameraEnable:FALSE];
    }
    else {
        // Data Only
        [settings setVideoEnable:FALSE];
        [settings setAudioEnable:FALSE];
        [settings setDataEnable:TRUE];
        [settings.video setFrontCameraEnable:FALSE];
        [settings.video setBackCameraEnable:FALSE];
    }
    [settings.log.console setLevel:LOG_TRACE];
    
    return settings;
    
}

/*
 * PlayRTCSettings 인스턴스 생성
 * sdk 1/1/0
 */
- (PlayRTCConfig*)createPlayRTCConfiguration
{
    PlayRTCConfig* config = [PlayRTCFactory createConfig];
    [config setProjectId:TDCProjectId];
    [config setRingEnable:FALSE];
    
    if(self.playrtcType == 1) {
        [config.video setEnable:TRUE];
        [config.video setCameraType:CameraTypeFront];
        // sdk support only 640x480
        [config.video setMaxFrameSize:640 height:640];
        [config.video setMinFrameSize:640 height:480];
        [config.video setMaxFrameRate:30];
        [config.video setMinFrameRate:15];
        [config.bandwidth setVideoBitrateKbps:2500];
        
        [config.audio setEnable:TRUE];
        [config.bandwidth setAudioBitrateKbps:35];
        [config.audio setEchoCancellationEnable:TRUE];
        [config.audio setAutoGainControlEnable:TRUE];
        [config.audio setNoiseSuppressionEnable:TRUE];
        [config.audio setHighpassFilterEnable:TRUE];
        
        [config.data setEnable:TRUE];
        
    }
    else if(self.playrtcType == 2) {
        [config.video setEnable:TRUE];
        [config.video setCameraType:CameraTypeFront];
        // sdk support only 640x480
        [config.video setMaxFrameSize:640 height:640];
        [config.video setMinFrameSize:640 height:480];
        [config.video setMaxFrameRate:30];
        [config.video setMinFrameRate:15];
        [config.bandwidth setVideoBitrateKbps:2500];
        
        [config.audio setEnable:TRUE];
        [config.bandwidth setAudioBitrateKbps:35];
        [config.audio setEchoCancellationEnable:TRUE];
        [config.audio setAutoGainControlEnable:TRUE];
        [config.audio setNoiseSuppressionEnable:TRUE];
        [config.audio setHighpassFilterEnable:TRUE];
        
        [config.data setEnable:FALSE];
    }
    else if(self.playrtcType == 3) {
        [config.video setEnable:FALSE];
        
        [config.audio setEnable:TRUE];
        [config.bandwidth setAudioBitrateKbps:35];
        [config.audio setEchoCancellationEnable:TRUE];
        [config.audio setAutoGainControlEnable:TRUE];
        [config.audio setNoiseSuppressionEnable:TRUE];
        [config.audio setHighpassFilterEnable:TRUE];
        
        [config.data setEnable:FALSE];
    }
    else {
        [config.video setEnable:TRUE];
        [config.audio setEnable:TRUE];
        [config.data setEnable:TRUE];
    }
    [config.log.console setLevel:LOG_TRACE];
    
    return config;
}
/*
 * PlayRTCData 사용 시 텍스트 데이터를 전송한다.
 */
- (void)sendDataChannelText
{
    if(self.dataChannel != nil && [self.dataChannel getStatus] == PlayRTCDataStatusOpen)
    {
        // 전송 상태를 받기 위한 리스너 인터페이스 생성
        dataChannelDelegate = [[PlayRTCDataChannelSendObserver alloc] init];
        dataChannelDelegate.playRTC = self.playRTC;
        dataChannelDelegate.viewcontroller = self;
        
        // 전송 할 데이터
        NSString* sendData = @"DataChannel 한글 Text...";
        [self.dataChannel sendText:sendData observer:dataChannelDelegate];
    }
}

/*
 * PlayRTCData 사용 시 Binary 데이터를 전송한다.
 */
- (void)sendDataChannelBinary
{
    if(self.dataChannel != nil && [self.dataChannel getStatus] == PlayRTCDataStatusOpen)
    {
        // 전송 상태를 받기 위한 리스너 인터페이스 생성
        dataChannelDelegate = [[PlayRTCDataChannelSendObserver alloc] init];
        dataChannelDelegate.playRTC = self.playRTC;
        dataChannelDelegate.viewcontroller = self;
        
        // 전송 할 데이터
        NSString* sendText = @"DataChannel Text";
        NSData* sendData = [sendText dataUsingEncoding:NSUTF8StringEncoding];
        [self.dataChannel sendByte:sendData mimeType:nil observer:dataChannelDelegate];
    }
}

/*
 * PlayRTCData 사용 시 File 데이터를 전송한다.
 */
- (void)sendDataChannelFile
{
    if(self.dataChannel != nil && [self.dataChannel getStatus] == PlayRTCDataStatusOpen)
    {
        // 전송 상태를 받기 위한 리스너 인터페이스 생성
        dataChannelDelegate = [[PlayRTCDataChannelSendObserver alloc] init];
        dataChannelDelegate.playRTC = self.playRTC;
        dataChannelDelegate.viewcontroller = self;
        
        // 전송 할 데이터, Resource의 파일을 전달
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"playrtc_icon_128.png"];
        startElapsed = [[NSDate date] timeIntervalSince1970] *1000;
        [self.dataChannel sendFileData:filePath observer:dataChannelDelegate];
    }
    
}
#pragma mark - PlayRTC Methods
/**
 * 채널 서비스에 채널 생성 요청
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)createChannel:(NSString*)channelName userId:(NSString*)userId
{
    startElapsed = 0;
    if(self.playRTC == nil) {
        return;
    }
    /*
     * 채널 및 사용자 관련 부가 정보 정의
     */
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if(channelName != nil) {
        NSDictionary * channel = [NSDictionary dictionaryWithObject:channelName forKey:@"channelName"];
        [parameters setObject:channel forKey:@"channel"];
    }
    if(userId != nil) {
        self.userUid = userId;
        NSDictionary * peer = [NSDictionary dictionaryWithObject:userId forKey:@"uid"];
        [parameters setObject:peer forKey:@"peer"];
    }
    NSLog(@"[PlayRTCViewController] createChannel channelName[%@] userId[%@]", channelName, userId);
    
    [self.playRTC createChannel:parameters];
}

/**
 * 채채널 입장 요청
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)connectChannel:(NSString*)chId userId:(NSString*)userId
{
    startElapsed = 0;
    if(self.playRTC == nil) {
        return;
    }
    if(chId != nil) {
        self.channelId = chId;
    }
    /*
     * 사용자 관련 부가 정보 정의
     */
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if(userId != nil) {
        self.userUid = userId;
        NSDictionary * peer = [NSDictionary dictionaryWithObject:userId forKey:@"uid"];
        [parameters setObject:peer forKey:@"peer"];
    }
    NSLog(@"[PlayRTCViewController] connectChannel channelId[%@] userId[%@]", chId, userId);
    [self.playRTC connectChannel:self.channelId parameters:parameters];
}
/**
 * 특정 사용자를 채널에서 퇴장시킨다.
 * 채널에서 퇴장하는 사용자는 onDisconnectChannel
 * 채널에 있는 다른 시용자는 onOtherDisconnectChannel 이벤트를 받는다.
 * peerId : NSString, PlayRTC 서비스에서 발급한 사용자 아이디
 */
- (void)disconnectChannel:(NSString*)peerId
{
    if(self.playRTC == nil) {
        PlayRTCViewController* viewcontroller = (PlayRTCViewController*)[self.navigationController popViewControllerAnimated:TRUE];
        viewcontroller = nil;
        return;
    }
    [self.playRTC disconnectChannel:peerId];
}

/**
 * 입장해 있는 채널을 닫는다.
 * 채널에 있는 모든 시용자는 onDisconnectChannel 이벤트를 받는다.
 */
- (void)deleteChannel
{
    // 이미 사용을 끝냈으면 바로 이전 화면 이동
    if(self.playRTC == nil) {
        PlayRTCViewController* viewcontroller = (PlayRTCViewController*)[self.navigationController popViewControllerAnimated:TRUE];
        viewcontroller = nil;
        return;
    }
    
    // 채널을 닫는다.
    [self.playRTC deleteChannel];
}

- (void)switchCamera
{
    if(self.playRTC == nil) {
        
        return;
    }
    
    [self.playRTC switchCamera];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
//

#pragma mark - PlayRTCObserver

/*
 * createChannel/connectChannel 성공 시 호출 됨
 * obj : PlayRTC 인스턴스
 * chId : NSString, 채널 아이디
 * reason : NSString, createChannel의 경우 "create" , connectChannel의 경우 "connect"
 */
-(void)onConnectChannel:(PlayRTC*)obj channelId:(NSString*)chId reason:(NSString*)reason
{
    self.channelId = chId;
    NSLog(@"[PlayRTCViewController] onConnectChannel[%@] reason[%@]", channelId, reason);
    [self appendLogView:@"[PlayRTC] onConnectChannel..."];
    // 채널 팝업에 생성된 채널 아이디를 넘겨 표시하고, 창을 숨긴다.
    [channelPopup setChannelId:self.channelId];
    [channelPopup hide];
}

/*
 * 상대방의 연결 요청을 빋는 경우 호출 됨
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onRing:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    self.ringPid = peerId;
    alertDelegate = [[RingAlertViewDelegate alloc] init];
    alertDelegate.playRTC = self.playRTC;
    alertDelegate.tagetId = peerId;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"%@님이 연결을 요청하였습니다.", peerUid]
                                                   delegate:alertDelegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"연결",@"거절", nil];
    [alert show];
    
}

/*
 * 상대방의 연결 요청의 승락을 받은 경우 호출됨
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onAccept:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    NSLog(@"[PlayRTCViewController] onAccept peerId[%@] peerUid[%@]", peerId, peerUid);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onAccept peerId[%@]...", peerId]];
}

/*
 * 상대방의 연결 요청의 거부을 받은 경우 호출됨.
 * 채널 퇴장의 과정을 직접 수행해야 한다. 샘플에서는 채널 종료 버튼을 눌러 종료 처리
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onReject:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    NSLog(@"[PlayRTCViewController] onReject peerId[%@] peerUid[%@]", peerId, peerUid);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onReject peerId[%@]...", peerId]];
}

/*
 * 상대방의 사용자 정의 문자열을 수신한 경우 호출됨
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 * data : NSString, 앱에서 정의한 데이터 문자열
 */
-(void)onUserCommand:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(NSString*)data
{
    NSLog(@"[PlayRTCViewController] onUserCommand peerId[%@] peerUid[%@] data[%@]", peerId, peerUid, data);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onUserCommand data[%@]",  data]];
}

/*
 * 단말기의 미디어 객체가 생성됐을 때 호출됨, 영상의 경우 영상 출력 처리를 해야 한다.
 * obj : PlayRTC 인스턴스
 * media : PlayRTCMedia
 */
-(void)onAddLocalStream:(PlayRTC*)obj media:(PlayRTCMedia*)media
{
    NSLog(@"[PlayRTCViewController] onAddLocalStream media[%@]",  media);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onAddLocalStream ..."]];
    self.localMedia = media;
    // 영상 스트림이 있다면..
    if(self.localVideoView != nil && [self.localMedia hasVideoStream]) {
        // 영상 출력 처리
        // PlayRTCVideoView객체의 Renderer를 전달하여 로컬 영상 프레임을 출력하도록한다.
        [self.localMedia setVideoRenderer:[self.localVideoView getVideoRenderer]];
    }
    
}

/*
 * 상대방의 미디어 객체가 생성됬을 때 호출됨, 영상의 경우 영상 출력 처리를 해야 한다.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 * media : PlayRTCMedia
 */
-(void)onAddRemoteStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid media:(PlayRTCMedia*)media
{
    NSLog(@"[PlayRTCViewController] onAddRemoteStream peerId[%@] peerUid[%@] media[%@]", peerId, peerUid, media);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onAddRemoteStream ..."]];
    self.remoteMedia = media;
    // 영상 스트림이 있다면..
    if(self.remoteVideoView != nil && [self.remoteMedia hasVideoStream]) {
        // 영상 출력 처리
        // PlayRTCVideoView객체의 Renderer를 전달하여 수신받은 영상 프레임을 출력하도록한다.
        [self.remoteMedia setVideoRenderer:[self.remoteVideoView getVideoRenderer]];
    }
}

/*
 * 데이터 통신을 위한 Data Channel 객체가  생성됬을 때 호출됨
 * 전달 받은 PlayRTCData에 PlayRTCDataObserver 구현체를 등록한다.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 * data : PlayRTCData, 데이터 통신을 위한 객체
 */
-(void)onAddDataStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(PlayRTCData*)data
{
    NSLog(@"[PlayRTCViewController] onAddDataStream peerId[%@] peerUid[%@] data[%@]", peerId, peerUid, data);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onAddDataStream ..."]];
    
    
    self.dataChannel = data;
    // 데이터 통신 이벤트 수신을 위해 PlayRTCDataObserver 리스너 객체 전달
    [self.dataChannel setEventObserver:(id<PlayRTCDataObserver>)self];
}

/*
 * 채널 서비스에서 퇴장을 알리는 이벤트를 받을 때.
 * deleteChannel 또는 자신이 disconnectChannel를 호출한 경우
 * obj : PlayRTC 인스턴스
 * reason : NSString, 이벤트 종류. 자신의 채널 퇴장 시 "disconnect". 채날 종료 시 "delete"
 */
-(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason
{
    NSLog(@"[PlayRTCViewController] onDisconnectChannel reason[%@]", reason);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onDisconnectChannel reason[%@]", reason]];
    
    NSString* msg = nil;
    if([reason isEqualToString:@"disconnect"])
    {
        msg = @"PlayRTC 채널에서 퇴장하였습니다.\n확인 버튼을 누르면 이전화면으로 이동합니다.";
    }
    else
    {
        msg = @"PlayRTC 채널이 종료되었습니다.\n확인 버튼을 누르면 이전화면으로 이동합니다.";
    }
    // 확인 버튼을 부르면 이전 화면으로 이동하도록 처리
    // PlayRTCViewController.m 파일  alertView:didDismissWithButtonIndex: 에서 처리
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"채널 퇴장"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
    alert.tag = 100;
    [alert show];
}

/*
 * 상대방이 채널에서 퇴장할 때.
 * 상대방이 disconnectChannel를 호출한 경우
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 */
-(void)onOtherDisconnectChannel:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    // 상대방의 채널 퇴장을 알린다.
    // PlayRTC를 종료하려면 자신도 채널 퇴장)disconnectChannel)하거나 채널 종료(deleteChannel)를시켜야한다.
    NSLog(@"[PlayRTCViewController] onOtherDisconnectChannel peerId[%@] peerUid[%@]", peerId, peerUid);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onOtherDisconnectChannel peerId[%@]", peerId]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"[%@]가 채널에서 퇴장하였습니다....\n기능버튼 Close을 눌러 PlayRTC를 종료세요.", peerUid]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
    [alert show];
    
}

/*
 * PlayRTC에서 오류가 발생 시
 * obj : PlayRTC 인스턴스
 * status : PlayRTCStatus, 상태 정의 코드
 * code : PlayRTCCode, 오츄 정의 코드
 * desc : NSString, description
 */
-(void)onError:(PlayRTC*)obj status:(PlayRTCStatus)status code:(PlayRTCCode)code desc:(NSString*)desc
{
    NSLog(@"[PlayRTCViewController] onError status[%@] code[%@] desc[%@]",
          [self getPlayRTCStatusString:status], // to string
          [self getPlayRTCCodeString:code], // to string
          desc);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onError status[%@] code[%@] desc[%@]",
                         [self getPlayRTCStatusString:status],
                         [self getPlayRTCCodeString:code],
                         desc]];
}

/*
 * PlayRTC의 주요 상태 변경 이벤트를 받는다.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * status : PlayRTCStatus, 상태 정의 코드
 * desc : NSString, description
 */
-(void)onStateChange:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid status:(PlayRTCStatus)status desc:(NSString*)desc
{
    NSLog(@"[PlayRTCViewController] onStateChange peerId[%@] peerUid[%@] status[%@] desc[%@]", peerId, peerUid, [self getPlayRTCStatusString:status], desc);
    if(status == PlayRTCStatusPeerSuccess) {
        // 5 sec
        [obj startStatsReport:5000 observer:(id<PlayRTCStatsReportObserver>)self];
    }
}

-(void)onStatsReport:(PlayRTCStatReport*)report
{
    RatingValue* rttRating = [report getRttRating];
    RatingValue* localVideoFl = [report getLocalVideoFractionLost];
    RatingValue* localAudioFl = [report getLocalAudioFractionLost];
    RatingValue* remoteVideoFl = [report getRemoteVideoFractionLost];
    RatingValue* remoteAudioFl = [report getRemoteAudioFractionLost];
    
    NSString* localReport = [NSString stringWithFormat:@"\nLocal Report\n    ICE:[%@]\n    %dx%dx%d\n    %@ps\n    RTT:%d\n    RTT-Ratting:[%d/%.6f]\n    VFractionLost:[%d/%.6f]\n    AFractionLost:[%d/%.6f]",
                            [report getLocalCandidate],
                            [report getLocalFrameWidth],
                            [report getLocalFrameHeight],
                            [report getLocalFrameRate],
                            [self formatFileSize:[report getAvailableSendBandwidth]],
                            [report getRtt],
                            [rttRating getLevel],
                            [rttRating getValue],
                            [localVideoFl getLevel],
                            [localVideoFl getValue],
                            [localAudioFl getLevel],
                            [localAudioFl getValue]];
    
    NSString* remoteReport = [NSString stringWithFormat:@"\nRemote Report\n    ICE:%@\n    %dx%dx%d\n    %@ps\n    VFractionLost:[%d/%.6f]\n    AFractionLost:[%d/%.6f]\n",
                            [report getRemoteCandidate],
                            [report getRemoteFrameWidth],
                            [report getRemoteFrameHeight],
                            [report getRemoteFrameRate],
                            [self formatFileSize:[report getAvailableReceiveBandwidth]],
                            [remoteVideoFl getLevel],
                            [remoteVideoFl getValue],
                            [remoteAudioFl getLevel],
                            [remoteAudioFl getValue]];

    
    
    
    NSLog(@"[PlayRTCViewController] \n%@%@%@%@",
          @"Stat Report ================================",
          localReport,
          remoteReport,
          @"Stat Report ================================");

}

- (id)formatFileSize:(int)value
{
    
    double convertedValue = (double)(value * 1.0f);
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}
/////////////////////////////////////////////////////////////////////////////
#pragma mark - PlayRTCDataObserver
/*
 * 상대방이 전송한 데이터를 처음 수신할 경우 데이터의 헤더정보를 읽어 알려준다.
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * header : PlayRTCDataHeader, 데이터 정보
 *  - index : int, 데이터 패킷 분할 전송 index
 *  - count : int, 데이터 패킷 분할 count
 *  - size : uint64_t, 데이터 전체 크기
 *  - id : uint64_t, 전송하는 데이터의 고유 아이디
 *  - dataType : int, text 0, binary 1
 *  - fileName : NSString, 파일 전송일 경우 파일 명
 *  - mimeType : NSString, 파일 전송일 경우 파일의 Mime Type
 */
-(void)onDataReady:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header
{
    // 수신 경과 시간을 측정하기 위해 사용.
    startElapsed = [[NSDate date] timeIntervalSince1970] *1000;
    NSString* dataType = [header isBinary]?@"binary":@"text";
    NSLog(@"[PlayRTCViewController] DataChannel onDataReady peerId[%@] peerUid[%@] dataType[%@] recvSize[%lld]", peerId, peerUid, dataType, header.getSize);
    [self appendLogView:[NSString stringWithFormat:@"DataChannel onReceive start..."]];
    
    // 파일 전송일 경우 : binary and file-name
    if([header getType] == DC_DATA_TYPE_BINARY && ( [header getFileName] != nil && ((NSString*)[header getFileName]).length > 0) ) {
        
        //파일 저장 폴더
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        // 저장 폴더 + 헤더에 파일 이름을 조합하여 저장 파일 사용. 파일이름에는 경로 정보가 없다.
        NSString* sFileName = [header getFileName];
        self.recvFile = [documentsDirectory stringByAppendingPathComponent:sFileName];
        [self appendLogView:[NSString stringWithFormat:@"Data File[%@]", self.recvFile]];
        
        // 같은 이름이 존재한다면 삭제.
        if([[NSFileManager defaultManager] fileExistsAtPath:self.recvFile]) {
            NSLog (@"Output file  exist, delete ...");
            [[NSFileManager defaultManager] removeItemAtPath:self.recvFile error:0];
        }
        
        // 파일 생성
        NSLog (@"Output file does not exist, creating a new one");
        [[NSFileManager defaultManager] createFileAtPath:self.recvFile contents:nil attributes:nil];
        
        myHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.recvFile];
        
    }
}

/*
 * 수신 데이터 진척 상황을 전달
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * header : PlayRTCDataHeader, 데이터 정보
 *  - index : int, 데이터 패킷 분할 전송 index
 *  - count : int, 데이터 패킷 분할 count
 *  - size : uint64_t, 데이터 전체 크기
 *  - id : uint64_t, 전송하는 데이터의 고유 아이디
 *  - dataType : int, text 0, binary 1
 *  - fileName : NSString, 파일 전송일 경우 파일 명
 *  - mimeType : NSString, 파일 전송일 경우 파일의 Mime Type
 * recvSize : uint64_t, 수신 데이터 누적 크기
 * data : NSData, 수신 데이터
 */
-(void)onProgress:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header recvSize:(uint64_t)recvSize data:(NSData*)data
{
    // 진척율 계산을 위해
    uint64_t total = [header getSize];
    float per = ((float)(recvSize*1.0f)/(float)(total*1.0f)) * 100.0f;
    NSString* sMsg = [NSString stringWithFormat:@"[DataChannel] Progress [%d/%d] [%lld/%lld]  %.2f%%", [header getIndex]+1, [header getCount], recvSize, [header getSize], per];
    
    // 수신 데이터가 텍스트 구문이라면 단순 출력
    if([header getType] == DC_DATA_TYPE_TEXT)
    {
        NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[PlayRTCViewController] DataChannel onProgress Text[%@]", dataStr);
        [self progressLogView:sMsg];
    }
    // 바이너리 인 경우
    else {
        NSLog(@"[PlayRTCViewController] DataChannel onProgress Binary[%lld/%lld]", recvSize, [header getSize]);
        [self progressLogView:sMsg];
        // 수신데이터가 파일이라면 파일 저장
        if(myHandle != nil) {
            [myHandle seekToEndOfFile];
            [myHandle writeData: data];
        }
        
    }
}

/*
 * 데이터 수신 종료
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * header : PlayRTCDataHeader, 데이터 정보
 *  - index : int, 데이터 패킷 분할 전송 index
 *  - count : int, 데이터 패킷 분할 count
 *  - size : uint64_t, 데이터 전체 크기
 *  - id : uint64_t, 전송하는 데이터의 고유 아이디
 *  - dataType : int, text 0, binary 1
 *  - fileName : NSString, 파일 전송일 경우 파일 명
 *  - mimeType : NSString, 파일 전송일 경우 파일의 Mime Type
 */
-(void)onFinishLoading:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid header:(PlayRTCDataHeader*)header
{
    int64_t endElapsed = [[NSDate date] timeIntervalSince1970] *1000 - startElapsed;
    startElapsed = 0;
    
    if([header getType] == DC_DATA_TYPE_TEXT)
    {
        NSLog(@"[PlayRTCViewController] DataChannel onFinishLoading Text...");
        [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onFinishLoading[Text]"]];
    }
    else {
        NSString* fileName = [header getFileName];
        if(fileName == nil || fileName.length ==0) {
            
            NSLog(@"[PlayRTCViewController] DataChannel onFinishLoading Binary...");
            [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onFinishLoading [Binary][%lld - %lld]", [header getSize], endElapsed]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Elapsed"
                                                                message:[NSString stringWithFormat:@"%lld", endElapsed]
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인", nil];
                [alert show];
            });
        }
        else {
            NSLog(@"[PlayRTCViewController] DataChannel onFinishLoading File[%@]", fileName);
            [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onFinishLoading [File][%lld - %lld] %@", [header getSize], endElapsed, fileName]];
            if(myHandle != nil) {
                [myHandle closeFile];
                myHandle = nil;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Elapsed"
                                                                message:[NSString stringWithFormat:@"%lld", endElapsed]
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인", nil];
                [alert show];
            });
            
        }
    }
}

/*
 * PlayRTCData 오류 발생 시
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * dataId : uint64_t, 데이터 고유 아이디
 * code : PlayRTCDataCode, 오류 코드 정의
 * desc : NSString, description
 */
-(void)onError:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId code:(PlayRTCDataCode)code desc:(NSString*)desc
{
    // 코드를 문자열로 만들어 출력
    NSString* sCode = nil;
    if(code == PlayRTCDataCodeNone)      sCode = @"PlayRTCDataCodeNone";
    else if(code == PlayRTCDataCodeNotOpend) sCode = @"PlayRTCDataCodeNotOpend";
    else if(code == PlayRTCDataCodeSendBusy) sCode = @"PlayRTCDataCodeSendBusy";
    else if(code == PlayRTCDataCodeSendFail) sCode = @"PlayRTCDataCodeSendFail";
    else if(code == PlayRTCDataCodeFileIO)   sCode = @"PlayRTCDataCodeFileIO";
    else if(code == PlayRTCDataCodeParseFail)sCode = @"PlayRTCDataCodeParseFail";
    
    NSLog(@"[PlayRTCViewController] DataChannel onError peerId[%@] peerUid[%@] code[%@] desc[%@]", peerId, peerUid, sCode, desc);
    [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onError code[%@] desc[%@]", sCode, desc]];
    
}

/*
 * PlayRTCData의 주요 상태를 전달 받는다.
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * dataId : uint64_t, 데이터 고유 아이디
 * state : PlayRTCDataCode, 상태 정의
 */
-(void)onStateChange:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid state:(PlayRTCDataStatus)state
{
    NSString* sState = nil;
    if(state == PlayRTCDataStatusNone)             sState = @"PlayRTCDataStatusNone";
    else if(state == PlayRTCDataStatusConnecting)  sState = @"PlayRTCDataStatusConnecting";
    else if(state == PlayRTCDataStatusOpen)        sState = @"PlayRTCDataStatusOpen";
    else if(state == PlayRTCDataStatusClosing)     sState = @"PlayRTCDataStatusClosing";
    else if(state == PlayRTCDataStatusClosed)     sState = @"PlayRTCDataStatusClosed";
    NSLog(@"[PlayRTCViewController] DataChannel onStateChange peerId[%@] peerUid[%@] state[%@]", peerId, peerUid, sState);
    [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onStateChange state[%@]", sState]];
    
}

/////////////////////////////////////////////////////////////////////////////

#pragma mark - PlayRTCViewController(PlayRTC_internal)


- (NSString*)getPlayRTCStatusString:(PlayRTCStatus)status
{
    if(status == PlayRTCStatusNone)
    {
        return @"PlayRTCStatusNone";
    }
    else if(status == PlayRTCStatusInitialize) /* 라이브러리 초기화 작업 단계  */
    {
        return @"PlayRTCStatusInitialize";
    }
    else if(status == PlayRTCStatusChannelStart) /* 채널 연결 준비(open) 단계 */
    {
        return @"PlayRTCStatusChannelStart";
    }
    else if(status == PlayRTCStatusChannelConnect)  /* 채널 연결(connect) 단계 */
    {
        return @"PlayRTCStatusChannelConnect";
    }
    else if(status == PlayRTCStatusLocalMedia) /* Local Media 생성  */
    {
        return @"PlayRTCStatusLocalMedia";
    }
    else if(status == PlayRTCStatusChanneling) /* 채널 입장, Channeling */
    {
        return @"PlayRTCStatusChanneling";
    }
    else if(status == PlayRTCStatusRing) /* Are you ready 단계, 연결 수락 여부를 묻거나 받은 상태 offer/answer 공통  */
    {
        return @"PlayRTCStatusRing";
    }
    else if(status == PlayRTCStatusPeerCreation) /* Peer 객체 Creation  */
    {
        return @"PlayRTCStatusPeerCreation";
    }
    else if(status == PlayRTCStatusSignaling) /* 시그널링 시그널 데이터 교환 */
    {
        return @"PlayRTCStatusSignaling";
    }
    else if(status == PlayRTCStatusPeerConnecting) /* Peer 연결 Checking 상태  */
    {
        return @"PlayRTCStatusPeerConnecting";
    }
    else if(status == PlayRTCStatusPeerDataChannel) /* Peer DataChannel 연결 */
    {
        return @"PlayRTCStatusPeerDataChannel";
    }
    else if(status == PlayRTCStatusPeerMedia) /* Peer Media 생성 */
    {
        return @"PlayRTCStatusPeerMedia";
    }
    else if(status == PlayRTCStatusPeerSuccess) /* Peer 연결 성공 */
    {
        return @"PlayRTCStatusPeerSuccess";
    }
    else if(status == PlayRTCStatusPeerConnected) /* Peer 연결 수립 상태 */
    {
        return @"PlayRTCStatusPeerConnected";
    }
    else if(status == PlayRTCStatusPeerDisconnected) /* Peer 연결 해제 */
    {
        return @"PlayRTCStatusPeerDisconnected";
    }
    else if(status == PlayRTCStatusPeerClosed) /* Peer 종료 */
    {
        return @"PlayRTCStatusPeerClosed";
    }
    else if(status == PlayRTCStatusUserCommand) /* 사용자 정의 Command & Data */
    {
        return @"PlayRTCStatusUserCommand";
    }
    else if(status == PlayRTCStatusChannelDisconnected) /* Channel 서버 연결 종료 */
    {
        return @"PlayRTCStatusChannelDisconnected";
    }
    else if(status == PlayRTCStatusClosed) /* PlayRTC 종료 */
    {
        return @"PlayRTCStatusClosed";
    }
    else if(status == PlayRTCStatusNetworkConnected) /* Network Connectivity Status connected */
    {
        return @"PlayRTCStatusNetworkConnected";
    }
    else if(status == PlayRTCStatusNetworkDisconnected) /* Network Connectivity Status disconnected */
    {
        return @"PlayRTCStatusNetworkDisconnected";
    }
    return @"";
}

- (NSString*)getPlayRTCCodeString:(PlayRTCCode)code
{
    if(code == PlayRTCCodeNone)
    {
        return @"PlayRTCCodeNone";
    }
    else if(code == PlayRTCCodeMissingParameter) /* 필수 Parameter가 없음 */
    {
        return @"PlayRTCCodeMissingParameter";
    }
    else if(code == PlayRTCCodeInvalidParameter) /* 잘못된 Parameter */
    {
        return @"PlayRTCCodeInvalidParameter";
    }
    else if(code == PlayRTCCodeVersionUnsupported) /* SDK 버전 지원하지 않음 */
    {
        return @"PlayRTCCodeVersionUnsupported";
    }
    else if(code == PlayRTCCodeNotInitialize) /* 라이브러리 초기화 실패 */
    {
        return @"PlayRTCCodeNotInitialize";
    }
    else if(code == PlayRTCCodeMediaUnsupported) /* LocalMedia 획득 실패 */
    {
        return @"PlayRTCCodeMediaUnsupported";
    }
    else if(code == PlayRTCCodeConnectionFail) /* 채널/시그널 서버 연결 실패 */
    {
        return @"PlayRTCCodeConnectionFail";
    }
    else if(code == PlayRTCCodeDisconnectFail) /* 채널 퇴장 실패 */
    {
        return @"PlayRTCCodeDisconnectFail";
    }
    else if(code == PlayRTCCodeSendRequestFail) /* 데이터 전송 실패 */
    {
        return @"PlayRTCCodeSendRequestFail";
    }
    else if(code == PlayRTCCodeMessageSyntax) /* 데이터 문법 오류 */
    {
        return @"PlayRTCCodeMessageSyntax";
    }
    else if(code == PlayRTCCodeProjectIdInvalid) /* 프로젝트 아이디 오류 */
    {
        return @"PlayRTCCodeProjectIdInvalid";
    }
    else if(code == PlayRTCCodeTokenInvalid) /* 사용자 토큰 오류 */
    {
        return @"PlayRTCCodeTokenInvalid";
    }
    else if(code == PlayRTCCodeTokenExpired) /* 사용자 토큰 기간 만료 */
    {
        return @"PlayRTCCodeTokenExpired";
    }
    else if(code == PlayRTCCodeChannelIdInvalid) /* 채널링 채널아이디 오류 */
    {
        return @"PlayRTCCodeChannelIdInvalid";
    }
    else if(code == PlayRTCCodeServiceError) /* 채널링/시그널링 서비스 오류 */
    {
        return @"PlayRTCCodeServiceError";
    }
    else if(code == PlayRTCCodePeerMaxCount) /* Peer 접속 인원 허용 초과 */
    {
        return @"PlayRTCCodePeerMaxCount";
    }
    else if(code == PlayRTCCodePeerIdInvalid) /* Peer 아이디 오류 */
    {
        return @"PlayRTCCodePeerIdInvalid";
    }
    else if(code == PlayRTCCodePeerIdAlready) /* Peer 아이디 중복 사용 오류 */
    {
        return @"PlayRTCCodePeerIdAlready";
    }
    else if(code == PlayRTCCodePeerInternalError) /* Peer 내부 오류 */
    {
        return @"PlayRTCCodePeerInternalError";
    }
    else if(code == PlayRTCCodePeerConnectionFail) /* Peer 연결 실패 */
    {
        return @"PlayRTCCodePeerConnectionFail";
    }
    else if(code == PlayRTCCodeSdpCreationFail) /* Peer SDP 생성 오류 */
    {
        return @"PlayRTCCodeSdpCreationFail";
    }
    else if(code == PlayRTCCodeSdpRegistrationFail) /* Peer SDP 등록 오류 */
    {
        return @"PlayRTCCodeSdpRegistrationFail";
    }
    else if(code == PlayRTCCodeDataChannelCreationFail) /* DataChannel 생성 오류 */
    {
        return @"PlayRTCCodeDataChannelCreationFail";
    }
    else if(code == PlayRTCCodeNotConnect) /* PlayRTC 채널 연결 객체가 없거나 채널에  연결되어 있지않음 */
    {
        return @"PlayRTCCodeNotConnect";
    }
    else if(code == PlayRTCCodeConnectAlready) /* 이미 채널에 입장해 있음 */
    {
        return @"PlayRTCCodeConnectAlready";
    }
    return @"";
}

@end

/*
 * DataChannel의 Send dlqpsxm (PlayRTCDataSendObserver)를 받기 위한 객체 구현부
 * PlayRTCDataSendObserver 인터페이스 구현
 */
@implementation PlayRTCDataChannelSendObserver
@synthesize playRTC;
@synthesize viewcontroller;

/*
 * 데이터 전송 진척 상황을 전달
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * dataId : uint64_t, 데이터 고유 아이디
 * size : uint64_t, 데이터 전체 크기
 * send : uint64_t, 전송 보낸 데이터 크기
 * index : int, 데이터 패킷 분할 전송 index
 * count : int, 데이터 패킷 분할 count
 */
-(void)onSending:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId size:(uint64_t)size send:(uint64_t)send index:(int)index count:(int)count
{
    float per = ((float)send/(float)size) * 100.0f;
    NSString* sMsg = [NSString stringWithFormat:@"[DataChannel] Sending [%d/%d] [%lld/%lld] 0%.2f%%", index+1, count, send, size, per];
    NSLog(@"[PlayRTCViewController] %@", sMsg);
    [self.viewcontroller progressLogView:sMsg];
}
/*
 * 데이터 전송 완료
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * dataId : uint64_t, 데이터 고유 아이디
 * size : uint64_t, 데이터 전체 크기
 */
-(void)onSendSuccess:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId size:(uint64_t)size
{
    int64_t endElapsed = [[NSDate date] timeIntervalSince1970] *1000 - startElapsed;
    startElapsed = 0;
    NSLog(@"[PlayRTCViewController] DataChannel Send onSuccess peerId[%@] dataId[%lld][%lld - %lld]", peerId, dataId, size, endElapsed);
    [self.viewcontroller appendLogView:[NSString stringWithFormat:@"[DataChannel] Send onSuccess dataId[%lld@]", dataId]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dataChannelDelegate = nil;
    });
}
/*
 * 데이터 전송 오류
 * obj : PlayRTCData 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 * dataId : uint64_t, 데이터 고유 아이디
 * code : PlayRTCDataCode, 오류 코드 정의
 * desc : NSString, description
 */
-(void)onSendError:(PlayRTCData*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid dataId:(uint64_t)dataId code:(PlayRTCDataCode)code desc:(NSString*)desc
{
    startElapsed = 0;
    NSLog(@"[PlayRTCViewController] DataChannel Send onError peerId[%@] peerUid[%@] dataId[%lld]", peerId, peerUid, dataId);
    [self.viewcontroller appendLogView:[NSString stringWithFormat:@"[DataChannel] Send onError peerId[%@] peerUid[%@] dataId[%lld@]", peerId, peerUid, dataId]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dataChannelDelegate = nil;
    });
}
@end
