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
- (void) initScreenLayoutView:(CGRect)frame
{
    NSLog(@"[%@] initScreenLayoutView...", LOG_TAG);
    CGRect bounds = frame;
    CGRect mainFrame = bounds;
    mainFrame.origin.y = 0;
    mainFrame.size.height = bounds.size.height;
    
    
    mainAreaView = [[UIView alloc] initWithFrame:mainFrame];
    mainAreaView.backgroundColor = [UIColor whiteColor];
    
    /* video 스트림 출력을 위한 PlayRTCVideoView
     * 가로-세로 비율 1(가로):0.75(세로), 높이 기준으로 폭 재 지정
     */
    CGRect videoFrame = mainFrame;
    videoFrame.size.height = mainFrame.size.height;
    // 사이즈 조정, 높이 기준으로 4(폭):3(높이)으로 재 조정
    // 4:3 = width:height ,  width = ( 4 * height) / 3
    videoFrame.size.width = (4.0f * videoFrame.size.height) / 3.0f;
    videoFrame.origin.y=0;
    
    // PlayRTCVideoView의 부모 뷰 생성
    videoAreaView = [[UIView alloc] initWithFrame:videoFrame];
    videoAreaView.center = mainAreaView.center;
    videoAreaView.backgroundColor = [UIColor brownColor];
    
    // 부모 뷰에 PlayRTCVideoView 생성 추가
    if(playrtcType == 1 || playrtcType == 2)
    {
        [self initVideoLayoutView:videoAreaView videoFrame:videoAreaView.bounds];
    }
    [mainAreaView addSubview:videoAreaView];
    
    // PlayRTCVideoView 기준 왼쪽에 버튼 영역 생성
    // 소리 출력 버튼
    [self initLeftButtonLayout];
    
    // 로그 뷰 생성. 영상 뷰가 있을 경우 와 없는 경우를 다르게 구성
    // 1 : 영상 + 음성 + Data, 2: 영상 + 음성
    if(playrtcType == 1 || playrtcType == 2)
    {
        CGRect leftopFrame = mainFrame;
        leftopFrame.size.width = LOGVIEW_WIDTH;
    
        // 로그뷰를 hedden 뷰로 처리
        leftTopView = [[UITextView alloc] initWithFrame:leftopFrame];
        leftTopView.backgroundColor = [UIColor whiteColor];
        leftTopView.font = [UIFont systemFontOfSize:12.0f];
        leftTopView.hidden = TRUE;
        leftTopView.editable = FALSE;
        leftTopView.scrollEnabled = YES;
        [mainAreaView addSubview:leftTopView];
    }
    else
    {
        // 로그뷰를 화면 중에 위치 시킴
        CGRect leftopFrame = videoAreaView.bounds;
        leftTopView = [[UITextView alloc] initWithFrame:leftopFrame];
        leftTopView.backgroundColor = [UIColor whiteColor];
        leftTopView.font = [UIFont systemFontOfSize:12.0f];
        leftTopView.hidden = FALSE;
        leftTopView.editable = FALSE;
        leftTopView.scrollEnabled = YES;
        [videoAreaView addSubview:leftTopView];
    }
    
    // 화면 우측 버튼영역 구성
    [self initRightButtonLayout:mainFrame];
    
    // 우측 hidden 버튼 영역 생성 . 타이븥바의 기능버튼을 누르면 출력 처리
    CGRect rightTopFrame = mainFrame;
    rightTopFrame.size.width = RBTNAREA_WIDTH;
    rightTopFrame.origin.x = mainFrame.size.width - RBTNAREA_WIDTH;
    
    rightTopView = [[UIView alloc] initWithFrame:rightTopFrame];
    rightTopView.backgroundColor = [UIColor yellowColor];
    rightTopView.hidden = TRUE;
    [mainAreaView addSubview:rightTopView];
    
   
    [self.view addSubview:mainAreaView];
    
    [self initRightTopButtonLayout];

    // 채널 생성 또는 입장 할수 있는 팝업 UI 구성
    CGRect popFrame = mainFrame;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        popFrame.size.height = popFrame.size.height * 0.80f;
        popFrame.size.width = popFrame.size.height / 0.75f;
    }
    

    channelPopup = [[ChannelView alloc] initWithFrame:popFrame];
    channelPopup.center = mainAreaView.center;
    channelPopup.playRTC = self.playRTC;
    channelPopup.deletgate = (id<ChannelViewListener>)self;
    [mainAreaView addSubview:channelPopup];
    
    // 0.8 초 후 화면 출력
    [channelPopup show:0.8f];
}

/*
 * 우측 hidden 버튼 영역 보이기. 타이븥바의 기능버튼을 누르면 출력 처리
 */
- (void)showControlButtons
{
    if(rightTopView.hidden == FALSE) {
        [UIView animateWithDuration:1.0 animations:^{ rightTopView.alpha = 0; }
                         completion: ^(BOOL finished) {  rightTopView.hidden = finished; } ];
    }
    else {
        rightTopView.alpha = 0;
        rightTopView.hidden = FALSE;
        [UIView animateWithDuration:1.0 animations:^{
            rightTopView.alpha = 1;
        }];
        
    }
}

/*
 * 스피커 출력 선택 버튼
 * 이어폰을 연결한 상태가 아이라면 기본 출력은 EAR-SPEAKER.
 * 버튼을 눌렀을때 EAR-SPEAKER 와 SPEAKER 전환 처리
 * 이 기능을 사용하려면 PlayRTC의 enableAudioSession을 호출하여 활성화 시켜야함.
 * Sample에서는 PlayRTCViewController의 loadView에서 호출
 */
