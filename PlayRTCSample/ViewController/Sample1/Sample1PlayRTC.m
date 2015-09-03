//
//  Sample1PlayRTC.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 5. 6..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "Sample1PlayRTC.h"
#import "Sample1ViewController.h"

#define LOG_LEVEL LOG_WARN
#define TDCPROJECTID @"60ba608a-e228-4530-8711-fa38004719c1"
#define LOG_TAG @"Sample1PlayRTC"

@implementation Sample1PlayRTC
@synthesize isConnect;
@synthesize channelId;
@synthesize channelName;
@synthesize token;
@synthesize userPid;
@synthesize userUid;
@synthesize otherPeerId;
@synthesize otherPeerUid;
@synthesize playRTC;
@synthesize dataChannel;
@synthesize localVideoView;
@synthesize remoteVideoView;
@synthesize localMedia;
@synthesize remoteMedia;
@synthesize logView;
@synthesize dataView;
@synthesize controller;

-(id)initWithSettings:(PlayRTCSettings*)settings
{
    
    self = [super init];
    if (self) {
        self.isConnect = FALSE;
        self.channelId = nil;
        self.channelName = nil;
        self.token = nil;
        self.userPid = nil;
        self.userUid = nil;
        self.otherPeerId = nil;
        self.otherPeerUid = nil;
        self.dataChannel = nil;
        self.localVideoView = nil;
        self.remoteVideoView = nil;
        self.localMedia = nil;
        self.remoteMedia = nil;
        self.logView = nil;
        self.dataView = nil;
        self.controller = nil;
        /**
         * PlayRTC 인스턴스 생성
         * PlayRTC 인터페이스를 구현한 PlayRTC Implement를 반환한다
         * @param settings PlayRTCSettings
         * @param observer PlayRTCObserver, PlayRTC Event 리스너
         * @return PlayRTC
         */
        self.playRTC = [PlayRTCFactory newInstance:settings observer:(id<PlayRTCObserver>)self];
    }
    return self;
}

- (void)dealloc
{
    self.channelId = nil;
    self.channelName = nil;
    self.token = nil;
    self.userPid = nil;
    self.userUid = nil;
    self.otherPeerId = nil;
    self.otherPeerUid = nil;
    self.playRTC = nil;
    self.dataChannel = nil;
    self.localVideoView = nil;
    self.remoteVideoView = nil;
    self.localMedia = nil;
    self.remoteMedia = nil;
    self.logView = nil;
    self.controller = nil;
    
}

+(PlayRTCSettings*)createConfiguration
{
    /*PlayRTCSetting 개체 생성*/
    PlayRTCSettings* settings = [[PlayRTCSettings alloc] init];
    
    [settings setTDCProjectId:TDCPROJECTID];
    [settings setTDCHttpReferer:nil];
    
    
    // PlayRTC 서비스의 TURN 서버 이외의 외부 TURN을 사용할 경우 아래와 같이 지정
    //[settings.iceServers resetIceServer:@"turn:IP:PORT" username:@"USER-ID" credential:@"PASSWORD"];
    
    /*영상 및 음성 스트리밍 사용 설정 */
    
    [settings setVideoEnable:TRUE];
    /* camera frony, back */
    [settings.video setFrontCameraEnable:TRUE];
    [settings.video setBackCameraEnable:FALSE];
    
    [settings setAudioEnable:TRUE];
    
    /* 데이터 스트림 사용 여부, 사용안함. */
    [settings setDataEnable:FALSE];
    
    /* ring, 연결 수립 여부를 상대방에게 묻는지 여부를 지정, TRUE면 상대의 수락이 있어야 연결 수립 진행 */
    [settings.channel setRing:FALSE];
    
    
    
    /* SDK Console 로그 레벨 지정 */
    [settings.log.console setLevel:LOG_LEVEL];
    
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /* SDK 파일 로깅을 위한 로그 파일 경로, 파일 로깅을 사용하지 않는다면 Pass */
    if(FALSE)
    {
        NSString* logPath = [docPath stringByAppendingPathComponent:@"log"];
        /* SDK 파일 로그 레벨 지정 */
        [settings.log.file setLevel:LOG_WARN];
        /* 파일 로그를 남기려면 로그파일 폴더 지정 . [PATH]/yyyyMMdd.log  */
        [settings.log.file setLogPath:logPath];
        [settings.log.file setRolling:10]; /* 10일간 보존 */
    }
    /* 서버 로그 전송 실패 시 임시 로그 DB 저장 폴더 */
    NSString* cachePath = [docPath stringByAppendingPathComponent:@"cache"];
    [settings.log setCachePath:cachePath];
    /* 서버 로그 전송 실패 시 재 전송 지연 시간, msec */
    [settings.log setRetryQueueDelays:1000];
    /* 서버 로그 재 전송 실패시 로그 DB 저장 후 재전송 시도 지연 시간, msec */
    [settings.log setRetryCacheDelays:(10 * 1000)];
    
    return settings;
}



