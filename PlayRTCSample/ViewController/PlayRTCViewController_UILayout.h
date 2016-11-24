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
 * - 스피커 출력 선택
 * - 카메라 전환
 * - 후방 플래쉬 전환
 * - 영상뷰Snapshot
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

- (void)leftTitleBarBtnClick:(id)sender;
- (void)rightTitleBarBtnClick:(id)sender;
- (void)rightBtnClick:(id)sender;
- (void)mirrorBtnClick:(id)sender;
- (void)leftBtnClick:(id)sender;
- (void)rightTopBtnClick:(id)sender;
- (void)appendLogView:(NSString*)insertingString;
- (void)progressLogView:(NSString*)insertingString;
- (void)showTopLeftControlButtons;

//v2.2.8 카메라 영상 회전 각도 지정 관련
- (void)degreeBtnClick:(id)sender;

/* SnapshotLayerObserver */
- (void)onClickSnapshotButton:(BOOL)localView;
@end

#endif