- (void)initLeftButtonLayout
{
    CGFloat width = 80.0f; // BTN_WIDTH
    CGFloat posX = 5.0f;
    CGFloat posY = 6.0f;
 
    posY = posY + BTN_HEIGHT+ 10.0f;
    ExButton* speakBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, BTN_HEIGHT*2)];
    [speakBtn addTarget:self action:@selector(leftBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    speakBtn.tag = 0; // 1 on, 0: off
    speakBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [speakBtn setTitle:@"스피커 On" forState:UIControlStateNormal];
    [speakBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:speakBtn];
    
    posY = posY + BTN_HEIGHT * 2 + 20.0f;
    ExButton* cameraBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, width, BTN_HEIGHT*2)];
    [cameraBtn addTarget:self action:@selector(leftBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    cameraBtn.tag = 10;
    cameraBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [cameraBtn setTitle:@"카메라 전환" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:cameraBtn];


}

/*
 * 화면 우축영역에 버튼 생성
 * 데이터 전송 버튼 : Text, Binary, FIle
 * 로그보기 버튼
 * 채널팝업 버튼
 * 종료 버튼
 */
- (void)initRightButtonLayout:(CGRect)frame
{
    CGFloat btnHeight = BTN_HEIGHT - 2;
    CGFloat btnWidth = 80.0f; // BTN_WIDTH
    CGFloat posX = frame.size.width - (btnWidth + 5.0f);
    CGFloat posY = 5.0f;
    CGFloat fontSize = 15.0f;
    CGFloat lbtnTm = 6.0f;
   
    // 영상 + 음성 + Data , Data Only : DataChannel 사용 시 데이터 전송 버튼 구성
    if(playrtcType == 1 || playrtcType == 4)
    {
        ExButton* dcTextBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcTextBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        dcTextBtn.tag = 1;
        dcTextBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcTextBtn setTitle:@"텍스트전송" forState:UIControlStateNormal];
        [dcTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcTextBtn];
    
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcByteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcByteBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        dcByteBtn.tag = 2;
        dcByteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcByteBtn setTitle:@"Byte전송" forState:UIControlStateNormal];
        [dcByteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcByteBtn];
    
        posY = posY + btnHeight + lbtnTm;
        ExButton* dcFileBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
        [dcFileBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
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
        [dcLogBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        dcLogBtn.tag = 4;
        dcLogBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [dcLogBtn setTitle:@"로그보기" forState:UIControlStateNormal];
        [dcLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainAreaView addSubview:dcLogBtn];
    }
    
    // 채널 팝업 보기 버튼
    posY = posY + btnHeight + lbtnTm;
    ExButton* chlPopupBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chlPopupBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    chlPopupBtn.tag = 5;
    chlPopupBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chlPopupBtn setTitle:@"채널팝업" forState:UIControlStateNormal];
    [chlPopupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chlPopupBtn];
    
    
    posY = posY + btnHeight + lbtnTm;
    posY += 20.0f;
    
    // PlayRTC 채널 퇴장 버튼
    ExButton* chPeerCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chPeerCloseBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    chPeerCloseBtn.tag = 6;
    chPeerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [chPeerCloseBtn setTitle:@"채널퇴장" forState:UIControlStateNormal];
    [chPeerCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainAreaView addSubview:chPeerCloseBtn];
    
    posY = posY + btnHeight + lbtnTm;

    // PlayRTC 채널 종료 버튼
    ExButton* chCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chCloseBtn addTarget:self action:@selector(rightBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)initRightTopButtonLayout
{
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
    [lVMuteBtn addTarget:self action:@selector(rightTopBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    lVMuteBtn.tag = 11;
    lVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [lVMuteBtn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
    [lVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:lVMuteBtn];
    
    posY = posY + btnHeight + lbtnTm;
    ExButton* lAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [lAMuteBtn addTarget:self action:@selector(rightTopBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    lAMuteBtn.tag = 12;
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
    [rVMuteBtn addTarget:self action:@selector(rightTopBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    rVMuteBtn.tag = 13;
    rVMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [rVMuteBtn setTitle:@"VIDEO_OFF" forState:UIControlStateNormal];
    [rVMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rVMuteBtn];
    
    posY = posY + btnHeight + 10.0f;
    ExButton* rAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, BTN_WIDTH, btnHeight)];
    [rAMuteBtn addTarget:self action:@selector(rightTopBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    rAMuteBtn.tag = 14;
    rAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [rAMuteBtn setTitle:@"AUDIO_OFF" forState:UIControlStateNormal];
    [rAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightTopView addSubview:rAMuteBtn];
    
}

// 화면 우축 버튼그룹의 이벤트 처리
- (void)rightBtnClick:(id)sender event:(UIEvent *)event
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
- (void)leftBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    // p2p 연결 후 카메라 전환
    if(tag == 10)
    {
        [self performSelector:@selector(switchCamera) withObject:nil afterDelay:0.1];
    }
    else
    {
        //Speaker On/Off
        BOOL isOn = tag == 0?TRUE:FALSE;
        if([playRTC setLoudspeakerEnable:isOn]) {
            if(isOn) {
                btn.tag = 1;
                [btn setTitle:@"스피커 Off" forState:UIControlStateNormal];
            }
            else {
                btn.tag = 0;
                [btn setTitle:@"스피커 On" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)rightTopBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 11) //Local Video Mute
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
    else if(tag == 12) //Local Audio Mute
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
    else if(tag == 13) //Remote Video Mute
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
    else if(tag == 14) //Remote Audio Mute
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
- (void) initVideoLayoutView:(UIView*)parent videoFrame:(CGRect)videoFrame
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
    localVideoFrame.size.width = localVideoFrame.size.width * 0.35;
    localVideoFrame.size.height = localVideoFrame.size.height * 0.35;
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
