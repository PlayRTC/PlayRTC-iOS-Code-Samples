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
#define RBTNAREA_WIDTH              145.0f
#define BTN_WIDTH                   130.0f
#define BTN_HEIGHT                  40.0f

@implementation PlayRTCViewController(Layout)

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
    
    UIButton* btnFunc = [[UIButton alloc] initWithFrame:CGRectMake(560, 0, 100, 30)];
    btnFunc.backgroundColor = [UIColor clearColor];
    [btnFunc.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [btnFunc setTitle:@"미디어버튼" forState:UIControlStateNormal];
    [btnFunc addTarget:self action:@selector(rightTitleBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleBar addSubview:btnFunc];

}

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
/*
 * 우측 hidden 버튼 영역 보이기. 타이븥바의 기능버튼을 누르면 출력 처리
 */
- (void)showTopLeftControlButtons
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
    CGFloat width = 95.0f; // BTN_WIDTH
    CGFloat height = BTN_HEIGHT * 1.2f;
    CGFloat posX = 5.0f;
    CGFloat posY = 0.0f;
    /**
     * type : int Sample App 유형
     *      1: 영상 + 음성 + Data
     *      2: 영상 + 음성
     *      3: 음성 Only
     *      4: Data Only
     */
    if(self.playrtcType < 4) {
        posY = posY + height+ 5.0f;
        ExButton* speakBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [speakBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        speakBtn.tag = 1;
        speakBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [speakBtn setTitle:@"Loud Speaker" forState:UIControlStateNormal];
        [speakBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:speakBtn];
    }
    if(self.playrtcType < 3) {
        posY = posY + height + 15.0f;
        ExButton* cameraBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [cameraBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cameraBtn.tag = 2;
        cameraBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cameraBtn setTitle:@"카메라 전환" forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:cameraBtn];
        
        
        posY = posY + height + 15.0f;
        ExButton* flashBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [flashBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        flashBtn.tag = 3;
        flashBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [flashBtn setTitle:@"Flash 전환" forState:UIControlStateNormal];
        [flashBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:flashBtn];

        posY = posY + height + 15.0f;
        ExButton* sanpshotBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [sanpshotBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sanpshotBtn.tag = 4;
        sanpshotBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [sanpshotBtn setTitle:@"Snapshot" forState:UIControlStateNormal];
        [sanpshotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:sanpshotBtn];
    }

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
    
    
}

/*
 * 화면 우축영역에 버튼 생성
 * 데이터 전송 버튼 : Text, Binary, FIle
 * 로그보기 버튼
 * 채널팝업 버튼
 * 종료 버튼
 */
- (void)createMainRightButtonLayout
{
    CGFloat btnHeight = BTN_HEIGHT - 2;
    CGFloat btnWidth = 80.0f; // BTN_WIDTH
    CGFloat posX = mainAreaView.frame.size.width - (btnWidth + 5.0f);
    CGFloat posY = 5.0f;
    CGFloat fontSize = 15.0f;
    CGFloat lbtnTm = 6.0f;
   
    // 영상 + 음성 + Data , Data Only : DataChannel 사용 시 데이터 전송 버튼 구성
    if(playrtcType == 1 || playrtcType == 4)
    {
        ExButton* dcTextBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcTextBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcTextBtn.tag = 1;
        dcTextBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcTextBtn setTitle:@"텍스트전송" forState:UIControlStateNormal];
        [dcTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcTextBtn];
    
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcByteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcByteBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcByteBtn.tag = 2;
        dcByteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcByteBtn setTitle:@"Byte전송" forState:UIControlStateNormal];
        [dcByteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcByteBtn];
    
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcFileBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcFileBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        [dcLogBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        dcLogBtn.tag = 4;
        dcLogBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcLogBtn setTitle:@"로그보기" forState:UIControlStateNormal];
        [dcLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcLogBtn];
    }
    
    // 채널 팝업 보기 버튼
    posY = posY + btnHeight + lbtnTm;
    ExButton* chlPopupBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chlPopupBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chlPopupBtn.tag = 5;
    chlPopupBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chlPopupBtn setTitle:@"채널팝업" forState:UIControlStateNormal];
    [chlPopupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chlPopupBtn];
    
    
    posY = posY + btnHeight + lbtnTm;
    posY += 20.0f;
    
    // PlayRTC 채널 퇴장 버튼
    ExButton* chPeerCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chPeerCloseBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chPeerCloseBtn.tag = 6;
    chPeerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chPeerCloseBtn setTitle:@"채널퇴장" forState:UIControlStateNormal];
    [chPeerCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chPeerCloseBtn];
    
    posY = posY + btnHeight + lbtnTm;

    // PlayRTC 채널 종료 버튼
    ExButton* chCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chCloseBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chCloseBtn.tag = 7;
    chCloseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chCloseBtn setTitle:@"채널종료" forState:UIControlStateNormal];
    [chCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chCloseBtn];
    
}

/*
 * 타이틀바의 기능버튼을 누르면 나오는 기능버튼 그룹 구성
 * 로컬 미디어 Mute 버튼
 * 상대방 미디어 Mute 버튼
 */
