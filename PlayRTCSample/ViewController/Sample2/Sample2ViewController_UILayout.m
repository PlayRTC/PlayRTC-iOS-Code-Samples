//
//  Sample2ViewController_UILayout.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "SampleDefine.h"
#import "Sample2ViewController_UILayout.h"
#import "ExButton.h"

#define LOG_TAG @"Sample2ViewController"
#define BOTTOMAREA_HEIGHT           50.0f
#define LOGVIEW_WIDTH               360.0f
#define RBTNAREA_WIDTH              115.0f

@interface Sample2ViewController(Layout_TextField)<UITextViewDelegate>
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
@end

@implementation Sample2ViewController(Layout)

- (void) initScreenLayoutView:(CGRect)frame
{
    NSLog(@"[%@] initScreenLayoutView...", LOG_TAG);
    CGRect bounds = frame;
    CGRect mainFrame = bounds;
    mainFrame.origin.y = 0;
    mainFrame.size.height = bounds.size.height;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
        mainFrame.origin.y += 30.0f;
        mainFrame.size.height -= 60.0f;
    }
    else
    {
        
        mainFrame.origin.y += 20.0f;
        mainFrame.size.height -= 20.0f;
    }
    
    mainAreaView = [[UIView alloc] initWithFrame:mainFrame];
    mainAreaView.backgroundColor = [UIColor colorWithRed:220/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f];


    CGRect logFrame = mainFrame;
    logFrame.origin.y=0;
    logFrame.size.width = mainFrame.size.width;
    logFrame.size.height= logFrame.size.height - BOTTOMAREA_HEIGHT;
    
    logView = [[ExTextView alloc] initWithFrame:logFrame];
    logView.backgroundColor = [UIColor whiteColor];
    logView.font = [UIFont systemFontOfSize:12.0f];
    logView.delegate = self;
    logView.userInteractionEnabled = YES;
    logView.hidden = FALSE;
    logView.scrollEnabled = YES;
    logView.textAlignment = NSTextAlignmentLeft;
    [logView setPlaceholder:@"PlayRTC Log..."];
    [mainAreaView addSubview:logView];
    
    CGRect muteFrame = mainFrame;
    muteFrame.size.width = RBTNAREA_WIDTH;
    muteFrame.size.height= muteFrame.size.height - BOTTOMAREA_HEIGHT;
    muteFrame.origin.x = mainFrame.size.width - RBTNAREA_WIDTH;
    muteFrame.origin.y=0;
    
    muteAreaView = [[UIView alloc] initWithFrame:muteFrame];
    muteAreaView.backgroundColor = [UIColor colorWithRed:220/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f];
    muteAreaView.backgroundColor = [UIColor redColor];
    [mainAreaView addSubview:muteAreaView];
    
    CGRect bottomFrame = mainFrame;
    bottomFrame.size.height = BOTTOMAREA_HEIGHT;
    bottomFrame.origin.y = logFrame.size.height ;
    
    
    bottomAreaView = [[UIView alloc] initWithFrame:bottomFrame];
    bottomAreaView.backgroundColor = [UIColor yellowColor];
    [mainAreaView addSubview:bottomAreaView];
    
    
    CGRect popFrame = bounds;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
        popFrame.origin.y += 30.0f;
        popFrame.size.height -= 60.0f;
    } 
    else
    {
        
        popFrame.origin.y += 0.0f;
        popFrame.size.height -= 20.0f;
    }
    
    channelPopup = [[ChannelView alloc] initWithFrame:popFrame];
    channelPopup.hidden = TRUE;
    channelPopup.deletgate = (id<ChannelViewListener>)self;
    [mainAreaView addSubview:channelPopup];
    
    
    [self.view addSubview:mainAreaView];
    [self initMuteButtonLayout];
    [self initBottomButtonLayout];
    [channelPopup show:0.8f];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    BOOL editable = FALSE;
    return editable;
}
- (void)initMuteButtonLayout
{
    CGRect rightFrame = bottomAreaView.bounds;
    CGFloat labelHeight = 20.0f;
    CGFloat labelWidth = rightFrame.size.width;
    CGFloat btnWidth = 90.0f;
    CGFloat btnHeight = 40.0f;
    CGFloat posX = 10.0f;
    CGFloat posY = 5.0f;
    
    UILabel* lMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, labelWidth, labelHeight)];
    lMuteLbl.backgroundColor = [UIColor clearColor];
    lMuteLbl.textAlignment = NSTextAlignmentLeft;
    lMuteLbl.font =[UIFont fontWithName:nil size:16.0f];
    lMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lMuteLbl.text = LABEL_LOCAL_MUTE;
    [muteAreaView addSubview:lMuteLbl];
    
    posY = posY + labelHeight + 5.0f;
    ExButton* lAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [lAMuteBtn addTarget:self action:@selector(muteBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    lAMuteBtn.tag = 11;
    lAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [lAMuteBtn setTitle:BTN_REMOTE_AMUTE forState:UIControlStateNormal];
    [lAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [muteAreaView addSubview:lAMuteBtn];
    
    posY = posY + btnHeight + 5.0f;
    UILabel* rMuteLbl = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, labelWidth, labelHeight)];
    rMuteLbl.backgroundColor = [UIColor clearColor];
    rMuteLbl.textAlignment = NSTextAlignmentLeft;
    rMuteLbl.font =[UIFont fontWithName:nil size:16.0f];
    rMuteLbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    rMuteLbl.text = LABEL_REMOTE_MUTE;
    [muteAreaView addSubview:rMuteLbl];
    
    posY = posY + labelHeight + 5.0f;
    ExButton* rAMuteBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [rAMuteBtn addTarget:self action:@selector(muteBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    rAMuteBtn.tag = 12;
    rAMuteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rAMuteBtn setTitle:BTN_REMOTE_AMUTE forState:UIControlStateNormal];
    [rAMuteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [muteAreaView addSubview:rAMuteBtn];
    
}

- (void)initBottomButtonLayout
{
    CGFloat btnHeight = 40.0f;
    CGFloat btnWidth = 80.0f;
    CGFloat posX = 10.0f;
    CGFloat posY = 5.0f;
    
    ExButton* cmdBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [cmdBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    cmdBtn.tag = 22;
    cmdBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cmdBtn setTitle:BTN_COMMAND forState:UIControlStateNormal];
    [cmdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:cmdBtn];
    
    posX = posX + btnWidth + 10.0f;
    ExButton* chlBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chlBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    chlBtn.tag = 23;
    chlBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [chlBtn setTitle:BTN_CHANNEL forState:UIControlStateNormal];
    [chlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:chlBtn];
    
    posX = posX + btnWidth + 40.0f;
    ExButton* soundBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [soundBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    soundBtn.tag = 24;
    soundBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [soundBtn setTitle:BTN_SPEAKER_ON forState:UIControlStateNormal];
    [soundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:soundBtn];
    
    
    posX = bottomAreaView.bounds.size.width - btnWidth - 10.0f;
    ExButton* prevBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [prevBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    prevBtn.tag = 26;
    prevBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [prevBtn setTitle:BTN_MAIN forState:UIControlStateNormal];
    [prevBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:prevBtn];
    
    posX = posX - (btnWidth + 10.0f);
    ExButton* disconnectBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [disconnectBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    disconnectBtn.tag = 25;
    disconnectBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [disconnectBtn setTitle:BTN_DISCONNECT forState:UIControlStateNormal];
    [disconnectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:disconnectBtn];

    
}

- (void)bottomBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 22) //command
    {
        [self.playRTC performSelector:@selector(userCommand:command:) withObject:self.playRTC.otherPeerId withObject:@"{\"command\":\"alert\", \"data\":\"usercommand입니다.\"}"];
    }
    else if(tag == 23) //Channel popup
    {
        [channelPopup show: 0.0f];
    }
    else if(tag == 24) // Speaker
    {
        //Speaker On/Off
        NSString* text = btn.currentTitle;
        BOOL isOn = ([text isEqualToString:BTN_SPEAKER_ON])?TRUE:FALSE;
        if([self.playRTC setLoudspeakerEnable:isOn]) {
            if(isOn) {
                [btn setTitle:BTN_SPEAKER_OFF forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:BTN_SPEAKER_ON forState:UIControlStateNormal];
            }
        }
    }
    else if(tag == 25) //Channel Close
    {
        [self.playRTC performSelector:@selector(deleteChannel) withObject:nil afterDelay:0.1];
    }
    else if(tag == 26) //go back
    {
        [self performSelector:@selector(closeController) withObject:nil afterDelay:0.1];
    }
}

- (void)muteBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 11) //Local Audio Mute
    {
        if(self.playRTC.localMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([self.playRTC.localMedia setVideoMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"A_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"A_ON" forState:UIControlStateNormal];
                }
            }
        }
    }
    else if(tag == 12) //Remote Audio Mute
    {
        if(self.playRTC.remoteMedia) {
            NSString* text = btn.currentTitle;
            BOOL isMute = [text hasSuffix:@"ON"];
            if([self.playRTC.remoteMedia setAudioMute:!isMute]) {
                if(isMute) {
                    [btn setTitle:@"A_OFF" forState:UIControlStateNormal];
                }
                else {
                    [btn setTitle:@"A_ON" forState:UIControlStateNormal];
                }
            }
        }
        
    }
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return FALSE;
}
@end
