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
// 화면 상단 타이틀바 영역 구성
- (void)createTitleBarView:(CGRect)frame;
// 화면 Contents 구성
- (void)createMainView:(CGRect)frame;

/*
 * 화면 좌측 컨트롤 버튼 영역
 * - 영상뷰 Snapshot
 */
- (void)createMainLeftButtonLayout;

// 화면 중앙에 영상 출력부를 구성한다.
- (void)createMainVideoLayout:(UIView*)parent videoFrame:(CGRect)videoFrame;

/*
 * 화면 우축영역에 버튼 생성
 * 데이터 전송 버튼 : Text, Binary, FIle
 * 로그보기 버튼
 * 채널팝업 버튼
 * 종료 버튼
 */
- (void)createMainRightButtonLayout;

/*
 * 타이틀바의 기능버튼을 누르면 나오는 기능버튼 그룹 구성
 * 로컬 미디어 Mute 버튼
 * 상대방 미디어 Mute 버튼
 */
- (void)createRightTopLayout;

// 미러 모드 지정 버튼 영역 생성
- (void)createMirrorButtons:(UIView*)parent frame:(CGRect)viewFrame;
// 카메라 영상 회전 각도 지정 버튼 영역 생성
- (void)createDegreeButtons:(UIView*)parent frame:(CGRect)viewFrame;
// 카메라 줌 지정 버튼 영역 생성
- (void)createZoomControlButtons:(UIView*)parent frame:(CGRect)viewFrame;
//카메라 화이트밸런스 버튼 영역 생성
- (void)createWhiteBalanceButtons:(UIView*)parent frame:(CGRect)viewFrame;
//카메라 노출보정 버튼 영역 생성
- (void)createExposureCompensationButtons:(UIView*)parent frame:(CGRect)viewFrame;

- (void)leftTitleBarBtnClick:(id)sender;
- (void)rightTitleBarBtnClick:(id)sender;
- (void)rightControlBtnClick:(id)sender;


- (void)mediaMuteBtnClick:(id)sender;
- (void)sanpshotBtnClick:(id)sender;

- (void)mirrorModeLayerBtnClick:(id)sender;
- (void)mirrorModeBtnClick:(id)sender;
- (void)switchSpeakerBtnClick:(id)sender;
- (void)switchCameraBtnClick:(id)sender;
- (void)switchCameraFlashBtnClick:(id)sender;
//v2.2.8 카메라 영상 회전 각도 지정 컨트롤 뷰 버튼
- (void)degreeLayerBtnClick:(id)sender;
//v2.2.8 카메라 영상 회전 각도 지정 관련
- (void)degreeBtnClick:(id)sender;
//v2.2.9 카메라 Zoom 지정 컨트롤 뷰 버튼
- (void)cameraZoomLayerBtnClick:(id)sender;
//v2.2.9 카메라 Zoom 지정 컨트롤 Slider Event
- (void)cameraZoomSliderAction:(id)sender;
//v2.2.9 카메라 화이트밸런스 지정 컨트롤 뷰 버튼
- (void)whiteBalanceLayerBtnClick:(id)sender;
//v2.2.9 카메라 화이트밸런스 지정 버튼
- (void)whiteBalanceBtnClick:(id)sender;
- (void)displayWhiteBalanceText:(PlayRTCWhiteBalance)whiteBalance;
//v2.2.9 카메라 노출보정 지정 컨트롤 뷰 버튼
- (void)exposureCompensationLayerBtnClick:(id)sender;
//v2.2.9 카메라 노출보정 지정 컨트롤 Slider Event
- (void)exposureSliderAction:(id)sender;

- (void)showMediaMuteBtnLayer;
- (void)appendLogView:(NSString*)insertingString;
- (void)progressLogView:(NSString*)insertingString;
- (void)hideAllControlLayer;

/* SnapshotLayerObserver */
- (void)onClickSnapshotButton:(BOOL)localView;
@end

#endif

