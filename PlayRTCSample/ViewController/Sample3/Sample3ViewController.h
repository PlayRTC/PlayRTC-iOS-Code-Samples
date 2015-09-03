//
//  Sample3ViewController.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 29..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample3ViewController_h__
#define __Sample3ViewController_h__

#import <UIKit/UIKit.h>
#import "Sample3PlayRTC.h"
#import "ChannelView.h"
#import "ExTextView.h"
#import "ExTextField.h"

@interface Sample3ViewController : UIViewController<UIAlertViewDelegate, ChannelViewListener>
{
    Sample3PlayRTC* playRTC;
    ChannelView* channelPopup;
    ExTextView* logView;
    UIView* mainAreaView;
    ExTextView* dataView;
    ExTextField* inputView;
    UIView* dataAreaView;
    UIView* bottomAreaView;
}
@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userUid;
@property (nonatomic, strong) Sample3PlayRTC* playRTC;
@property (nonatomic, strong) ChannelView* channelPopup;
@property (nonatomic, strong) ExTextView* logView;

-(id)init; 
-(void)appendLogView:(NSString*)insertingString;
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void)closeController;
/* ViewControllerPlayRTCObserver */
-(void)onConnectChannel:(NSString*)chId reason:(NSString*)reason;
/* ChannelViewListener */
-(void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
-(void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId;
-(void)getChannelList:(id<PlayRTCServiceHelperListener>)listener;
@end

#endif