- (void)createRightTopLayout
{
    
    CGRect rightTopFrame = CGRectMake(mainAreaView.frame.size.width - RBTNAREA_WIDTH, 0, RBTNAREA_WIDTH, mainAreaView.frame.size.height);

    rightTopView = [[UIView alloc] initWithFrame:rightTopFrame];
    rightTopView.backgroundColor = [UIColor lightGrayColor];
    rightTopView.hidden = TRUE;
    rightTopView.layer.cornerRadius = 3.0f;
    [mainAreaView addSubview:rightTopView];

    
    
    CGFloat labelHeight = 20.0f;
    CGFloat btnHeight = BTN_HEIGHT - 2;
    CGFloat lbtnTm = 6.0f;
    CGFloat posX = 10;
    CGFloat posY = 5.0f;
    CGFloat fontSize = 16.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        btnHeight+= 12.0f;
        lbtnTm = 10.0f;
        posY = 10.0f;
        fontSize = 18.0f;
    }
    
    
    UILabel* lMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, labelHeight)];
    lMuteLbl.backgroundColor = [UIColor clearColor];
    lMuteLbl.textAlignment = NSTextAlignmentCenter;
    lMuteLbl.font =[UIFont systemFontOfSize:18.0f];
    lMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lMuteLbl.text = @"Local-Mute";
    [rightTopView addSubview:lMuteLbl];
    
    posY = posY + labelHeight + lbtnTm;
    ExButton* lVMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [lVMuteBtn addTarget:self action:@selector(rightTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lVMuteBtn.tag = 1;
    lVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [lVMuteBtn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
    [lVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:lVMuteBtn];
    
    posY = posY + btnHeight + lbtnTm;
    ExButton* lAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [lAMuteBtn addTarget:self action:@selector(rightTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lAMuteBtn.tag = 2;
    lAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [lAMuteBtn setTitle:@"AUDIO_OFF" forState:UIControlStateNormal];
    [lAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:lAMuteBtn];
    
    posY = posY + btnHeight+ 20.0f;
    UILabel* rMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, labelHeight)];
    rMuteLbl.backgroundColor = [UIColor clearColor];
    rMuteLbl.textAlignment = NSTextAlignmentCenter;
    rMuteLbl.font =[UIFont systemFontOfSize:18.0f];
    rMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    rMuteLbl.text = @"Remote-Mute";
    [rightTopView addSubview:rMuteLbl];
    
    posY = posY + labelHeight + 10.0f;
    ExButton* rVMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [rVMuteBtn addTarget:self action:@selector(rightTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rVMuteBtn.tag = 3;
    rVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [rVMuteBtn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
    [rVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rVMuteBtn];
    
    posY = posY + btnHeight + 10.0f;
    ExButton* rAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [rAMuteBtn addTarget:self action:@selector(rightTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rAMuteBtn.tag = 4;
    rAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [rAMuteBtn setTitle:@"AUDIO_OFF" forState:UIControlStateNormal];
    [rAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rAMuteBtn];
    
}


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

- (void)rightTitleBarBtnClick:(id)sender
{
    
    NSLog(@"[%@] onRightTitleBarButton Click !!!", LOG_TAG);
    [self showTopLeftControlButtons];
}

// 화면 우축 버튼그룹의 이벤트 처리
- (void)rightBtnClick:(id)sender
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

// 소리 출력 버튼 이벤트
// EAR-SPEAKER와 SPEARKER 전환
// 기본 상태는 EAR-SPEAKER
- (void)leftBtnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    // SPEAKER 출력 출력 시 출력 스피커 전환 버튼 이벤트
    // EAR-SPEAKER와 LOUD-SPEARKER 전환
    // 기본 상태는 EAR-SPEAKER
    if(tag == 1)
    {
        BOOL isOn = [self switchLoudSpeaker];
        if(isOn) {
            [btn setTitle:@"Ear Speaker" forState:UIControlStateNormal];
        }
        else {
            [btn setTitle:@"Loud Speaker" forState:UIControlStateNormal];
        }
        
    }
    // channel 연결 후 카메라 전환
    else if(tag == 2)
    {
        [self switchCamera];
    }
    // channel 연결 후 후방 카메라 Flash 전환
    else if(tag == 3)
    {
        [self switchFlash];
    }
    // snapshot view
    else if(tag == 4) {
        snapshotView.hidden = FALSE;
    }}


- (void)rightTopBtnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 1) //Local Video Mute
    {
        if(self.localMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([localMedia setVideoMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"VIDEO_ON" forState:UIControlStateNormal];
                }
            }
        }
    }
    else if(tag == 2) //Local Audio Mute
    {
        if(self.localMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([localMedia setAudioMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"AUDIO_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"AUDIO_ON" forState:UIControlStateNormal];
                }
            }
        }
        
    }
    else if(tag == 3) //Remote Video Mute
    {
        if(self.remoteMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([remoteMedia setVideoMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"VIDEO_ON" forState:UIControlStateNormal];
                }
            }
        }
        
    }
    else if(tag == 4) //Remote Audio Mute
    {
        if(self.remoteMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([remoteMedia setAudioMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"AUDIO_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"AUDIO_ON" forState:UIControlStateNormal];
                }
            }
        }
        
    }

}

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


@end
