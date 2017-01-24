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
@interface PlayRTCViewController(PlayRTC_internal)<PlayRTCObserver, PlayRTCDataObserver, PlayRTCStatsReportObserver, PlayRTCVideoViewSnapshotObserver>

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

/* PlayRTCVideoViewSnapshotObserver v2.2.5*/
-(void)onSnapshotImage:(UIImage*)image;
@end

@implementation PlayRTCViewController(PlayRTC)

#pragma mark - PlayRTCViewController(PlayRTC)

/* 
 PlayRTC 관련 인스턴스 해제
 */
- (void)closePlayRtc
{
    if(self.playRTC) {
        [self.playRTC close];
        self.dataChannel = nil;
        self.playRTC = nil;
        self.localMedia = nil;
        self.remoteMedia = nil;
        self.channelId = nil;
        self.token = nil;
    }
}
/*
 * SDK 설정 객체인 PlayRTCConfig를 생성한 후 PlayRTC 인스턴스를 생성.
 */
-(void)createPlayRTCHandler
{
    // PlayRTCConfig 생성 및 설정
    PlayRTCConfig* config = [self createPlayRTCConfiguration];
    
    /*
     * PlayRTC 인터페이스를 구현한 객체 인스턴스를 생성하고 PlayRTC를 반환한다. static
     *
     * @param config PlayRTCConfig, PlayRTC 서비스 설정 정보 객체
     * @param observer PlayRTCObserver, PlayRTC Event 리스너
     * @return PlayRTC
     */
    self.playRTC = [PlayRTCFactory createPlayRTC:config
                                        observer:(id<PlayRTCObserver>)self];

    
}

/*
 * PlayRTCConfig 인스턴스 생성
 * playrtcType
 * 1. 영상, 음성, p2p data
 * 2. 영상, 음성
 * 3. 음성, only
 * 4. p2p data only
 */