/**
 * 채널 서비스에 채널 생성 요청
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)createChannel:(NSString*)chName userId:(NSString*)userId
{
    if(self.playRTC == nil)
    {
        return;
    }
    self.channelName = chName;
    if(self.channelName == nil) self.channelName = @"";
    /*
     * 채널 및 사용자 관련 부가 정보 정의
     */
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if(channelName != nil) {
        NSDictionary * channel = [NSDictionary dictionaryWithObject:chName forKey:@"channelName"];
        [parameters setObject:channel forKey:@"channel"];
    }
    if(userId != nil) {
        self.userUid = userId;
        NSDictionary * peer = [NSDictionary dictionaryWithObject:userId forKey:@"uid"];
        [parameters setObject:peer forKey:@"peer"];
    }
    else {
        self.userUid = @"";
    }
    NSLog(@"[%@] createChannel channelName[%@] userId[%@]", LOG_TAG, channelName, userId);
    [self.playRTC createChannel:parameters];
    
}

/**
 * 채채널 입장 요청
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)connectChannel:(NSString*)chId userId:(NSString*)userId
{
    if(self.playRTC == nil)
    {
        return;
    }
    if(chId != nil) {
        self.channelId = chId;
    }
    else {
        self.channelId = @"";
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
    NSLog(@"[%@] connectChannel channelId[%@] userId[%@]", LOG_TAG, chId, userId);
    [self.playRTC connectChannel:self.channelId parameters:parameters];
    
}

/**
 * 특정 사용자를 채널에서 퇴장시킨다.
 * 채널에서 퇴장하는 사용자는 onDisconnectChannel
 * 채널에 있는 다른 시용자는 onOtherDisconnectChannel 이벤트를 받는다.
 * peerId : NSString, PlayRTC 서비스에서 발급한 사용자 아이디
 */
- (void)disconnectChannel
{
    if(self.playRTC == nil) {
        [(Sample1ViewController*)self.controller closeController];
        return;
    }
    NSString* peerId = [self.playRTC getPeerId];
    
    // 채널 퇴장 요청
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
        [(Sample1ViewController*)self.controller closeController];
        return;
    }
    //채널 종료 요청
    [self.playRTC deleteChannel];
}


- (void)switchCamera
{
    if(self.playRTC == nil) {
        
        return;
    }
    
    [self.playRTC switchCamera];
}

/**
 * AVAudioSession 제어 기능을 활성화 시키는 인터페이스
 * @return BOOL, 서비스 실패 시 false
 */
- (BOOL)enableAudioSession
{
    return [self.playRTC enableAudioSession];
}

/**
 * 음성을 출력하는 Speaker를 지정하는 인터페이스
 * enableAudioSession를 호출하여 AudioSession Manager를 활성화 시켜야 한다.
 * @param enable BOOL, TRUE 지정 시 외부 Speaker로 소리가 출력되고, FALSE 시 EAR-Speaker로 출력. 기본은 EAR-Speaker
 * @return BOOL, 서비스 호출 실패 시 false
 */
- (BOOL)setLoudspeakerEnable:(BOOL)enable
{
    if(self.playRTC == nil) {
        
        return FALSE;
    }
    return [self.playRTC setLoudspeakerEnable:enable];
}

/*
 * 상대방의 사용자에게  문자열을 전송한다.
 * PlayRTC 채널 서비스를 통해서 전달.
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 * data : NSString, 앱에서 정의한 데이터 문자열
 */
- (void)userCommand:(NSString*)peerId command:(NSString*)command
{
    [self.playRTC userCommand:peerId data:command];
}

- (void)getChannelList:(id<PlayRTCServiceHelperListener>)listener
{
    [self.playRTC getChannelList:listener];
}

#pragma mark - PlayRTCDataObserver
/*
 * createChannel/connectChannel 성공 시 호출 됨
 * obj : PlayRTC 인스턴스
 * chId : NSString, 채널 아이디
 * reason : NSString, createChannel의 경우 "create" , connectChannel의 경우 "connect"
 */
-(void)onConnectChannel:(PlayRTC*)obj channelId:(NSString*)chId reason:(NSString*)reason
{
    self.channelId = chId;
    self.isConnect = TRUE;
    NSLog(@"[%@] onConnectChannel[%@] reason[%@]", LOG_TAG, channelId, reason);
    [(Sample1ViewController*)self.controller onConnectChannel:chId reason:reason];
}

/*
 * 상대방의 연결 요청을 빋는 경우 호출 됨
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onRing:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    
}

/*
 * 상대방의 연결 요청의 승락을 받은 경우 호출됨
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 */
-(void)onAccept:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid
{
    
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
    NSLog(@"[%@] onUserCommand peerId[%@] peerUid[%@] data[%@]", LOG_TAG, peerId, peerUid, data);
    [self.controller appendLogView:[NSString stringWithFormat:@"onUserCommand peerId[%@] peerUid[%@] data[%@]", peerId, peerUid, data]];
}

