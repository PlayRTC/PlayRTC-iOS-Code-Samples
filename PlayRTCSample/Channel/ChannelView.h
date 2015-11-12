//
//  ChannelView.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//
#ifndef __ChannelView_h__
#define __ChannelView_h__

#import <UIKit/UIKit.h>
#import "PlayRTC.h"

@protocol ChannelViewListener <NSObject>

- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
- (void)onClickConnectChannel:(NSString*)channelId userId:(NSString*)userId;

@end

@interface ChannelView : UIView<UITextFieldDelegate>
{
    __weak id<ChannelViewListener> deletgate;
    __weak PlayRTC* playRTC;
}
@property (weak, nonatomic) id<ChannelViewListener> deletgate;
@property (weak, nonatomic) PlayRTC* playRTC;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;
- (void)show:(NSTimeInterval)delayed;
- (void)hide;
- (void)setChannelId:(NSString*)channelId;
- (void)showChannelList;
/*UITextFieldDelegate*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
#endif
