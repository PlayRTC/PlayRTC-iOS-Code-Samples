//
//  PlayRTCViewController_UILayout.m
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayRTCViewController_UILayout.h"
#import "ExButton.h"

#define LOG_TAG @"PlayRTCViewController"
#define BOTTOMAREA_HEIGHT           100.0f
#define LOGVIEW_WIDTH               400.0f

@implementation PlayRTCViewController(Layout)

#pragma mark - PlayRTC Screen UI 구성
/*
 * 화면 UI 구성
 */
- (void) createViewControllerLayout:(CGRect)frame
{
    NSLog(@"[%@] initScreenLayoutView...", LOG_TAG);

    [self createTitleBarView:CGRectMake(0, 0, frame.size.width, 32)];
    
    [self createMainView:CGRectMake(0, 32.0f, frame.size.width, frame.size.height - 32)];
    
    [self createRightTopLayout];

    
    snapshotView = [[SnapshotLayerView alloc] initWithFrame:CGRectMake(0, 32.0f, frame.size.width, frame.size.height - 32)];
    snapshotView.hidden = TRUE;
    [snapshotView initializePannel:self];
    [self.view addSubview:snapshotView];

    
    // 채널 생성 또는 입장 할수 있는 팝업 UI 구성
    CGRect popFrame = CGRectMake(0, 0, mainAreaView.bounds.size.width, mainAreaView.bounds.size.height);
    popFrame.origin.y = 0;
    channelPopup = [[ChannelView alloc] initWithFrame:popFrame];
    channelPopup.playRTC = self.playRTC;
    channelPopup.deletgate = (id<ChannelViewListener>)self;
    [mainAreaView addSubview:channelPopup];
    
    // 0.8 초 후 화면 출력
    [channelPopup show:0.8f];
}

#pragma mark - TitleBar
/*
 * 화면 상단 타이틀바 영역 구성
 */
- (void)createTitleBarView:(CGRect)frame;
{
    UIView* titleBar = [[UIView alloc] initWithFrame:frame];
    titleBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:titleBar];
    
    UIButton* btnPrev = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, 100, 30)];
    btnPrev.backgroundColor = [UIColor clearColor];
    [btnPrev.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [btnPrev setTitle:@"이전화면" forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(leftTitleBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleBar addSubview:btnPrev];
    
    UILabel* lbPrev = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 238, 20)];
    lbPrev.backgroundColor = [UIColor clearColor];
    lbPrev.textAlignment = NSTextAlignmentCenter;
    lbPrev.font =[UIFont systemFontOfSize:18.0f];
    [lbPrev setTextColor:[UIColor whiteColor]];
    [lbPrev setText:@"PlayRTC Sample"];
    [titleBar addSubview:lbPrev];
    
    UIButton* btnFunc = [[UIButton alloc] initWithFrame:CGRectMake(560, 0, 110, 30)];
    btnFunc.backgroundColor = [UIColor clearColor];
    [btnFunc.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [btnFunc setTitle:@"미디어 Mute" forState:UIControlStateNormal];
    [btnFunc addTarget:self action:@selector(rightTitleBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleBar addSubview:btnFunc];

}

#pragma mark - 화면 좌측 컨트롤 버튼 구성
/*
 * 화면 좌측 컨트롤 버튼 영역
 * - 스피커 출력 선택
 * - 카메라 전환
 * - 후방 플래쉬 전환
 * - 영상뷰Snapshot
 * 스피커 출력 선택 버튼 : 이어폰을 연결한 상태가 아이라면 기본 출력은 EAR-SPEAKER.
 * 버튼을 눌렀을때 EAR-SPEAKER 와 SPEAKER 전환 처리
 * 이 기능을 사용하려면 PlayRTC의 enableAudioSession을 호출하여 활성화 시켜야함.
 * Sample에서는 PlayRTCViewController의 loadView에서 호출
 */
- (void)createMainLeftButtonLayout
{
    CGFloat width = 82.0f;
    CGFloat height = 38.0f;
    CGFloat posY = 8.0f;
    
    /**
     * type : int Sample App 유형
     *      1: 영상 + 음성 + Data
     *      2: 영상 + 음성
     *      3: 음성 Only
     *      4: Data Only
     */
    if(self.playrtcType < 3) {
        
        ExButton* sanpshotBtn = [[ExButton alloc] initWithFrame:CGRectMake(8.0f, posY, width, height)];
        [sanpshotBtn addTarget:self action:@selector(sanpshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sanpshotBtn.tag = 4;
        sanpshotBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [sanpshotBtn setTitle:@"스냅샷" forState:UIControlStateNormal];
        [sanpshotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:sanpshotBtn];
        
        posY += (height + 8.0f);
    }
    
    lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, posY, 106, 274)];
    lbStatus.backgroundColor = [UIColor clearColor];
    lbStatus.textAlignment = NSTextAlignmentLeft;
    lbStatus.font =[UIFont systemFontOfSize:11.0f];
    lbStatus.lineBreakMode = NSLineBreakByWordWrapping;
    lbStatus.numberOfLines = 0;
    lbStatus.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
    lbStatus.text = @"Local Report\n ICE:None\n 해상도:0x0x0\n 코덱:none,none\n BW:0Bps\n RTT:0\n RTT-R:0.00\n EM:0\n VFL:0.0000\n AFL:0.0000\n\nRemote Report\n ICE:None\n 해상도:0x0x0\n 코덱:none,none\n BW:0Bps\n VFL:0.0000\n AFL:0.0000";
    [mainAreaView addSubview:lbStatus];
    
}


#pragma mark - 화면 중앙 메인 화면 Contents 구성
/*
 * 화면 Contents 구성 
 * - 영상 출력 뷰
 * - 로그 뷰
 * - 화면 좌축 버튼 그룹 
 * - 화면 우측 버튼 그룹
 */
- (void)createMainView:(CGRect)frame
{
    mainAreaView = [[UIView alloc] initWithFrame:frame];
    mainAreaView.backgroundColor = [UIColor lightGrayColor];

    /* video 스트림 출력을 위한 PlayRTCVideoView
     * 가로-세로 비율 1(가로):0.75(세로), 높이 기준으로 폭 재 지정
     */
    CGRect videoFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    // 사이즈 조정, 높이 기준으로 4(폭):3(높이)으로 재 조정
    // 4:3 = width:height ,  width = ( 4 * height) / 3
    videoFrame.size.width = (4.0f * videoFrame.size.height) / 3.0f;
    videoFrame.origin.y=0;
    
    CGPoint videoFrameCenter = mainAreaView.center;
    videoFrameCenter.y -= 32;
    
    // PlayRTCVideoView의 부모 뷰 생성
    videoAreaView = [[UIView alloc] initWithFrame:videoFrame];
    videoAreaView.center = videoFrameCenter;
    videoAreaView.backgroundColor = [UIColor brownColor];
    
    // 부모 뷰에 PlayRTCVideoView 생성 추가
    if(playrtcType == 1 || playrtcType == 2)
    {
        [self createMainVideoLayout:videoAreaView videoFrame:videoAreaView.bounds];
    }
    [mainAreaView addSubview:videoAreaView];
    
    // PlayRTCVideoView 기준 왼쪽에 버튼 영역 생성
    // 소리 출력 버튼
    [self createMainLeftButtonLayout];
    
    // 로그 뷰 생성. 영상 뷰가 있을 경우 와 없는 경우를 다르게 구성
    // 1 : 영상 + 음성 + Data, 2: 영상 + 음성
    if(playrtcType == 1 || playrtcType == 2)
    {
        // 로그뷰를 hedden 뷰로 처리
        leftTopView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, LOGVIEW_WIDTH, frame.size.height)];
        leftTopView.backgroundColor = [UIColor whiteColor];
        leftTopView.font = [UIFont systemFontOfSize:12.0f];
        leftTopView.layer.cornerRadius = 3.0f;
        leftTopView.layer.borderWidth = 1.0f;
        leftTopView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        leftTopView.hidden = TRUE;
        leftTopView.editable = FALSE;
        leftTopView.scrollEnabled = YES;
        [mainAreaView addSubview:leftTopView];
    }
    else
    {
        // 로그뷰를 화면 중에 위치 시킴
        leftTopView = [[UITextView alloc] initWithFrame:videoFrame];
        leftTopView.backgroundColor = [UIColor whiteColor];
        leftTopView.font = [UIFont systemFontOfSize:12.0f];
        leftTopView.center = videoFrameCenter;
        leftTopView.layer.cornerRadius = 3.0f;
        leftTopView.layer.borderWidth = 1.0f;
        leftTopView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        leftTopView.hidden = FALSE;
        leftTopView.editable = FALSE;
        leftTopView.scrollEnabled = YES;
        [mainAreaView addSubview:leftTopView];
    }
    // 화면 우측 버튼영역 구성
    [self createMainRightButtonLayout];
    
    [self.view addSubview:mainAreaView];

}



