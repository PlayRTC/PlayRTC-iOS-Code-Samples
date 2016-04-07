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


@interface PlayRTCViewController (Private)
- (void)setNavigationBar:(NSString*)title;
- (void)onLeftTitleBarButton:(id)sender;
- (void)onRightTitleBarButton:(id)sender;

@end


@implementation PlayRTCViewController
@synthesize channelId;
@synthesize token;
@synthesize userUid;
@synthesize playRTC;
@synthesize localVideoView;
@synthesize remoteVideoView;
@synthesize localMedia;
@synthesize remoteMedia;
@synthesize dataChannel;
@synthesize playrtcType;
@synthesize prevText;
@synthesize recvFile;
#pragma mark - instance

/**
 * type : int Sample App 유형
 *      1: 영상 + 음성 + Data
 *      2: 영상 + 음성
 *      3: 음성 Only
 *      4: Data Only
 */
- (id)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.localMedia         = nil;
        self.remoteMedia        = nil;
        self.dataChannel        = nil;
        self.channelId          = nil;
        self.token              = nil;
        self.userUid            = nil;
        
        self.recvFile = nil;
        
        playrtcType = type;
        self.prevText = nil;
        hasPrevText = FALSE;
        
        isChannelConnected = FALSE;
        [self createPlayRTCHandler];
        
        
        [self setNavigationBar:@"PlayRTC Viewer"];
        
        // PlayRTC의 enableAudioSession를 호출하여 AVAudioSession 관리를 직접 하려면 아래 소스를 사용하세요.
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        
    }
    return self;
}

/*
 // PlayRTC의 enableAudioSession를 호출하여 AVAudioSession를 하지 않고 직접 하려면 아래 소스를 사용하세요.
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

- (void)loadView
{
    
    [super loadView];
    NSLog(@"[%@] loadView", LOG_TAG);

    //PlayRTC의 enableAudioSession를 호출하여 AVAudioSession 관리를 내부적으로 할 경우
    [self.playRTC enableAudioSession];
}

- (void)viewDidLoad
{
    NSLog(@"[%@] viewDidLoad", LOG_TAG);
    [super viewDidLoad];
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
    CGRect bounds = self.view.bounds;
    [self initScreenLayoutView:bounds];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@] viewWillDisappear", LOG_TAG);
    if ([self.navigationController.viewControllers containsObject:self] == FALSE) {
        
        NSLog(@"[%@] viewWillDisappear 현재 viewController가 더이상 유효하지 않다.", LOG_TAG);
        
        self.localMedia = nil;
        self.remoteMedia = nil;
        self.channelId = nil;
        self.token = nil;
        self.userUid = nil;
        channelPopup = nil;
        NSLog(@"remoteVideoView removeFromSuperview");
        [self.remoteVideoView removeFromSuperview];
        NSLog(@"remoteVideoView relaese");
        self.remoteVideoView = nil;
        NSLog(@"localVideoView removeFromSuperview");
        [self.localVideoView removeFromSuperview];
        NSLog(@"localVideoView relaese");
        self.localVideoView = nil;
        
        self.playRTC = nil;

        
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
}




#pragma mark - NavigationBar
- (void)setNavigationBar:(NSString*)title
{
    self.navigationController.navigationBar.hidden = FALSE;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    self.title = title;

    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc ] initWithTitle:@"이전화면"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(onLeftTitleBarButton:)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem* rightBrn = [[UIBarButtonItem alloc ] initWithTitle:@"기능버튼"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(onRightTitleBarButton:)];
    
    self.navigationItem.rightBarButtonItem = rightBrn;

    
}

- (void) onLeftTitleBarButton:(id)sender
{
    NSLog(@"[%@] onLeftTitleBarButton Click !!!", LOG_TAG);
    
    if(isChannelConnected == TRUE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"PlayRTC 채널에 입장해 있습니다.\n먼저 채널연결을 해제하세요."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"종료할까요?종료를 누르면 이전화면으로 이동합니다."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"종료",@"취소", nil];
    alert.tag = 1;
    [alert show];
    
}

- (void) onRightTitleBarButton:(id)sender
{
    
    NSLog(@"[%@] onRightTitleBarButton Click !!!", LOG_TAG);
    [self showControlButtons];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int tag = (int)alertView.tag;
    if(tag == 1)
    {
        if (buttonIndex == 0) {
            UIViewController* thiz = [self.navigationController popViewControllerAnimated:TRUE];
            thiz = nil;
        }
    }
    else if(tag == 100)
    {
        UIViewController* thiz = [self.navigationController popViewControllerAnimated:TRUE];
        thiz = nil;
    }
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

