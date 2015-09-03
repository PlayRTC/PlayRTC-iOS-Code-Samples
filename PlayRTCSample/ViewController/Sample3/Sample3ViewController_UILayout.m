//
//  Sample3ViewController_UILayout.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "SampleDefine.h"
#import "Sample3ViewController_UILayout.h"
#import "ExButton.h"

#define LOG_TAG @"Sample3ViewController"
#define BOTTOMAREA_HEIGHT           50.0f
#define LOGVIEW_WIDTH               360.0f
#define RBTNAREA_WIDTH              115.0f

@interface Sample3ViewController(Layout_TextField)<UITextFieldDelegate, UITextViewDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
@end

@implementation Sample3ViewController(Layout)

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


    CGRect lofFrame = mainFrame;
    lofFrame.origin.y=0;
    lofFrame.size.width = mainFrame.size.width * 0.4;
    lofFrame.size.height= mainFrame.size.height - BOTTOMAREA_HEIGHT;
    
    logView = [[ExTextView alloc] initWithFrame:lofFrame];
    logView.font = [UIFont systemFontOfSize:12.0f];
    logView.delegate = (id<UITextViewDelegate>)self;
    logView.hidden = FALSE;
    logView.scrollEnabled = YES;
    logView.textAlignment = NSTextAlignmentLeft;
    [logView setPlaceholder:@"PlayRTC Log..."];
    [mainAreaView addSubview:logView];
    
    CGRect dataFrame = mainFrame;
    dataFrame.origin.y=0;
    dataFrame.origin.x=lofFrame.size.width;
    dataFrame.size.width = mainFrame.size.width - lofFrame.size.width;
    dataFrame.size.height= mainFrame.size.height - BOTTOMAREA_HEIGHT;

    dataAreaView = [[UIView alloc] initWithFrame:dataFrame];
    dataAreaView.backgroundColor = [UIColor colorWithRed:220/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f];
    [mainAreaView addSubview:dataAreaView];
    
    
    CGRect bottomFrame = mainFrame;
    bottomFrame.size.height = BOTTOMAREA_HEIGHT;
    bottomFrame.origin.y = lofFrame.size.height ;
    
    
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
    [self initDataLayout];
    [self initBottomButtonLayout]; 
    [channelPopup show:0.8f];
}

- (void)initDataLayout
{
    CGRect frame = dataAreaView.bounds;
    CGRect dataFrame = frame;
    dataFrame.size.height= frame.size.height - BOTTOMAREA_HEIGHT;
    
    
    dataView = [[ExTextView alloc] initWithFrame:dataFrame];
    dataView.font = [UIFont systemFontOfSize:12.0f];
    dataView.hidden = FALSE;
    dataView.scrollEnabled = YES;
    dataView.textAlignment = NSTextAlignmentLeft;
    dataView.delegate = self;
    [dataView setPlaceholder:@"DataChannel..."];
    [dataAreaView addSubview:dataView];
    self.playRTC.dataView = dataView;
    
    CGRect inputFrame = frame;
    inputFrame.size.height = BOTTOMAREA_HEIGHT;
    inputFrame.size.width = dataFrame.size.width - 100.0f;
    inputFrame.origin.y =  dataFrame.size.height;
    
    inputView = [[ExTextField alloc] initWithFrame:inputFrame];
    [inputView setPlaceholder:@"Send Text..."];
    inputView.returnKeyType = UIReturnKeyDone;
    inputView.delegate = self;
    [dataAreaView addSubview:inputView];
    
    CGRect btnFrame = frame;
    btnFrame.size.height = BOTTOMAREA_HEIGHT;
    btnFrame.size.width = 100.0f;
    btnFrame.origin.y =  dataFrame.size.height;
    btnFrame.origin.x =  inputFrame.size.width;
    
    ExButton* sendBtn = [[ExButton alloc] initWithFrame:btnFrame];
    [sendBtn addTarget:self action:@selector(dataSendBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.tag = 11;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendBtn setTitle:BTN_DATA_SEND forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dataAreaView addSubview:sendBtn];

    
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
    ExButton* fileBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [fileBtn addTarget:self action:@selector(dataSendBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    fileBtn.tag = 12;
    fileBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [fileBtn setTitle:BTN_DATA_FILE forState:UIControlStateNormal];
    [fileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:fileBtn];
    
    posX = posX + btnWidth + 10.0f;
    ExButton* chlBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [chlBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    chlBtn.tag = 23;
    chlBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [chlBtn setTitle:BTN_CHANNEL forState:UIControlStateNormal];
    [chlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:chlBtn];
    
    
    
    posX = bottomAreaView.bounds.size.width - btnWidth - 10.0f;
    ExButton* prevBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [prevBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    prevBtn.tag = 25;
    prevBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [prevBtn setTitle:BTN_MAIN forState:UIControlStateNormal];
    [prevBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAreaView addSubview:prevBtn];
    
    posX = posX - (btnWidth + 10.0f);
    ExButton* disconnectBtn = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, btnWidth, btnHeight)];
    [disconnectBtn addTarget:self action:@selector(bottomBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    disconnectBtn.tag = 24;
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
    else if(tag == 24) //Channel Close
    {
        [self.playRTC performSelector:@selector(deleteChannel) withObject:nil afterDelay:0.1];
    }
    else if(tag == 25) //go back
    {
        [self performSelector:@selector(closeController) withObject:nil afterDelay:0.1];
    }
}

- (void)dataSendBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    
    if(tag == 11) //Text Send
    {
        NSString* text = inputView.text;
        [self.playRTC sendText:text];
        [self.playRTC appendDataView:[NSString stringWithFormat:@">>[%@] %@", self.playRTC.otherPeerUid, text]];

    }
    else if(tag == 12) //File Send
    {
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www/main.html"];
        [self.playRTC sendFileData:filePath];
        [self.playRTC appendDataView:[NSString stringWithFormat:@">>[%@] File[%@]", self.playRTC.otherPeerUid, filePath]];
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}

@end