// 화면 중앙에 영상 출력부를 구성한다.
- (void) createMainVideoLayout:(UIView*)parent videoFrame:(CGRect)videoFrame
{
    NSLog(@"[%@] initVideoLayoutView...", LOG_TAG);
    
    CGRect bounds = videoFrame;
    
    self.remoteVideoView =  [[PlayRTCVideoView alloc] initWithFrame:bounds];
    /*
     * 화면 배경색을 지정한다. R,G,B,A 0.0 ~ 1.0
     * 영상 스트림이 출력 되기 전, bgClearColor 호출 시 지정한 색으로 배경을 칠한다.
     * v2.2.4 추가
     */
    [self.remoteVideoView bgClearColorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    [self.remoteVideoView bgClearColor];
    
    CGRect localVideoFrame = videoFrame;
    localVideoFrame.size.width = localVideoFrame.size.width * 0.30f;
    localVideoFrame.size.height = localVideoFrame.size.height * 0.30f;
    localVideoFrame.origin.x = bounds.size.width - localVideoFrame.size.width - 10.0f;
    localVideoFrame.origin.y = 10.0f;
    
    
    self.localVideoView =  [[PlayRTCVideoView alloc] initWithFrame:localVideoFrame];
    /*
     * 화면 배경색을 지정한다. R,G,B,A 0.0 ~ 1.0
     * 영상 스트림이 출력 되기 전, bgClearColor 호출 시 지정한 색으로 배경을 칠한다.
     * v2.2.4 추가
     */
    [self.localVideoView bgClearColorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f];
    [self.localVideoView bgClearColor];
    
    
    [parent addSubview:self.remoteVideoView];
    [parent addSubview:self.localVideoView];
    
    CGFloat posX = 2.0f;
    CGFloat posY = 8.0f;
    CGFloat btnWidth = 70.0f;
    CGFloat btnHeight = 32.0f;
    CGFloat btnTSize = 13.0f;
    CGFloat lbWidth = 70.0f;
    CGFloat lbHeight = 18.0f;
    CGFloat lbTSize = 13.0f;
    
    ////////////////////////////////////////////////////////////////////////
    // 로컬 카메라 영상 출력 뷰 미러 보드 지정
    if(self.playrtcType < 3) {
        
        ExButton* mirrorBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [mirrorBtn addTarget:self action:@selector(mirrorModeLayerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        mirrorBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [mirrorBtn setTitle:@"미러모드" forState:UIControlStateNormal];
        [mirrorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:mirrorBtn];
        
        CGFloat mirrorHeight = 2 * (btnHeight) + (4.0f * 1) + 20.0f;
        CGRect layerMirrorRect = CGRectMake( (posX + btnWidth + 5.0f), posY, btnWidth + 5.0f, mirrorHeight);
        [self createMirrorButtons:(UIView*)parent frame:layerMirrorRect];
    }

    ////////////////////////////////////////////////////////////////////////
    // 소리 출력 장치 변경 Ear Speaker <-> Loud Speaker 전환
    // default Ear Speaker
    if(self.playrtcType < 4) {
        
        posY += btnHeight;
        lbSpeakerMode = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, lbWidth, lbHeight)];
        lbSpeakerMode.backgroundColor = [UIColor clearColor];
        lbSpeakerMode.textAlignment = NSTextAlignmentCenter;
        lbSpeakerMode.font =[UIFont systemFontOfSize:lbTSize];
        lbSpeakerMode.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
        lbSpeakerMode.text = @"Ear 스피커";
        [parent addSubview:lbSpeakerMode];
        
        posY += lbHeight;
        ExButton* btnSwichSpeaker = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnSwichSpeaker addTarget:self action:@selector(switchSpeakerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnSwichSpeaker.tag = 0;
        btnSwichSpeaker.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnSwichSpeaker setTitle:@"스피커전환" forState:UIControlStateNormal];
        [btnSwichSpeaker setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnSwichSpeaker];
    }

    ////////////////////////////////////////////////////////////////////////
    // 카메라 관련 기능 버튼
    if(self.playrtcType < 3) {
        posY += (btnHeight + 4.0f);
        ExButton* btnSwichCamera = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnSwichCamera addTarget:self action:@selector(switchCameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnSwichCamera.tag = 0;
        btnSwichCamera.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnSwichCamera setTitle:@"카메라전환" forState:UIControlStateNormal];
        [btnSwichCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnSwichCamera];
        
        posY += (btnHeight + 4.0f);
        ExButton* flashBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [flashBtn addTarget:self action:@selector(switchCameraFlashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        flashBtn.tag = 3;
        flashBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [flashBtn setTitle:@"Flash 전환" forState:UIControlStateNormal];
        [flashBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:flashBtn];
        
        // v2.2.8 카메라 영상 회전 각도 지정 관련
        posY += btnHeight;
        lbDegree = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, lbWidth, lbHeight)];
        lbDegree.backgroundColor = [UIColor clearColor];
        lbDegree.textAlignment = NSTextAlignmentCenter;
        lbDegree.font =[UIFont systemFontOfSize:lbTSize];
        lbDegree.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
        lbDegree.text = @"회전[0도]";
        [parent addSubview:lbDegree];
        
        posY += lbHeight;
        ExButton* btnCameraDegree = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnCameraDegree addTarget:self action:@selector(degreeLayerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnCameraDegree.tag = 0;
        btnCameraDegree.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnCameraDegree setTitle:@"영상회전" forState:UIControlStateNormal];
        [btnCameraDegree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnCameraDegree];
        
        CGFloat degreeHeight = 4 * (btnHeight) + (4.0f * 3);
        CGRect layerDegreeRect = CGRectMake( (posX + btnWidth + 5.0f), posY - (degreeHeight - btnHeight), btnWidth + 5.0f, degreeHeight);
        [self createDegreeButtons:parent frame:layerDegreeRect];
        
        posY += (btnHeight + 4.0f);
        ExButton* btnZoom = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnZoom addTarget:self action:@selector(cameraZoomLayerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnZoom.tag = 0;
        btnZoom.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnZoom setTitle:@"영상확대" forState:UIControlStateNormal];
        [btnZoom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnZoom];
        
        CGFloat zoomHeight = 260.0f;
        CGFloat rectY = (videoFrame.size.height / 2) - (zoomHeight/2);
        CGRect layerZoomRect = CGRectMake( (posX + btnWidth + 20.0f), rectY, 70.0f, zoomHeight);
        [self createZoomControlButtons:parent frame:layerZoomRect];
        
        
        posY += btnHeight;
        lbWhiteBalance = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, lbHeight)];
        lbWhiteBalance.backgroundColor = [UIColor clearColor];
        lbWhiteBalance.textAlignment = NSTextAlignmentCenter;
        lbWhiteBalance.font =[UIFont systemFontOfSize:lbTSize];
        lbWhiteBalance.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
        lbWhiteBalance.text = @"Auto";
        [parent addSubview:lbWhiteBalance];
        
        posY += lbHeight;
        ExButton* btnWhiteBalance = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnWhiteBalance addTarget:self action:@selector(whiteBalanceLayerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnWhiteBalance.tag = 0;
        btnWhiteBalance.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnWhiteBalance setTitle:@"화이트밸런스" forState:UIControlStateNormal];
        [btnWhiteBalance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnWhiteBalance];
        
        CGFloat wbHeight = 7 * (btnHeight) + (4.0f * 6);
        CGFloat wbRectY = (videoFrame.size.height / 2) - (wbHeight/2);
        CGRect layerWbRect = CGRectMake( (posX + btnWidth + 5.0f), wbRectY, btnWidth + 5.0f, wbHeight);
        [self createWhiteBalanceButtons:parent frame:layerWbRect];
        
        posY += (btnHeight+ 4.0f);
        ExButton* btnExposure = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [btnExposure addTarget:self action:@selector(exposureCompensationLayerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnExposure.tag = 0;
        btnExposure.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
        [btnExposure setTitle:@"노출보정" forState:UIControlStateNormal];
        [btnExposure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parent addSubview:btnExposure];
        
        CGFloat exposureHeight = 260.0f;
        rectY = (videoFrame.size.height / 2) - (zoomHeight/2);
        CGRect layerExposureRect = CGRectMake( (posX + btnWidth + 20.0f), rectY, 70.0f, exposureHeight);
        [self createExposureCompensationButtons:parent frame:layerExposureRect];
    }
}

#pragma mark - 화면 화면 우측 영역 버튼 생성
/*
 * 화면 우측 영역에 버튼 생성
 * 데이터 전송 버튼 : Text, Binary, FIle
 * 로그보기 버튼
 * 채널팝업 버튼
 * 종료 버튼
 */
- (void)createMainRightButtonLayout
{
    CGFloat btnHeight = 38.0f;
    CGFloat btnWidth = 80.0f; //
    CGFloat posX = mainAreaView.frame.size.width - (btnWidth + 5.0f);
    CGFloat posY = 5.0f;
    CGFloat fontSize = 15.0f;
    CGFloat lbtnTm = 6.0f;
   
    // 영상 + 음성 + Data , Data Only : DataChannel 사용 시 데이터 전송 버튼 구성
    if(playrtcType == 1 || playrtcType == 4)
    {
        ExButton* dcTextBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcTextBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcTextBtn.tag = 1;
        dcTextBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcTextBtn setTitle:@"텍스트전송" forState:UIControlStateNormal];
        [dcTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcTextBtn];
        
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcByteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcByteBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcByteBtn.tag = 2;
        dcByteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcByteBtn setTitle:@"Byte전송" forState:UIControlStateNormal];
        [dcByteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcByteBtn];
        
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcFileBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcFileBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcFileBtn.tag = 3;
        dcFileBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcFileBtn setTitle:@"파일전송" forState:UIControlStateNormal];
        [dcFileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcFileBtn];
        
        posY = posY + btnHeight + lbtnTm;
    }
    
    // 영상 + 음성 + Data , 영상 + 음성 : 화면 중앙에 영상뷰가 있으므로 로그뷰는 화면 좌측 Hidden 처리
    // 영상을 사용하지 않으면 로그뷰는 화면 중앙에 위치 하게 되므로 버튼 사용 않함
    if(playrtcType == 1 || playrtcType == 2)
    {
        ExButton* dcLogBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcLogBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcLogBtn.tag = 4;
        dcLogBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcLogBtn setTitle:@"로그보기" forState:UIControlStateNormal];
        [dcLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcLogBtn];
    }
    
    // 채널 팝업 보기 버튼
    posY = posY + btnHeight + lbtnTm;
    ExButton* chlPopupBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chlPopupBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chlPopupBtn.tag = 5;
    chlPopupBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chlPopupBtn setTitle:@"채널팝업" forState:UIControlStateNormal];
    [chlPopupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chlPopupBtn];
    
    
    posY = posY + btnHeight + lbtnTm;
    posY += 20.0f;
    
    // PlayRTC 채널 퇴장 버튼
    ExButton* chPeerCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chPeerCloseBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chPeerCloseBtn.tag = 6;
    chPeerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chPeerCloseBtn setTitle:@"채널퇴장" forState:UIControlStateNormal];
    [chPeerCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chPeerCloseBtn];
    
    posY = posY + btnHeight + lbtnTm;

    // PlayRTC 채널 종료 버튼
    ExButton* chCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chCloseBtn addTarget:self action:@selector(rightControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chCloseBtn.tag = 7;
    chCloseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chCloseBtn setTitle:@"채널종료" forState:UIControlStateNormal];
    [chCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chCloseBtn];
    
}

