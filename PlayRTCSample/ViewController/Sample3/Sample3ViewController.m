//
//  Sample3ViewController.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "SampleDefine.h"
#import "Sample3ViewController_UILayout.h"

#define LOG_TAG @"Sample3ViewController"

@implementation Sample3ViewController
@synthesize channelId;
@synthesize token;
@synthesize userUid;
@synthesize playRTC;
@synthesize channelPopup;
@synthesize logView;
- (id)init
{
    
    self = [super init];
    if (self) {
        
        self.channelId          = nil; 
        self.token              = nil;
        self.userUid            = nil;
        
        // PlayRTCSettings 생성 및 설정
        PlayRTCSettings* settings = [Sample3PlayRTC createConfiguration];
        self.playRTC = [[Sample3PlayRTC alloc] initWithSettings:settings];
        self.playRTC.controller = self;
        
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.channelId = nil;
    self.token = nil;
    self.userUid = nil;
    
    self.playRTC = nil;
    
}




- (void)appendLogView:(NSString*)insertingString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        logView.text = [[logView.text stringByAppendingString:@"\n"] stringByAppendingString:insertingString];
    });
}


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
    if(self.playRTC.isConnect == TRUE )
    {
        [self.playRTC deleteChannel];
        return;
    }

    UIViewController* viewController = [self.navigationController popViewControllerAnimated:TRUE];
    viewController = nil;
    
    //NSLog(@"[%@] exit(0)...", LOG_TAG);
    //exit(0);
    
}
#pragma mark -  ChannelViewListener
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId
{
    [self.playRTC createChannel:channelName userId:userId];
}
- (void)onClickConnectChannel:(NSString*)chId userId:(NSString*)userId
{
    [self.playRTC connectChannel:chId userId:userId];
}
-(void)getChannelList:(id<PlayRTCServiceHelperListener>)listener
{
    [self.playRTC getChannelList:listener];
}
@end

