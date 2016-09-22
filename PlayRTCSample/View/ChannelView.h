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


/*
 * ChannelView의 이벤트를 받기 위한 인터페이스 
 */
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

/*
 채널을 생성하거나 만들어진 채널 목록을 조회하여 채널에 입장하는 UI를 제공
 USER-A는 먼저 채널을 생성해야 하며
 USER-B는 채널 생성 시 발급된 채널 아이디로 채널에 입장해야 한다.
 */
@interface ChannelView : UIView<UITextFieldDelegate>
{
    __weak id<ChannelViewListener> deletgate;
    __weak PlayRTC* playRTC;
}
@property (weak, nonatomic) id<ChannelViewListener> deletgate;
@property (weak, nonatomic) PlayRTC* playRTC;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;

// 채널 팝업뷰를 Fade-In 효과를 주어 화면에 표시한다.
// delayed : 화면에 출력전 지연 시간을 지정 
- (void)show:(NSTimeInterval)delayed;

// 채널 팝업뷰를 화면에서 숨긴다.
- (void)hide;

// 채널 생성 성공 시 채널 아이디를 화면에 표시하기 전달 받는다.
- (void)setChannelId:(NSString*)channelId;

// 채널 목록 리스트를 조회하고 화면에 출력한다.
- (void)showChannelList;

/*UITextFieldDelegate*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
#endif