#pragma mark - 화면 Hidden 버튼 Layer
/*
 * 타이틀바의 기능버튼을 누르면 나오는 기능버튼 그룹 구성
 * 로컬 미디어 Mute 버튼
 * 상대방 미디어 Mute 버튼
 */
- (void)createRightTopLayout
{
    
    CGFloat lbHeight = 20.0f;
    CGFloat btnHeight = 38.0f;
    CGFloat btnWidth = 90.0f;
    CGFloat lbtnTm = 6.0f;
    CGFloat posX = 10;
    CGFloat posY = 5.0f;
    CGFloat btnTSize = 15.0f;
    CGFloat lbTSize = 15.0f;
    
    
    CGFloat viewWidth = btnWidth + (2 * posX);
    CGFloat viewHeight = (4 * btnHeight) + (2 * lbHeight) + (2 * posX) + (lbtnTm * 5);
    
    CGRect rightTopFrame = CGRectMake(mainAreaView.frame.size.width - viewWidth, 0, viewWidth, viewHeight);

    rightTopView = [[UIView alloc] initWithFrame:rightTopFrame];
    rightTopView.backgroundColor = [UIColor lightGrayColor];
    rightTopView.hidden = TRUE;
    rightTopView.layer.cornerRadius = 3.0f;
    [mainAreaView addSubview:rightTopView];


    UILabel* lMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, lbHeight)];
    lMuteLbl.backgroundColor = [UIColor clearColor];
    lMuteLbl.textAlignment = NSTextAlignmentCenter;
    lMuteLbl.font =[UIFont systemFontOfSize:lbTSize];
    lMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lMuteLbl.text = @"Local-Mute";
    [rightTopView addSubview:lMuteLbl];
    
    posY = posY + lbHeight + lbtnTm;
    ExButton* lVMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [lVMuteBtn addTarget:self action:@selector(mediaMuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lVMuteBtn.tag = 1;
    lVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [lVMuteBtn setTitle:@"영상-Off" forState:UIControlStateNormal];
    [lVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:lVMuteBtn];
    
    posY = posY + btnHeight + lbtnTm;
    ExButton* lAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [lAMuteBtn addTarget:self action:@selector(mediaMuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lAMuteBtn.tag = 2;
    lAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [lAMuteBtn setTitle:@"음성-Off" forState:UIControlStateNormal];
    [lAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:lAMuteBtn];
    
    posY = posY + btnHeight+ lbtnTm;
    UILabel* rMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, lbHeight)];
    rMuteLbl.backgroundColor = [UIColor clearColor];
    rMuteLbl.textAlignment = NSTextAlignmentCenter;
    rMuteLbl.font =[UIFont systemFontOfSize:lbTSize];
    rMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    rMuteLbl.text = @"Remote-Mute";
    [rightTopView addSubview:rMuteLbl];
    
    posY = posY + lbHeight + lbtnTm;
    ExButton* rVMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [rVMuteBtn addTarget:self action:@selector(mediaMuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rVMuteBtn.tag = 3;
    rVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [rVMuteBtn setTitle:@"영상-Off" forState:UIControlStateNormal];
    [rVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rVMuteBtn];
    
    posY = posY + btnHeight + lbtnTm;
    ExButton* rAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [rAMuteBtn addTarget:self action:@selector(mediaMuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rAMuteBtn.tag = 4;
    rAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [rAMuteBtn setTitle:@"음성-Off" forState:UIControlStateNormal];
    [rAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rAMuteBtn];

    
}

/*
 * 미러 모드 지정 버튼 영역 생성
 */
-(void)createMirrorButtons:(UIView*)parent frame:(CGRect)viewFrame
{
    CGFloat posX = 2.0f;
    CGFloat posY = 0.0f;
    CGFloat btnWidth = 70.0f;
    CGFloat btnHeight = 32.0f;
    CGFloat btnTSize = 13.0f;
    
    
    btnMirrorView  = [[UIView alloc] initWithFrame:viewFrame];
    btnMirrorView.hidden = TRUE;
    [parent addSubview:btnMirrorView];
    
    
    lbMirrorMode = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, viewFrame.size.width, 20.0f)];
    lbMirrorMode.backgroundColor = [UIColor clearColor];
    lbMirrorMode.textAlignment = NSTextAlignmentCenter;
    lbMirrorMode.font =[UIFont systemFontOfSize:17.0f];
    lbMirrorMode.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
    lbMirrorMode.text = @"미러-Off";
    [btnMirrorView addSubview:lbMirrorMode];
    
    posY += (20.0f);
    ExButton* btnMirrorOn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnMirrorOn addTarget:self action:@selector(mirrorModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnMirrorOn.tag = 1;
    btnMirrorOn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnMirrorOn setTitle:@"미러-On" forState:UIControlStateNormal];
    [btnMirrorOn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMirrorView addSubview:btnMirrorOn];
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnMirrorOff = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnMirrorOff addTarget:self action:@selector(mirrorModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnMirrorOff.tag = 0;
    btnMirrorOff.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnMirrorOff setTitle:@"미러-Off" forState:UIControlStateNormal];
    [btnMirrorOff setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMirrorView addSubview:btnMirrorOff];
    
}

/*
 * 카메라 영상 회전 각도 지정 버튼 영역 생성
 */
-(void)createDegreeButtons:(UIView*)parent frame:(CGRect)viewFrame
{
    CGFloat posX = 2.0f;
    CGFloat posY = 0.0f;
    CGFloat btnWidth = 70.0f;
    CGFloat btnHeight = 32.0f;
    CGFloat btnTSize = 13.0f;
    
    btnDegreeView  = [[UIView alloc] initWithFrame:viewFrame];
    btnDegreeView.hidden = TRUE;
    [parent addSubview:btnDegreeView];
    
    ExButton* camera0Btn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [camera0Btn addTarget:self action:@selector(degreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    camera0Btn.tag = 0;
    camera0Btn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [camera0Btn setTitle:@"0" forState:UIControlStateNormal];
    [camera0Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDegreeView addSubview:camera0Btn];
    
    posY += (btnHeight+ 4.0f);
    ExButton* camera90Btn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [camera90Btn addTarget:self action:@selector(degreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    camera90Btn.tag = 90;
    camera90Btn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [camera90Btn setTitle:@"90" forState:UIControlStateNormal];
    [camera90Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDegreeView addSubview:camera90Btn];
    
    posY += (btnHeight+ 4.0f);
    ExButton* camera180Btn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [camera180Btn addTarget:self action:@selector(degreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    camera180Btn.tag = 180;
    camera180Btn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [camera180Btn setTitle:@"180" forState:UIControlStateNormal];
    [camera180Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDegreeView addSubview:camera180Btn];
    
    posY += (btnHeight+ 4.0f);
    ExButton* camera270Btn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [camera270Btn addTarget:self action:@selector(degreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    camera270Btn.tag = 270;
    camera270Btn.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [camera270Btn setTitle:@"270" forState:UIControlStateNormal];
    [camera270Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDegreeView addSubview:camera270Btn];
    
}

/*
 * 카메라 줌 지정 버튼 영역 생성
 */
- (void)createZoomControlButtons:(UIView*)parent frame:(CGRect)viewFrame
{
    CGFloat width = viewFrame.size.width;
    CGFloat height = viewFrame.size.height;
    CGFloat posX = 0.0f;
    CGFloat posY = 0.0f;
    btnZoomView  = [[UIView alloc] initWithFrame:viewFrame];
    btnZoomView.hidden = TRUE;
    [parent addSubview:btnZoomView];
    
    lbZoomValue = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbZoomValue.backgroundColor = [UIColor clearColor];
    lbZoomValue.textAlignment = NSTextAlignmentCenter;
    lbZoomValue.font =[UIFont systemFontOfSize:17.0f];
    lbZoomValue.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbZoomValue.text = @"줌[1.00]";
    [btnZoomView addSubview:lbZoomValue];
    
    posY += 20.0f;
    lbMaxZoom = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbMaxZoom.backgroundColor = [UIColor clearColor];
    lbMaxZoom.textAlignment = NSTextAlignmentCenter;
    lbMaxZoom.font =[UIFont systemFontOfSize:17.0f];
    lbMaxZoom.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbMaxZoom.text = @"1.00";
    [btnZoomView addSubview:lbMaxZoom];
    
    posY += 20.0f;
    CGFloat sliderWidth = height - 40.0f;
    CGFloat sliderHeight = width;
    CGFloat sliderX = (sliderWidth / 2 * -1.0f) + (width / 2);
    CGFloat sliderY = (sliderWidth / 2) + 10;
    
    zoomSlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    [zoomSlider addTarget:self action:@selector(cameraZoomSliderAction:) forControlEvents:UIControlEventValueChanged];
    [zoomSlider setBackgroundColor:[UIColor clearColor]];
    zoomSlider.minimumValue = 1.0;
    zoomSlider.maximumValue = 1.0;
    zoomSlider.continuous = YES;
    zoomSlider.value = 1.0;
    [zoomSlider removeConstraints:btnZoomView.constraints];
    zoomSlider.translatesAutoresizingMaskIntoConstraints = YES;
    [btnZoomView addSubview:zoomSlider];
    zoomSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    posY += (height - 40.0f);
    
    lbMinZoom = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbMinZoom.backgroundColor = [UIColor clearColor];
    lbMinZoom.textAlignment = NSTextAlignmentCenter;
    lbMinZoom.font =[UIFont systemFontOfSize:17.0f];
    lbMinZoom.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbMinZoom.text = @"1.00";
    [btnZoomView addSubview:lbMinZoom];
    
}

- (void)createWhiteBalanceButtons:(UIView*)parent frame:(CGRect)viewFrame
{
    CGFloat posX = 0.0f;
    CGFloat posY = 0.0f;
    CGFloat btnWidth = 70.0f;
    CGFloat btnHeight = 32.0f;
    CGFloat btnTSize = 14.0f;
    
    btnWhiteBalanceView  = [[UIView alloc] initWithFrame:viewFrame];
    btnWhiteBalanceView.hidden = TRUE;
    [parent addSubview:btnWhiteBalanceView];
    
    
    ExButton* btnAuto = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnAuto addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnAuto.tag = 0;
    btnAuto.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnAuto setTitle:@"Auto" forState:UIControlStateNormal];
    [btnAuto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnAuto];
    
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnIncandescent = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnIncandescent addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnIncandescent.tag = 1;
    btnIncandescent.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnIncandescent setTitle:@"백열등" forState:UIControlStateNormal];
    [btnIncandescent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnIncandescent];
    
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnFluoreScent = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnFluoreScent addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnFluoreScent.tag = 2;
    btnFluoreScent.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnFluoreScent setTitle:@"형광등" forState:UIControlStateNormal];
    [btnFluoreScent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnFluoreScent];
    
    posY += (btnHeight+ 3.0f);
    ExButton* btnDayLight = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnDayLight addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnDayLight.tag = 3;
    btnDayLight.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnDayLight setTitle:@"햇빛" forState:UIControlStateNormal];
    [btnDayLight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnDayLight];
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnCloudyDayLight = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnCloudyDayLight addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnCloudyDayLight.tag = 4;
    btnCloudyDayLight.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnCloudyDayLight setTitle:@"구름" forState:UIControlStateNormal];
    [btnCloudyDayLight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnCloudyDayLight];
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnTwiLi = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnTwiLi addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnTwiLi.tag = 5;
    btnTwiLi.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnTwiLi setTitle:@"저녁빛" forState:UIControlStateNormal];
    [btnTwiLi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnTwiLi];
    
    posY += (btnHeight+ 4.0f);
    ExButton* btnShade = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [btnShade addTarget:self action:@selector(whiteBalanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnShade.tag = 6;
    btnShade.titleLabel.font = [UIFont systemFontOfSize:btnTSize];
    [btnShade setTitle:@"그늘" forState:UIControlStateNormal];
    [btnShade setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnWhiteBalanceView addSubview:btnShade];
}

- (void)createExposureCompensationButtons:(UIView*)parent frame:(CGRect)viewFrame
{
    CGFloat width = viewFrame.size.width;
    CGFloat height = viewFrame.size.height;
    CGFloat posX = 0.0f;
    CGFloat posY = 0.0f;
    btnExposureView  = [[UIView alloc] initWithFrame:viewFrame];
    btnExposureView.hidden = TRUE;
    [parent addSubview:btnExposureView];
    
    lbExposure = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbExposure.backgroundColor = [UIColor clearColor];
    lbExposure.textAlignment = NSTextAlignmentCenter;
    lbExposure.font =[UIFont systemFontOfSize:17.0f];
    lbExposure.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbExposure.text = @"0.00";
    [btnExposureView addSubview:lbExposure];
    
    
    posY += 20.0f;
    lbMaxExposure = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbMaxExposure.backgroundColor = [UIColor clearColor];
    lbMaxExposure.textAlignment = NSTextAlignmentCenter;
    lbMaxExposure.font =[UIFont systemFontOfSize:17.0f];
    lbMaxExposure.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbMaxExposure.text = @"0.00";
    [btnExposureView addSubview:lbMaxExposure];
    
    posY += 20.0f;
    CGFloat sliderWidth = height - 40.0f;
    CGFloat sliderHeight = width;
    CGFloat sliderX = (sliderWidth / 2 * -1.0f) + (width / 2);
    CGFloat sliderY = (sliderWidth / 2) + 10;
    
    exposureSlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    [exposureSlider addTarget:self action:@selector(exposureSliderAction:) forControlEvents:UIControlEventValueChanged];
    [exposureSlider setBackgroundColor:[UIColor clearColor]];
    exposureSlider.minimumValue = 0.0f;
    exposureSlider.maximumValue = 0.0f;
    exposureSlider.continuous = YES;
    exposureSlider.value = 0.0;
    [exposureSlider removeConstraints:btnExposureView.constraints];
    exposureSlider.translatesAutoresizingMaskIntoConstraints = YES;
    [btnExposureView addSubview:exposureSlider];
    exposureSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    
    posY += (height - 40.0f);
    
    lbMinExposure = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, 20.0f)];
    lbMinExposure.backgroundColor = [UIColor clearColor];
    lbMinExposure.textAlignment = NSTextAlignmentCenter;
    lbMinExposure.font =[UIFont systemFontOfSize:17.0f];
    lbMinExposure.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbMinExposure.text = @"0.00";
    [btnExposureView addSubview:lbMinExposure];
}

#pragma mark - Button CLick Event Handler

// 타이틀바 좌측 이전 버튼 이벤트 처리
- (void) leftTitleBarBtnClick:(id)sender
{
    NSLog(@"[%@] onLeftTitleBarButton Click !!!", LOG_TAG);
    
    if(isChannelConnected == TRUE) {

        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PlayRTC 종료"
                                                                       message:@"PlayRTC 채널에 입장해 있습니다.\n먼저 채널연결을 해제하세요."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"종료"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PlayRTC 종료"
                                                                   message:@"종료할까요?종료를 누르면 이전화면으로 이동합니다."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"종료"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                      {
                          [self closeViewController];
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"아니오"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

// 타이틀바 우측 미디어 Mute 버튼 이벤트 처리
- (void)rightTitleBarBtnClick:(id)sender
{
    
    NSLog(@"[%@] onRightTitleBarButton Click !!!", LOG_TAG);
    [self showMediaMuteBtnLayer];
}

// 화면 우축 버튼그룹의 이벤트 처리
- (void)rightControlBtnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 1) //TEXT 전송 버튼
    {
        [self performSelector:@selector(sendDataChannelText) withObject:nil afterDelay:0.1];
    }
    else if(tag == 2) // Byte 전송 버튼
    {
        [self performSelector:@selector(sendDataChannelBinary) withObject:nil afterDelay:0.1];
    }
    else if(tag == 3) // File 전송 버튼
    {
        [self performSelector:@selector(sendDataChannelFile) withObject:nil afterDelay:0.1];
    }
    else if(tag == 4) //로그보기 버튼
    {
        if(leftTopView.hidden == FALSE) {
            [UIView animateWithDuration:1.0 animations:^{ leftTopView.alpha = 0; }
                             completion: ^(BOOL finished) {  leftTopView.hidden = finished; } ];
        }
        else {
            leftTopView.alpha = 0;
            leftTopView.hidden = FALSE;
            [UIView animateWithDuration:1.0 animations:^{
                leftTopView.alpha = 1;
            }];
        }
    }
    else if(tag == 5) //Channel popup
    {
        [channelPopup show: 0.0f];
    }
    else if(tag == 6) //Channel 퇴장
    {
        [self performSelector:@selector(disconnectChannel) withObject:nil afterDelay:0.1];
    }
    else if(tag == 7) //Channel Close
    {
        [self performSelector:@selector(deleteChannel) withObject:nil afterDelay:0.1];
    }
}



/*
 * 미디어 Mute Layer 버튼 Click 처리
 */
- (void)mediaMuteBtnClick:(id)sender;
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    // tag 1 : Local Video Mute
    // tag 2 : Local Audio Mute
    // tag 3 : Remote Video Mute
    // tag 4 : Remote Audio Mute
    PlayRTCMedia* muteMedia = (tag < 3 ) ? self.localMedia : self.remoteMedia;
    if(muteMedia) {
        NSString* text = btn.currentTitle;
        BOOL isMute = [text hasSuffix:@"On"];
        if(tag % 2 == 1) {
            if([muteMedia setVideoMute:!isMute]) {
                [btn setTitle:@"영상-On" forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:@"영상-Off" forState:UIControlStateNormal];
            }
        }
        else {
            if([muteMedia setAudioMute:!isMute]) {
                [btn setTitle:@"음성-On" forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:@"음성-Off" forState:UIControlStateNormal];
            }
        }
    }
}

// 화면 좌측 스냅샷 버튼 클릭 이벤트 처리
- (void)sanpshotBtnClick:(id)sender
{
    [self hideAllControlLayer];
    snapshotView.hidden = FALSE;
}

// 로컬 영상 미러모드 출력 Layer 버튼 클릭 처리
- (void)mirrorModeLayerBtnClick:(id)sender
{
    if(btnMirrorView.hidden) {
        [self hideAllControlLayer];
        btnMirrorView.hidden = FALSE;
    }
    else {
        btnMirrorView.hidden = TRUE;
    }
    
}

// 로컬 영상 미러모드 출력 전환
- (void)mirrorModeBtnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    if(tag == 1)
    {
        // 미러모드 사용전환
        lbMirrorMode.text = @"미러-On";
        [localVideoView setMirror:TRUE];
        
    }
    else {
        // 미러모드 사용안함
        lbMirrorMode.text = @"미러-Off";
        [localVideoView setMirror:FALSE];
    }
}

// 음성 출력 정치 변경
- (void)switchSpeakerBtnClick:(id)sender
{
    [self hideAllControlLayer];
    BOOL isOn = [self switchLoudSpeaker];
    if(isOn) {
        lbSpeakerMode.text = @"Loud 스피커";
    }
    else {
        lbSpeakerMode.text = @"Ear 스피커";
    }
    
}

// 단말기 카메라 전환
- (void)switchCameraBtnClick:(id)sender
{
    [self hideAllControlLayer];
    [self switchCamera];
}

// 후방 카메라 사용시 플래쉬 전환
- (void)switchCameraFlashBtnClick:(id)sender
{
    [self hideAllControlLayer];
    [self switchCameraFlash];
}


//v2.2.8 카메라 영상 회전 각도 지정 Layer 버튼
- (void)degreeLayerBtnClick:(id)sender
{
    if(btnDegreeView.hidden) {
        [self hideAllControlLayer];
        btnDegreeView.hidden = FALSE;
    }
    else {
        btnDegreeView.hidden = TRUE;
    }
}

//v2.2.8 카메라 영상에 대한 추가 회전 각도 지정 관련
// 0, 90, 180, 270
// 미러모드(전방 카메라) 사용 시 시계 반대방향
- (void)degreeBtnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int degree = (int)btn.tag;
    
    degreelb.text = [NSString stringWithFormat:@"%d도", degree];
    [self setCameraRotation:degree];
    
}

// 2.2.9 카메라 줌 기능 Layer 버튼
// max 가 1.0 이면 줌 지원 않함.
- (void)cameraZoomLayerBtnClick:(id)sender
{
    if(playRTC == nil) {
        return;
    }
    if(btnZoomView.hidden) {
        [self hideAllControlLayer];
        ValueRange* range = [self getCameraZoomRange];
        zoomSlider.minimumValue = [[range minValue] floatValue];
        zoomSlider.maximumValue = [[range maxValue] floatValue];
        float zoomValue = [self getCurrentCameraZoom];
        
        zoomSlider.value = zoomValue;
        lbMinZoom.text = [NSString stringWithFormat:@"%0.2f", zoomSlider.minimumValue];
        lbMaxZoom.text = [NSString stringWithFormat:@"%0.2f", zoomSlider.maximumValue];
        lbZoomValue.text = [NSString stringWithFormat:@"줌[%0.2f]", zoomValue];
        btnZoomView.hidden = FALSE;
    }
    else {
        btnZoomView.hidden = TRUE;
    }
}

// 2.2.9 카메라 줌 기능 설정 Slider
-(void)cameraZoomSliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    if([self setCameraZoom:value] ) {
        lbZoomValue.text = [NSString stringWithFormat:@"줌[%0.2f]", value];
    }
}

- (void)whiteBalanceLayerBtnClick:(id)sender
{
    if(playRTC) {
        if(btnWhiteBalanceView.hidden == TRUE) {
            [self hideAllControlLayer];
            PlayRTCWhiteBalance whiteBalance = [self getCameraWhiteBalance];
            [self displayWhiteBalanceText:whiteBalance];
            btnWhiteBalanceView.hidden = FALSE;
        }
        else {
            btnWhiteBalanceView.hidden = TRUE;
        }
    }
    
}
- (void)whiteBalanceBtnClick:(id)sender
{
    PlayRTCWhiteBalance whiteBalance;
    int tag = (int)((UIButton*)sender).tag;
    if(tag == 0) {
        whiteBalance = PlayRTCWhiteBalanceAuto;
    }
    else if(tag == 1) {
        whiteBalance = PlayRTCWhiteBalanceIncandescent;
    }
    else if(tag == 2) {
        whiteBalance = PlayRTCWhiteBalanceFluoreScent;
    }
    else if(tag == 3) {
        whiteBalance = PlayRTCWhiteBalanceDayLight;
    }
    else if(tag == 4) {
        whiteBalance = PlayRTCWhiteBalanceCloudyDayLight;
    }
    else if(tag == 5) {
        whiteBalance = PlayRTCWhiteBalanceTwiLi;
    }
    else { //tag == 6)
        whiteBalance = PlayRTCWhiteBalanceShade;
    }
    
    BOOL result = [self setCameraWhiteBalance:whiteBalance];
    if(result == TRUE) {
        [self displayWhiteBalanceText:whiteBalance];
    }
}

- (void)displayWhiteBalanceText:(PlayRTCWhiteBalance)whiteBalance
{
    if(whiteBalance == PlayRTCWhiteBalanceAuto) {
        lbWhiteBalance.text = @"Auto";
    }
    else if(whiteBalance == PlayRTCWhiteBalanceIncandescent) {
        lbWhiteBalance.text = @"백열등";
    }
    else if(whiteBalance == PlayRTCWhiteBalanceFluoreScent) {
        lbWhiteBalance.text = @"형광등";
    }
    else if(whiteBalance == PlayRTCWhiteBalanceDayLight) {
        lbWhiteBalance.text = @"햇빛";
    }
    else if(whiteBalance == PlayRTCWhiteBalanceCloudyDayLight) {
        lbWhiteBalance.text = @"구름";
    }
    else if(whiteBalance == PlayRTCWhiteBalanceTwiLi) {
        lbWhiteBalance.text = @"저녁빛";
    }
    else {
        lbWhiteBalance.text = @"그늘";
    }
    
}


- (void)exposureCompensationLayerBtnClick:(id)sender
{
    if(playRTC) {
        if(btnExposureView.hidden) {
            [self hideAllControlLayer];
            exposureRange = [self getCameraExposureCompensationRange];
            float min = [exposureRange minValue].floatValue;
            float max = [exposureRange maxValue].floatValue;
            float exposureLevel = [self getCameraExposureCompensation];
            
            
            exposureSlider.minimumValue = 0;
            exposureSlider.maximumValue = (max * 2.0f);
            exposureSlider.value = exposureLevel + max;
            lbExposure.text = [NSString stringWithFormat:@"%0.2f", exposureLevel];
            lbMinExposure.text = [NSString stringWithFormat:@"%0.2f", min];
            lbMaxExposure.text = [NSString stringWithFormat:@"%0.2f", max];
            
            btnExposureView.hidden = FALSE;
        }
        else {
            btnExposureView.hidden = TRUE;
        }
        
        
    }
}
- (void)exposureSliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float max = [exposureRange maxValue].floatValue;
    
    float exposureLevel = slider.value - max;
    BOOL result = [self setCameraExposureCompensation:exposureLevel];
    if( result == TRUE) {
        lbExposure.text = [NSString stringWithFormat:@"%0.2f", exposureLevel];
    }
    
    NSLog(@"[%@] exposureSliderAction exposureLevel=%0.2f result=%d", LOG_TAG, exposureLevel, result);
}


#pragma mark - SnapshotLayerObserver
-(void)onClickSnapshotButton:(BOOL)localView
{
    
    if(localView == TRUE)
    {
        
        [self localViewSnapshot];
        
    }
    else {
        
        [self remoteViewSnapshot];
    }
    
}


#pragma mark - Private  
/*
 * 타이틀바 우측 미디어 Mute 버튼을 누르면 버튼 Layer View 출력 처리
 */
- (void)showMediaMuteBtnLayer
{
    if(rightTopView.hidden == FALSE) {
        [UIView animateWithDuration:0.8f animations:^{ rightTopView.alpha = 0; }
                         completion: ^(BOOL finished) {  rightTopView.hidden = finished; } ];
    }
    else {
        rightTopView.alpha = 0;
        rightTopView.hidden = FALSE;
        [UIView animateWithDuration:0.8f animations:^{
            rightTopView.alpha = 1;
        }];
        
    }
}

- (void)appendLogView:(NSString*)insertingString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(hasPrevText == TRUE)
        {
            hasPrevText = FALSE;
            self.prevText = @"";
        }
        leftTopView.text = [NSString stringWithFormat:@"%@%@\n",leftTopView.text, insertingString];
        NSRange range = NSMakeRange(leftTopView.text.length - 1, 1);
        [leftTopView scrollRangeToVisible:range];
    });
    
}
- (void)progressLogView:(NSString*)insertingString
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(hasPrevText == FALSE)
        {
            hasPrevText = TRUE;
            self.prevText = leftTopView.text;
        }
        NSString* msg = [NSString stringWithFormat:@"%@%@\n", self.prevText, insertingString];
        
        leftTopView.text = msg;
        NSRange range = NSMakeRange(leftTopView.text.length - 1, 1);
        [leftTopView scrollRangeToVisible:range];
        
    });
}

- (void)hideAllControlLayer
{
    btnMirrorView.hidden = TRUE;
    btnDegreeView.hidden = TRUE;
    btnZoomView.hidden = TRUE;
    btnWhiteBalanceView.hidden = TRUE;
    btnExposureView.hidden = TRUE;
    
}

@end
