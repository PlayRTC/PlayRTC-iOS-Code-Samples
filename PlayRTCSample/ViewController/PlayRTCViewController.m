//
//  PlayRTCViewController.m
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//


#import "PlayRTCViewController_UILayout.h"
#import "PlayRTCViewController_PlayRTC.h"

#import "PlayRTCSettings.h"
#import <AVFoundation/AVFoundation.h>

#define LOG_TAG @"PlayRTCViewController"


@implementation PlayRTCViewController
@synthesize playrtcType;
@synthesize channelId;
@synthesize token;
@synthesize userUid;
@synthesize playRTC;
@synthesize localVideoView;
@synthesize remoteVideoView;
@synthesize localMedia;
@synthesize remoteMedia;
@synthesize dataChannel;
@synthesize prevText;
@synthesize recvFile;
@synthesize recvText;

#pragma mark - instance

- (id)initWithType:(int)type
{
    self = [super init];
    if(self) {
        self.playrtcType = type;
    }
    
    return self;
}

/*
 // PlayRTC의 enableAudioSession를 사용하지 않고 직접 하려면 아래 소스를 사용하세요.
 typedef NS_ENUM(NSUInteger, AVAudioSessionRouteChangeReason)
 {
	AVAudioSessionRouteChangeReasonUnknown = 0,
	AVAudioSessionRouteChangeReasonNewDeviceAvailable = 1,
	AVAudioSessionRouteChangeReasonOldDeviceUnavailable = 2,
	AVAudioSessionRouteChangeReasonCategoryChange = 3,
	AVAudioSessionRouteChangeReasonOverride = 4,
	AVAudioSessionRouteChangeReasonWakeFromSleep = 6,
	AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory = 7,
	AVAudioSessionRouteChangeReasonRouteConfigurationChange NS_ENUM_AVAILABLE_IOS(7_0) = 8
 } NS_AVAILABLE_IOS(6_0);

*/
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
- (void)didSessionRouteChange:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonCategoryChange: {
            // Set speaker as default route
            NSError* error;
            /*
             typedef NS_ENUM(NSUInteger, AVAudioSessionPortOverride)
             {
             AVAudioSessionPortOverrideNone    = 0,
             AVAudioSessionPortOverrideSpeaker = 'spkr'
             } NS_AVAILABLE_IOS(6_0);
             */
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    NSLog(@"[%@] viewDidLoad...", LOG_TAG);
    [super viewDidLoad];
    
    
    self.localMedia         = nil;
    self.remoteMedia        = nil;
    self.dataChannel        = nil;
    self.channelId          = nil;
    self.token              = nil;
    self.userUid            = nil;
    
    self.recvFile = nil;
    self.recvText = nil;
    self.prevText = nil;
    hasPrevText = FALSE;
    
    isChannelConnected = FALSE;
    [self createPlayRTCHandler];
    //PlayRTC의 enableAudioSession를 호출하여 AVAudioSession 관리를 내부적으로 할 경우
    [self.playRTC enableAudioSession];
    
    [self createViewControllerLayout:self.view.frame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[%@] viewWillAppear", LOG_TAG);
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@] viewWillDisappear", LOG_TAG);
    if ([self.navigationController.viewControllers containsObject:self] == FALSE) {
        
        NSLog(@"[%@] viewWillDisappear 현재 viewController가 더이상 유효하지 않다.", LOG_TAG);
        
        
        
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[%@] viewDidDisappear", LOG_TAG);
    
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"[%@] dealloc...", LOG_TAG);
    self.localMedia = nil;
    self.remoteMedia = nil;
    self.channelId = nil;
    self.token = nil;
    self.userUid = nil;
    channelPopup = nil;

    [self.remoteVideoView removeFromSuperview];
    self.remoteVideoView = nil;
    
    [self.localVideoView removeFromSuperview];
    self.localVideoView = nil;
    
    self.playRTC = nil;
    self.prevText = nil;
    self.recvFile = nil;
    self.recvText = nil;
}

- (void)closeViewController
{
    [self closePlayRtc];
    UIViewController* thiz = [self.navigationController popViewControllerAnimated:TRUE];
    thiz = nil;
}


#pragma mark -  ChannelViewListener
/**
 * 채널 팝업에서 채널 생성 요청 버튼을 클릭 한 경우
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId
{
    [self createChannel:channelName userId:userId];
}
/**
 * 채널 팝업에서 채널 입장 요청 버튼을 클릭 한 경우
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickConnectChannel:(NSString*)chId userId:(NSString*)userId
{
    [self connectChannel:chId userId:userId];
}



@end