/*
 * 단말기의 미디어 객체가 생성됐을 때 호출됨, 영상의 경우 영상 출력 처리를 해야 한다.
 * obj : PlayRTC 인스턴스
 * media : PlayRTCMedia
 */
-(void)onAddLocalStream:(PlayRTC*)obj media:(PlayRTCMedia*)media
{
    NSLog(@"[%@] onAddLocalStream media[%@]", LOG_TAG, media);
    [(Sample1ViewController*)self.controller appendLogView:@"onAddLocalStream ..."];
    self.localMedia = media;
    // 영상 출력 처리
    // PlayRTCVideoView객체의 Renderer를 전달하여 로컬 영상 프레임을 출력하도록한다.
    [media setVideoRenderer:[self.localVideoView getVideoRenderer]];
    
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
    NSLog(@"[%@] onAddRemoteStream peerId[%@] peerUid[%@] media[%@]", LOG_TAG, peerId, peerUid, media);
    [(Sample1ViewController*)self.controller appendLogView:[NSString stringWithFormat:@"onAddRemoteStream peerId[%@] peerUid[%@]", peerId, peerUid]];
    self.remoteMedia = media;
    // 영상 출력 처리
    // PlayRTCVideoView객체의 Renderer를 전달하여 수신받은 영상 프레임을 출력하도록한다.
    [media setVideoRenderer:[self.remoteVideoView getVideoRenderer]];
}

/*
 * 데이터 통신을 위한 Data Channel 객체가  생성됬을 때 호출됨
 * 전달 받은 PlayRTCData에 PlayRTCDataObserver 구현체를 등록한다.
 * 사용안함.
 * obj : PlayRTC 인스턴스
 * peerId : NSString, 상대방의 PlayRTC 서비스 사용자 아이디
 * peerUid : NSString, 채널 생성/입장 시 전달항 사용자 아이디
 * data : PlayRTCData, 데이터 통신을 위한 객체
 */
-(void)onAddDataStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(PlayRTCData*)data
{

}

/*
 * 채널 서비스에서 퇴장을 알리는 이벤트를 받을 때.
 * deleteChannel 또는 자신이 disconnectChannel를 호출한 경우
 * obj : PlayRTC 인스턴스
 * reason : NSString, 이벤트 종류. 자신의 채널 퇴장 시 "disconnect". 채날 종료 시 "delete"
 */
-(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason
{
    isConnect = FALSE;
    NSLog(@"[%@] onDisconnectChannel reason[%@]", LOG_TAG, reason);
    [(Sample1ViewController*)self.controller appendLogView:[NSString stringWithFormat:@"onDisconnectChannel reason[%@]", reason]];
    
    NSString* msg = nil;
    if([reason isEqualToString:@"disconnect"])
    {
        msg = @"PlayRTC 채널에서 퇴장하였습니다.\n[이전화면]을 눌러 메뉴 화면으로 이동하세요.";
    }
    else
    {
        msg = @"PlayRTC 채널이 종료되었습니다.\n[이전화면]을 눌러 메뉴 화면으로 이동하세요.";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"채널 퇴장"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
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
    isConnect = FALSE;
    NSLog(@"[%@] onOtherDisconnectChannel peerId[%@] peerUid[%@]", LOG_TAG, peerId, peerUid);
    [(Sample1ViewController*)self.controller appendLogView:[NSString stringWithFormat:@"onOtherDisconnectChannel peerId[%@] peerUid[%@]", peerId, peerUid]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"[%@]가 채널에서 퇴장하였습니다....\n[나가기]를 눌러 PlayRTC를 종료세요.", peerUid]
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
    NSString* sStat = [Sample1PlayRTC getPlayRTCStatusString:status];
    NSString* sCode = [Sample1PlayRTC getPlayRTCCodeString:code];
    NSLog(@"[%@] onError status[%@] code[%@] desc[%@]", LOG_TAG, sStat, sCode, desc);
    
    [(Sample1ViewController*)self.controller appendLogView:[NSString stringWithFormat:@"onError [%@,%@] %@", sStat, sCode, desc]];
    
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
    NSString* sStat = [Sample1PlayRTC getPlayRTCStatusString:status];
    NSLog(@"[%@] onStateChange status[%@] desc[%@]", LOG_TAG, sStat, desc);
    [(Sample1ViewController*)self.controller appendLogView:[NSString stringWithFormat:@"onStateChange [%@] %@", sStat, desc]];
}



/////////////////////////////////////////////
+(NSString*)getPlayRTCStatusString:(PlayRTCStatus)status
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
+(NSString*)getPlayRTCCodeString:(PlayRTCCode)code
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

