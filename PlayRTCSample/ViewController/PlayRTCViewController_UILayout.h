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

@interface PlayRTCViewController(Layout)<SnapshotLayerObserver>

// 화면 설정 시작
- (void)createViewControllerLayout:(CGRect)frame;
- (void)createTitleBarView:(CGRect)frame;
- (void)createMainView:(CGRect)videoFrame;

- (void)createMainLeftButtonLayout;
- (void)createMainVideoLayout:(UIView*)parent videoFrame:(CGRect)videoFrame;
- (void)createMainRightButtonLayout;
- (void)createRightTopLayout;

- (void)leftTitleBarBtnClick:(id)sender;
- (void)rightTitleBarBtnClick:(id)sender;
- (void)rightBtnClick:(id)sender;
- (void)leftBtnClick:(id)sender;
- (void)rightTopBtnClick:(id)sender;
- (void)appendLogView:(NSString*)insertingString;
- (void)progressLogView:(NSString*)insertingString;
- (void)showTopLeftControlButtons;

/* SnapshotLayerObserver */
- (void)onClickSnapshotButton:(BOOL)localView;
@end

#endif

