//
//  Sample1Controller.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 29..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "Sample1ViewController_UILayout.h"


#define LOG_TAG @"Sample1ViewController"

@implementation Sample1ViewController
@synthesize playRTC;
@synthesize channelPopup;
@synthesize logView;
- (id)init
{
    
    self = [super init];
    if (self) {
        // PlayRTCSettings 생성 및 설정
        PlayRTCSettings* settings = [Sample1PlayRTC createConfiguration];
        self.playRTC = [[Sample1PlayRTC alloc] initWithSettings:settings];
        self.playRTC.controller = self;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    
    [super loadView];
    NSLog(@"[%@] loadView", LOG_TAG);
    
    //PlayRTC의 enableAudioSession를 호출하여 AVAudioSession 관리를 내부적으로 할 경우
    [self.playRTC enableAudioSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    
    self.playRTC = nil;
    
}


/* UIAlertViewDelegate */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self closeController];
    }
}

/* ViewControllerPlayRTCObserver */
-(void)onConnectChannel:(NSString*)chId reason:(NSString*)reason
{
    [self appendLogView:@"onConnectChannel"];
    [self.channelPopup setChannelId:self.playRTC.channelId];
    [self.channelPopup hide];
}
-(void)closeController
{
    if(self.playRTC.isConnect == TRUE)
    {
        [self.playRTC deleteChannel];
        return;
    }
    UIViewController* viewController = [self.navigationController popViewControllerAnimated:TRUE];
    viewController = nil;
}
- (void)appendLogView:(NSString*)insertingString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        logView.text = [[logView.text stringByAppendingString:@"\n"] stringByAppendingString:insertingString];
    });
}

#pragma mark -  ChannelViewListener
/* ChannelViewListener */
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId
{
    [self.playRTC createChannel:channelName userId:userId];
}
- (void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId
{
    [self.playRTC connectChannel:channelId userId:userId];
}
-(void)getChannelList:(id<PlayRTCServiceHelperListener>)listener
{
    [self.playRTC getChannelList:listener];
}

@end
