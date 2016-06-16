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

/**
 * 채널 팝업에서 채널 생성 요청 버튼을 클릭 한 경우
 * channelName : NSString, 채널의 별칭
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickCreateChannel:(NSString*)channelName userId:(NSString*)userId;
/**
 * 채널 팝업에서 채널 입장 요청 버튼을 클릭 한 경우
 * chId : NSString, 채널의 아이디
 * userId : NSString, 사용자의 Application에서 사용하는 User-ID
 */
- (void)onClickConnectChannel:(NSString*)chId userId:(NSString*)userId;

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