- (PlayRTCConfig*)createPlayRTCConfiguration
{
    PlayRTCConfig* config = [PlayRTCFactory createConfig];
    [config setProjectId:TDCProjectId];
    
    //Ring : TRUE 시 채널 입장 후 연결 수립 여부를 먼저 입장한 사용자에게 묻는다.
    [config setRingEnable:self.ringEnable];
    
    // UserMedia 인스턴스 생성 시점을 지정. default TRUE
    // TRUE : 채널 입장 후 바로 생성, 화면에 나의 영상을 바로 출력할 수 있다.
    // FALSE : 채널 입장 후 상대방과의 연결 과정을 시작할 때 생성. blank 화면이 표시됨
    [config setPrevUserMediaEnable:TRUE];
    
    
    // 영상, 음성, p2p data
    if(self.playrtcType == 1) {
        
        /*
         * 영상 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 영상 스트림을 전송하면 수신이 된다.
         */
        [config.video setEnable:TRUE];
        
        /**
         * PlayRTC Video영상을 위한 카메라를 지정한다.
         * @param camera CameraType
         * @see PlayRTCDefine.h
         *   CameraTypeFront : 전방 카메라
         *   CameraTypeBack : 후방 카메라
         */
        [config.video setCameraType:CameraTypeFront];
        
        /*
         * Video 영상의 선호 코덱을 지정, default VP8
         * 상대방 SDK와의 협상과정에서 지정한 코덱이 반듯이 사용되는 것은 아니다.
         * v2.2.5
         * @param codec PlayRTCVideoCodec, PlayRTCDefine.h
         *  - PlayRTCVP8
         *  - PlayRTCVP9
         *  - PlayRTCH264, Open H.264
         */
        PlayRTCVideoCodec rtcVideoCodec = PlayRTCVP8;
        if([self.videoCodec isEqualToString:@"VP9"]) {
            rtcVideoCodec = PlayRTCVP9;
        }
        else if([self.videoCodec isEqualToString:@"H264"]){
            rtcVideoCodec = PlayRTCH264;
        }
        [config.video setPreferCodec:rtcVideoCodec];
        
        
        /**
         * 영상 해상도 지정. 네트워크 사정에 따라 작은 해상도로 자동으로 적용됨.
         * 지원 해상도
         * - 352x288
         * - 640x480 default
         * - 1280x720
         */
        [config.video setMaxFrameSize:640 height:480];
        [config.video setMinFrameSize:640 height:480];
        
        [config.video setMaxFrameRate:30];
        [config.video setMinFrameRate:15];
        
        /**
         * PlayRTC Video-Stream BandWidth를 지정한다.
         * 600 ~ 2500
         * default 1500
         */
        [config.bandwidth setVideoBitrateKbps:1500];
        
        /*
         * 음성 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 음성 스트림을 전송하면 수신이 된다.
         */
        [config.audio setEnable:TRUE];
        
        /*
         * Audio의 선호 코덱을 지정, default ISAC
         * 상대방 SDK와의 협상과정에서 지정한 코덱이 반듯이 사용되는 것은 아니다.
         * v2.2.5
         * @param codec PlayRTCAudioCodec, PlayRTCDefine.h
         *  - PlayRTCISAC,
         *  - PlayRTCOPUS
         */
        PlayRTCAudioCodec rtcAudioCodec = PlayRTCISAC;
        if([self.audioCodec isEqualToString:@"OPUS"]) {
            rtcAudioCodec = PlayRTCOPUS;
        }
        [config.audio setPreferCodec:rtcAudioCodec];
        
        /**
         * PlayRTC Audio-Stream BandWidth를 지정한다. default 32
         * PlayRTCISAC 32
         * PlayRTCOPUS 32 ~ 64
         * @param bitrateKbps int
         */
        [config.bandwidth setAudioBitrateKbps:32];
        
        // P2P 데이터 교환을 위한 DataChannel 사용 여부
        [config.data setEnable:TRUE];
        
    }
    // 영상, 음성
    else if(self.playrtcType == 2) {
        
        /*
         * 영상 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 영상 스트림을 전송하면 수신이 된다.
         */
        [config.video setEnable:TRUE];
        
        /**
         * PlayRTC Video영상을 위한 카메라를 지정한다.
         * @param camera CameraType
         * @see PlayRTCDefine.h
         *   CameraTypeFront : 전방 카메라
         *   CameraTypeBack : 후방 카메라
         */
        [config.video setCameraType:CameraTypeFront];
        
        /*
         * Video 영상의 선호 코덱을 지정, default VP8
         * 상대방 SDK와의 협상과정에서 지정한 코덱이 반듯이 사용되는 것은 아니다.
         * v2.2.5
         * @param codec PlayRTCVideoCodec, PlayRTCDefine.h
         *  - PlayRTCVP8
         *  - PlayRTCVP9
         *  - PlayRTCH264, Open H.264
         */
        PlayRTCVideoCodec rtcVideoCodec = PlayRTCVP8;
        if([self.videoCodec isEqualToString:@"VP9"]) {
            rtcVideoCodec = PlayRTCVP9;
        }
        else if([self.videoCodec isEqualToString:@"H264"]){
            rtcVideoCodec = PlayRTCH264;
        }
        [config.video setPreferCodec:rtcVideoCodec];

        
        /**
         * 영상 해상도 지정. 네트워크 사정에 따라 작은 해상도로 자동으로 적용됨.
         * 지원 해상도
         * - 352x288
         * - 640x480 default
         * - 1280x720
         */
        [config.video setMaxFrameSize:640 height:480];
        [config.video setMinFrameSize:640 height:480];
        
        [config.video setMaxFrameRate:30];
        [config.video setMinFrameRate:15];
        
        /**
         * PlayRTC Video-Stream BandWidth를 지정한다.
         * 600 ~ 2500
         * default 1500
         */
        [config.bandwidth setVideoBitrateKbps:1500];
        
        /*
         * 음성 스트림 전송 사용.
         * false 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 음성 스트림을 전송하면 수신이 된다.
         */
        [config.audio setEnable:TRUE];
        
        /*
         * Audio의 선호 코덱을 지정, default ISAC
         * 상대방 SDK와의 협상과정에서 지정한 코덱이 반듯이 사용되는 것은 아니다.
         * v2.2.5
         * @param codec PlayRTCAudioCodec, PlayRTCDefine.h
         *  - PlayRTCISAC,
         *  - PlayRTCOPUS
         */
        PlayRTCAudioCodec rtcAudioCodec = PlayRTCISAC;
        if([self.audioCodec isEqualToString:@"OPUS"]) {
            rtcAudioCodec = PlayRTCOPUS;
        }
        [config.audio setPreferCodec:rtcAudioCodec];

        /**
         * PlayRTC Audio-Stream BandWidth를 지정한다. default 32
         * PlayRTCISAC 32
         * PlayRTCOPUS 32 ~ 64
         * @param bitrateKbps int
         */
        [config.bandwidth setAudioBitrateKbps:32];
        
        // P2P 데이터 교환을 위한 DataChannel 사용 여부
        [config.data setEnable:FALSE];
    }
    // 음성, only
    else if(self.playrtcType == 3) {
        
        /*
         * 영상 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 영상 스트림을 전송하면 수신이 된다.
         */
        [config.video setEnable:FALSE];
        
        /*
         * 음성 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 음성 스트림을 전송하면 수신이 된다.
         */
        [config.audio setEnable:TRUE];
        /*
         * Audio의 선호 코덱을 지정, default ISAC
         * 상대방 SDK와의 협상과정에서 지정한 코덱이 반듯이 사용되는 것은 아니다.
         * v2.2.5
         * @param codec PlayRTCAudioCodec, PlayRTCDefine.h
         *  - PlayRTCISAC,
         *  - PlayRTCOPUS
         */
        PlayRTCAudioCodec rtcAudioCodec = PlayRTCISAC;
        if([self.audioCodec isEqualToString:@"OPUS"]) {
            rtcAudioCodec = PlayRTCOPUS;
        }
        [config.audio setPreferCodec:rtcAudioCodec];
        
        /**
         * PlayRTC Audio-Stream BandWidth를 지정한다. default 32
         * PlayRTCISAC 32
         * PlayRTCOPUS 32 ~ 64
         * @param bitrateKbps int
         */
        [config.bandwidth setAudioBitrateKbps:32];

        
        // P2P 데이터 교환을 위한 DataChannel 사용 여부
        [config.data setEnable:FALSE];
    }
    // p2p data only
    else {
        
        /*
         * 영상 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 영상 스트림을 전송하면 수신이 된다.
         */
        [config.video setEnable:FALSE];
        
        /*
         * 음성 스트림 전송 사용.
         * FALSE 설정 시 SDK는 read-only 모드로 동작하며, 상대방이 음성 스트림을 전송하면 수신이 된다.
         */
        [config.audio setEnable:FALSE];
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
        NSString* sendData = @"DataChannel Hello 안녕하세요 こんにちは 你好...";
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
        NSString* sendText = @"DataChannel Hello 안녕하세요 こんにちは 你好...";
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
 * 채널 서비스에 채널 생성 요청, 채널이 생성되면 채널에 입장 
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
 * 채널 입장 요청
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
 * 입장해 있는 채널에서 퇴장시킨다.
 * 채널에서 퇴장하는 사용자는 onDisconnectChannel
 * 채널에 있는 다른 시용자는 onOtherDisconnectChannel 이벤트를 받는다.
 * onOtherDisconnectChannel이 호출 되는 상대방 사용자는 채널 서비스에 입장해 있는 상태이므로,
 * 새로운 사용자가 채널에 입장하면 P2P연결을 할 수 있다.
 */
- (void)disconnectChannel
{
    if(self.playRTC == nil) {
        PlayRTCViewController* viewcontroller = (PlayRTCViewController*)[self.navigationController popViewControllerAnimated:TRUE];
        viewcontroller = nil;
        return;
    }
    // 입장해 있는 채널에서 특정 사용자(자신 아이디를 사용함) 퇴장시킨다.
    [self.playRTC disconnectChannel:[self.playRTC getPeerId]];
}

/**
 * 입장해 있는 채널을 닫는다.
 * 채널 종료를 호출하면 채널에 있는 모든 사용자는 onDisconnectChannel이 호출된다.
 * onDisconnectChannel이 호출되면 PlayRTC 인스턴스는 더이상 사용할 수 없다.
 * P2P를 새로 연결하려면 PlayRTC 인스턴스를 다시 생성하여 채널 서비스에 입장해야 한다.
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

/**
 * 전/후방 카메라 전환
 * 채널에 연결이 되어 있어야 동작한다.
 */
- (void)switchCamera
{
    if(self.playRTC == nil) {
        
        return;
    }
    
    [self.playRTC switchCamera];
}

/**
 * 후방 카메라 플래쉬 On/Off 전환
 * 후방 카메라 사용중에만 동작한다.
 */
- (void)switchCameraFlash
{
    if(self.playRTC == nil) {
        
        return;
    }
    if([self.playRTC isUsedBackCamera] == FALSE) {
        
        return;
    }
    BOOL flashOn = ![self.playRTC isBackCameraFlashOn];
    [self.playRTC switchBackCameraFlashOn:flashOn];
}
/**
 * 음성 Speaker 출력 시 Loud-Speaker <-> Ear-Speaker 전환
 * enableAudioSession를 호출하여 AudioSession Manager를 활성화 시켜야 한다.
 */
- (BOOL)switchLoudSpeaker
{
    if(self.playRTC == nil) {
        
        return FALSE;
    }
    //음성 Speaker 출력 시 Loud-Speaker를 사용하도록 지정했는지 여부를 반환하는 인터페이스
    BOOL isOn = ![playRTC getLoudspeakerStatus];
    
    //음성 Speaker 출력 시 Loud-Speaker를 지정하는 인터페이스
    [self.playRTC setLoudspeakerEnable:isOn];
    
    
    return [self.playRTC getLoudspeakerStatus];
}

/**
 * Local PlayRTCVideoView Snapshot 이미지 생성
 * 이미지 크기는 View Size와 동일
 */
- (void)localViewSnapshot
{
    /**
     * Video View의 snapshot image를 생성한다.
     * snapshot image를 전달 하기 위해 PlayRTCVideoViewSnapshotObserver 구현 객체를 전달 받는다.
     * v2.2.5
     */
    [localVideoView snapshot:self];
}

/**
 * Remote PlayRTCVideoView Snapshot 이미지 생성
 * 이미지 크기는 View Size와 동일
 */
- (void)remoteViewSnapshot
{
    /**
     * Video View의 snapshot image를 생성한다.
     * snapshot image를 전달 하기 위해 PlayRTCVideoViewSnapshotObserver 구현 객체를 전달 받는다.
     * v2.2.5
     */
    [remoteVideoView snapshot:self];
}

/* PlayRTCVideoViewSnapshotObserver v2.2.5*/
-(void)onSnapshotImage:(UIImage*)image
{
    [snapshotView setSnapshotImage:image];
}

/**
 * v2.2.8 카메라 영상에 대한 추가 회전 각도 지정
 * 0, 90, 180, 270
 */
- (void)setCameraRotation:(int)degree
{
    if(self.playRTC == nil) {
        
        return;
    }
    [playRTC setCameraRotation:degree];
}

/**
 * 현재 사용중인 카메라의 Zoom Leval 설정 범위를 반환한다.
 * min, max 값이 1.0 이면 zoom 지원 않함.
 * 1,0 ~, 최대 4.0f
 * add v.2.2.9
 * @return ValueRange
 */
-(ValueRange*)getCameraZoomRange
{
    if(self.playRTC == nil) {
        
        return [ValueRange create:[NSNumber numberWithFloat:1.0f] max:[NSNumber numberWithFloat:1.0f]];
    }
    return [self.playRTC getCameraZoomRange];;
}
/**
 * 현재 사용중인 카메라의 Zoom Leval 값을 반환한다.
 * add v.2.2.9
 * @return float
 */
-(float)getCurrentCameraZoom
{
    if(self.playRTC == nil) {
        
        return 1.0f;
    }
    return  [self.playRTC getCurrentCameraZoom];
}

/**
 * 현재 사용중인 카메라의 Zoom Leval을 지정한다.
 * Zoom Leval은 max보다 크게 지정할 수 없다.
 * add v.2.2.9
 * @param zoomLevel float,  Zoom 설정 값. min <= zoom >= max
 * @return BOOL, 실행여부
 */
-(BOOL)setCameraZoom:(float)zoomLevel
{
    if(self.playRTC == nil) {
        
        return FALSE;
    }
    
    return [self.playRTC setCameraZoom:zoomLevel];
}

/**
 * 현재 사용중인 카메라의 WhiteBalance를 반환한다.
 * add v.2.2.9
 * @return PlayRTCWhiteBalance
 *  PlayRTCDefine.h
 *  - PlayRTCWhiteBalanceAuto
 *  - PlayRTCWhiteBalanceIncandescent : 백열등빛 temperature:3200K, 텅스텐 계열의 조명(백열전구로 되어 있으나 텅스텐 조명에 해당)
 *  - PlayRTCWhiteBalanceFluoreScent :  형광등빛 temperature:4000K, 백색 형광등 계열
 *  - PlayRTCWhiteBalanceDayLight : 햇빛/일광 temperature temperature:5200K
 *  - PlayRTCWhiteBalanceCloudyDayLight : 흐린빛/구름 or 플래쉬 temperature:6000K
 *  - PlayRTCWhiteBalanceTwiLi : 저녁빛 temperature:4000K, 저녁빛 아침이나 일목 1~2시간전
 *  - PlayRTCWhiteBalanceShade : 그늘/그림자 temperature:7000K, 맑은날 그늘진 곳에서 촬영 시
 */
-(PlayRTCWhiteBalance)getCameraWhiteBalance
{
    if(self.playRTC == nil) {
        
        return PlayRTCWhiteBalanceAuto;
    }
    return [self.playRTC getCameraWhiteBalance];
}

/**
 * 현재 사용중인 카메라의 WhiteBalance를 지정한다.
 * add v.2.2.9
 * @param whiteBalance PlayRTCWhiteBalance
 * @return BOOL, 실행 여부
 */
-(BOOL)setCameraWhiteBalance:(PlayRTCWhiteBalance)whiteBalance
{
    if(self.playRTC == nil) {
        
        return FALSE;
    }
    return [self.playRTC setCameraWhiteBalance:whiteBalance];
}

/**
 * 현재 사용중인 카메라의 노출 보정값 설정 범위를 반환한다.
 * min, max 값이 0.0 이면 지원 않함.
 * min:-4.0 ~ max:+4.0f
 * add v.2.2.9
 * @return ValueRange
 */
-(ValueRange*)getCameraExposureCompensationRange
{
    if(self.playRTC == nil) {
        
        return [ValueRange create:[NSNumber numberWithFloat:0.0f] max:[NSNumber numberWithFloat:0.0f]];
    }
    return [self.playRTC getCameraExposureCompensationRange];
}

/**
 * 현재 사용중인 카메라의 노출 보정값을 반환한다.
 * add v.2.2.9
 * @return float
 */
-(float)getCameraExposureCompensation
{
    if(self.playRTC == nil) {
        
        return 0.0f;
    }
    return [self.playRTC getCameraExposureCompensation];
}

/**
 * 현재 사용중인 카메라의 노출 보정값을 지정한다.
 * 노출 보정값은 설정 범위안에서 지정한다.
 * add v.2.2.9
 * @param exposureCompensation float,  min <= zoomLevel >= max(getCameraExposureCompensationRange)
 * @return BOOL, 실행여부
 */
-(BOOL)setCameraExposureCompensation:(float)exposureCompensation
{
    if(self.playRTC == nil) {
        
        return FALSE;
    }
    return [self.playRTC setCameraExposureCompensation:exposureCompensation];
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
    
    isChannelConnected = TRUE;
}

/*
 * PlayRTCConfig Channel의 ring = true 설정 시 나중에 채널에 입장한 사용자 측에서
 * 연결 수락 의사를 물어옴. ring 설정은 상호간에 동일해야한다.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onRing:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    self.ringPid = peerId;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PlayRTC 연결 요청"
                                                                   message:[NSString stringWithFormat:@"%@님이 연결을 요청하였습니다.", peerUid]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"연결"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                      {
                          [self.playRTC accept:self.ringPid];
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"거절"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action)
                      {
                          [self.playRTC reject:self.ringPid];
                      }]];

    
    [self presentViewController:alert animated:YES completion:nil];
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
 * Application에서 정의한 JSON String 또는 Command 문자열을 주고 받아 원하는 용도로 사용할 수 있다.
 * 예를 들어 상대방 단말제어.
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
 * 채널이 종료 되거나, 내가 채널에서 퇴장할 때 호출
 * deleteChannel 또는 자신이 disconnectChannel를 호출한 경우
 * PlayRTC 인스턴스는 재사용 할수 없다.(내부 P2P 객체 해제됨)
 * obj : PlayRTC 인스턴스
 * reason : NSString, 이벤트 종류. 자신의 채널 퇴장 시 "disconnect". 채날 종료 시 "delete"
 */
-(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason
{
    //P2P 상태 리포트 구동 중지
    [obj stopStatsReport];
    
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
    
    isChannelConnected = FALSE;

    // 확인 버튼을 누르면 이전 화면으로 이동하도록 처리
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"채널 퇴장"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"확인"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                      {
                          [self closeViewController];
                      }]];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

/*
 * 상대가 disconnectChannel을 호출하여 채널에서 퇴장할 때 호출된다.
 * 자신은 아직 채널 서비스에 입장해 있는 상태이므로, 채널 서비스에 추가로 입장한 사용자와 P2P연결을 수립 할 수 있다.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달한 사용자 아이디
 */
-(void)onOtherDisconnectChannel:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    //P2P 상태 리포트 구동 중지
    [obj stopStatsReport];
    
    // 상대방의 채널 퇴장을 알린다.
    // PlayRTC를 종료하려면 자신도 채널 퇴장)disconnectChannel)하거나 채널 종료(deleteChannel)를시켜야한다.
    NSLog(@"[PlayRTCViewController] onOtherDisconnectChannel peerId[%@] peerUid[%@]", peerId, peerUid);
    [self appendLogView:[NSString stringWithFormat:@"[PlayRTC] onOtherDisconnectChannel peerId[%@]", peerId]];
    
    // 상대방 스트림이 멈추면 View에 마지막 화면 잔상이 남는다.
    // 뷰 생성 시 지정한 배경 색으로 화면을 초기화 한다.
    // new 2.2.4
    if(self.remoteVideoView != nil)
    {
        [self.remoteVideoView bgClearColor];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"[%@]가 채널에서 퇴장하였습니다....", peerUid]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"확인"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
    //P2P 상태 리포트 구동 중지
    [obj stopStatsReport];
    
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
    NSString* sStatus = [self getPlayRTCStatusString:status];
    NSLog(@"[PlayRTCViewController] onStateChange peerId[%@] peerUid[%@] status[%@] desc[%@]", peerId, peerUid, sStatus, desc);
    [self appendLogView:[NSString stringWithFormat:@"onStateChange[%@]", sStatus]];
    
    // 최초 P2P연결 수립된 상태. 1번 호출
    // 연결 수립 이후 네트워크 상태에 따라 연결 상태가 PeerDisconnected <-> PeerConnected 상태를 반복할 수 있다.
    if(status == PlayRTCStatusPeerSuccess) {
        // 5 sec
        [obj startStatsReport:5000 observer:(id<PlayRTCStatsReportObserver>)self];
    }
}

-(void)onStatsReport:(PlayRTCStatReport*)report
{
    /*
     * PlayRTCStatReport 인터페이스
     *
     * - (NSString*) getLocalCandidate;
     *   자신의 ICE 서버 연결상태를 반환한다.
     * - (NSString*) getRemoteCandidate;
     *   상대방의 ICE 서버 연결상태를 반환한다.
     * - (NSString*) getLocalVideoCodec;
     *   자신의 VideoCodec을 반환한다.
     * - (NSString*) getLocalAudioCodec;
     *   자신의 AudioCodec을 반환한다.
     * - (NSString*) getRemoteVideoCodec;
     *   상대방의 VideoCodec을 반환한다.
     * - (NSString*) getRemoteAudioCodec;
     *   상대방의 AudioCodec을 반환한다.
     * - (int) getLocalFrameWidth;
     *   상대방에게 전송하는 영상의 해상도 가로 크기를 반환한다.
     * - (int) getLocalFrameWidth;
     *   상대방에게 전송하는 영상의 해상도 가로 크기를 반환한다.
     * - (int) getLocalFrameHeight;
     *   상대방에게 전송하는 영상의 해상도 세로 크기를 반환한다.
     * - (int) getRemoteFrameWidth;
     *   상대방 수신  영상의 해상도 가로 크기를 반환한다.
     * - (int) getRemoteFrameHeight;
     *   상대방 수신  영상의 해상도 세로 크기를 반환한다.
     * - (int) getLocalFrameRate;
     *   상대방에게 전송하는 영상의 Frame-Rate(초당 이미지 전송 수)를 반환한다.
     * - (int) getRemoteFrameRate;
     *   상대방 수신  영상의 Frame-Rate(초당 이미지 전송 수)를 반환한다.
     * - (int) getAvailableSendBandWidth;
     *   상대방에게 전송할 수 있는 네트워크 대역폭을 반환한다.
     * - (int) getAvailableReceiveBandWidth;
     *   상대방으로부터 수신할 수 있는 네트워크 대역폭을 반환한다.
     * - (int) getRtt;
     *   자신의 Rount Trip Time을 반환한다
     * - (RatingValue*) getRttRating;
     *   RTT값을기반으로 네트워크 상태를 5등급으로 분류하여 RttRating 를 반환한다.
     * - (RatingValue*) getFractionRating;
     *   Packet Loss 값을 기반으로 상대방의 영상 전송 상태를 5등급으로 분류하여 RatingValue 를 반환한다.
     * - (RatingValue*) getLocalAudioFractionLost;
     *   Packet Loss 값을 기반으로 자신의 음성 전송 상태를 5등급으로 분류하여RatingValue 를 반환한다.
     * - (RatingValue*) getLocalVideoFractionLost;
     *   Packet Loss 값을 기반으로 자신의 영상 전송 상태를 5등급으로 분류하여RatingValue 를 반환한다.
     * - (RatingValue*) getRemoteAudioFractionLost;
     *   Packet Loss 값을 기반으로 상대방의 음성 전송 상태를 5등급으로 분류하여RatingValue 를 반환한다.
     * - (RatingValue*) getRemoteVideoFractionLost;
     *   Packet Loss 값을 기반으로 상대방의 영상 전송 상태를 5등급으로 분류하여RatingValue 를 반환한다.
     */

    RatingValue* rttRating = [report getRttRating];
    RatingValue* localVideoFl = [report getLocalVideoFractionLost];
    RatingValue* localAudioFl = [report getLocalAudioFractionLost];
    RatingValue* remoteVideoFl = [report getRemoteVideoFractionLost];
    RatingValue* remoteAudioFl = [report getRemoteAudioFractionLost];
    
    NSString* localReport = [NSString stringWithFormat:@"\nLocal Report\n ICE:%@\n 해상도:%dx%dx%d\n 코덱:%@,%@\n BW:%@ps\n RTT:%d\n RTT-R:[%d/%.2f]\n VFL:[%d/%.4f]\n AFL:[%d/%.4f]",
                             [report getLocalCandidate],
                             [report getLocalFrameWidth],
                             [report getLocalFrameHeight],
                             [report getLocalFrameRate],
                             [report getLocalVideoCodec],
                             [report getLocalAudioCodec],
                             [self formatFileSize:[report getAvailableSendBandwidth]],
                             [report getRtt],
                             [rttRating getLevel],
                             [rttRating getValue],
                             [localVideoFl getLevel],
                             [localVideoFl getValue],
                             [localAudioFl getLevel],
                             [localAudioFl getValue]];
    
    NSString* remoteReport = [NSString stringWithFormat:@"\nRemote Report\n ICE:%@\n 해상도:%dx%dx%d\n 코덱:%@,%@\n BW:%@ps\n VFL:[%d/%.4f]\n AFL:[%d/%.4f]",
                              [report getRemoteCandidate],
                              [report getRemoteFrameWidth],
                              [report getRemoteFrameHeight],
                              [report getRemoteFrameRate],
                              [report getRemoteVideoCodec],
                              [report getRemoteAudioCodec],
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
    
    lbStatus.text = [NSString stringWithFormat:@"%@\n%@", localReport, remoteReport];
    [lbStatus sizeToFit];

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
       self.recvText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[PlayRTCViewController] DataChannel onProgress Text[%@]", recvText);
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
        [self appendLogView:[NSString stringWithFormat:@"[DataChannel] onFinishLoading[Text] %@", recvText]];
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
    [self.viewcontroller appendLogView:[NSString stringWithFormat:@"[DataChannel] Send onSuccess dataId[%lld]", dataId]];
    
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
