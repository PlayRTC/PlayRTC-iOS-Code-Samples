//
//  Sample2ViewController.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample2ViewController_h__
#define __Sample2ViewController_h__

#import <UIKit/UIKit.h>
#import "Sample2PlayRTC.h"
#import "ChannelView.h"
#import "ExTextView.h"

@interface Sample2ViewController : UIViewController<UIAlertViewDelegate, ChannelViewListener>
{
    Sample2PlayRTC* playRTC;
    ChannelView* channelPopup;
    ExTextView* logView;
    UIView* mainAreaView;
    UIView* muteAreaView; 
    UIView* bottomAreaView;

}

@property (nonatomic, strong) Sample2PlayRTC* playRTC;
@property (nonatomic, strong)ChannelView* channelPopup;
@property (nonatomic, strong)ExTextView* logView;

-(id)init;
/* UIAlertViewDelegate */
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
/* ViewControllerPlayRTCObserver */
-(void)onConnectChannel:(NSString*)chId reason:(NSString*)reason;
-(void)closeController;
-(void)appendLogView:(NSString*)insertingString;
/* ChannelViewListener */
-(void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
-(void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId;
-(void)getChannelList:(id<PlayRTCServiceHelperListener>)listener;
@end

#endif
