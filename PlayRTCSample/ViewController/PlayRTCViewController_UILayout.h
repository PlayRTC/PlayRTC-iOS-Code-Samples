//
//  PlayRTCViewController_UILayout.h
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#ifndef __PlayRTCViewController_UILayout_h__
#define __PlayRTCViewController_UILayout_h__

#import "PlayRTCViewController.h"
#import "PlayRTCViewController_PLayRTC.h"

@interface PlayRTCViewController(Layout)
{
    
    
}

- (void)initScreenLayoutView:(CGRect)frame;
- (void)initVideoLayoutView:(UIView*)parent videoFrame:(CGRect)videoFrame;
- (void)initLeftButtonLayout;
- (void)initRightButtonLayout:(CGRect)frame;
- (void)initRightTopButtonLayout;
- (void)rightBtnClick:(id)sender event:(UIEvent *)event;
- (void)leftBtnClick:(id)sender event:(UIEvent *)event;
- (void)rightTopBtnClick:(id)sender event:(UIEvent *)event;
- (void)appendLogView:(NSString*)insertingString;
- (void)progressLogView:(NSString*)insertingString;
- (void)showControlButtons;

@end

#endif

