//
//  ChannelView.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//

#import "ChannelView.h"
#import "CanvasUtil.h"
#import "ExTabButton.h"
#import "ExButton.h"
#import "ExLabel.h"
#import "ExTextField.h"
#import "ExTableView.h"
#import "Channel.h"
#import "PlayRTCServiceHelperListener.h"

#define ROUND_RADIUX 4.0f
#define BTN_TAB_WIDTH  230.f
#define BTN_TAB_HEIGHT 45.0f
#define BTN_CLOSE_WIDTH  130.f
#define BTN_CLOSE_HEIGHT 40.0f

@interface ChannelView()<UITextFieldDelegate>
{
    ExTabButton* tabCreateBtn;
    ExTabButton* tabConnectBtn;
    ExButton* popCloseBtn;
    
    UIView* tabCreateInPanel;
    UIView* tabConnectInPanel;
    
    UIView* tabCreatePanel;
    UIView* tabConnectPanel;
    
    ExLabel* lbChannelId;
    UITableView* tableView;
    
    ExTextField* txtChlName;
    ExTextField* txtCrUsrId;
    ExTextField* txtCnUsrId;
    
    ExButton* btnCrClear;
    ExButton* btnCrCreate;
    
    ExButton* btnCnClear;
    ExButton* btnCrConnect;
    
    ExTableView* channelList;
    
    
    
}
- (void)showDelayed;
- (void) initViewLayout;
- (void)btnClick:(id)sender event:(UIEvent *)event;
- (NSString*)getRandomServiceMailId;
/*UITextFieldDelegate*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end


@interface ChannelView() <PlayRTCServiceHelperListener, ChannelListAdapterListener>
- (void)onSelectChannelItem:(Channel*)channel;
- (void)onServiceHelperResponse:(int)code statusMsg:(NSString*)statusMsg returnParam:(id)returnParam data:(NSDictionary*)oData;
- (void)onServiceHelperFail:(int)code statusMsg:(NSString*)statusMsg returnParam:(id)returnParam;
@end



@implementation ChannelView
@synthesize deletgate;

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
	if(self != nil)
	{
        self.deletgate = nil;
        self.hidden = TRUE;
        [self initViewLayout];
	}
  	return self;
}

- (void)dealloc
{
    self.deletgate = nil;
}



- (void)show:(NSTimeInterval)delayed
{
    if(self.hidden == TRUE) {
        
        if(delayed > 0) {
            [self performSelector:@selector(showDelayed) withObject:nil afterDelay:delayed];
        }
        else {
            [self showDelayed];
        }
        NSString* userId = [self getRandomServiceMailId];
        if(txtCrUsrId.text == nil || txtCrUsrId.text.length == 0)
        {
            txtCrUsrId.text = userId;
            txtChlName.text =[NSString stringWithFormat:@"%@님의 채널방입니다.", userId];
        }
        if(txtCnUsrId.text == nil || txtCnUsrId.text.length == 0)
        {
            txtCnUsrId.text = userId;
        }
    }
    
}
- (void)hide
{
    if(self.hidden == FALSE) {
        [UIView animateWithDuration:1.0 animations:^{ self.alpha = 0; }
                                        completion: ^(BOOL finished) {  self.hidden = finished; } ];
    }
}

- (void)showDelayed
{
    self.alpha = 0;
    self.hidden = FALSE;
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 1;
    }];
}

- (void)setChannelId:(NSString*)channelId
{
    lbChannelId.text = channelId;
}
- (void)showChannelList
{
    NSLog(@"[ChannelView] showChannelList");
    [self.deletgate getChannelList:(id<PlayRTCServiceHelperListener>)self];
}

- (void)redraw
{
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    rect = CGRectInset(rect, 0, 0);

    CGContextSetRGBFillColor(context, 220/255.0,227/255.0,227/255.0, 1.0f);
    CGContextFillRect(context, rect);
    
    // draw border line
    //CGContextSetRGBStrokeColor(그래픽컨텍스트,R,G,B,A):선의 색상
    CGContextSetRGBStrokeColor(context, 143/255.0,151/255.0,93/255.0, 1.0f);
    //CGContextSetRGBStrokeColor(context, 0,0,0, 1.0f);
    CGFloat pannelBrY = 60.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        pannelBrY = 50.0f;
    }

    CGContextBeginPath (context);
    CGContextSetLineWidth(context,2.0);
    CGPoint points[2] = { CGPointMake(0.0f, pannelBrY), CGPointMake(rect.size.width, pannelBrY)};
    CGContextStrokeLineSegments(context, points, 2);
    CGContextStrokePath(context);
    
    pannelBrY = 160.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        pannelBrY = 140.0f;
    }

    
    CGContextBeginPath (context);
    CGContextSetLineWidth(context,2.0);
    CGPoint points2[2] = { CGPointMake(0.0f, pannelBrY), CGPointMake(rect.size.width, pannelBrY)};
    CGContextStrokeLineSegments(context, points2, 2);
    CGContextStrokePath(context);
    
    //CGContextSetLineWidth(그래픽컨텍스트, 두께)
    CGContextSetLineWidth(context,4.0);
    CGContextStrokeRect(context, rect);
    
    
}
/*
 #define BTN_TAB_WIDTH  230.f
 #define BTN_TAB_HEIGHT 45.0f
 #define BTN_CLOSE_WIDTH  130.f
 #define BTN_CLOSE_HEIGHT 40.0f

 */
- (void) initViewLayout
{
    CGFloat tabBtnWidth = BTN_TAB_WIDTH;
    CGFloat tabBtnHeight = BTN_TAB_HEIGHT;
    CGFloat tabButtonPosY = 14.0f;
    CGFloat tabPannelPosY = 65.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        tabBtnWidth = 140.0f;
        tabBtnHeight = 40.0f;
        tabPannelPosY = 55.0f;
        tabButtonPosY = 8.0f;
    }
    tabCreateBtn = [[ExTabButton alloc] initWithFrame:CGRectMake(10.0f, tabButtonPosY, tabBtnWidth, tabBtnHeight) active:TRUE];
    [tabCreateBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    tabCreateBtn.tag = 1;
    [tabCreateBtn setTitle:@"채널생성" forState:UIControlStateNormal];
    [tabCreateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:tabCreateBtn];
    
    tabConnectBtn = [[ExTabButton alloc] initWithFrame:CGRectMake((10.0f+tabBtnWidth + 5.0f), tabButtonPosY, tabBtnWidth, tabBtnHeight) active:FALSE];
    [tabConnectBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    tabConnectBtn.tag = 2;
    [tabConnectBtn setTitle:@"채널입장" forState:UIControlStateNormal];
    [tabConnectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:tabConnectBtn];
    
    CGRect frame = self.frame;
    
    popCloseBtn = [[ExButton alloc] initWithFrame:CGRectMake(frame.size.width - (BTN_CLOSE_WIDTH +10), tabButtonPosY + 2.0f, BTN_CLOSE_WIDTH, BTN_CLOSE_HEIGHT - 5)];
    [popCloseBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    popCloseBtn.tag = 3;
    [popCloseBtn setTitle:@"닫기" forState:UIControlStateNormal];
    [popCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:popCloseBtn];

    
    tabCreateInPanel = [[UIView alloc] initWithFrame:CGRectMake(10, tabPannelPosY, frame.size.width - 20.0f, 80.0f)];
    tabCreateInPanel.backgroundColor = [UIColor clearColor];
    tabCreateInPanel.hidden = FALSE;
    
    CGFloat labelWidth = 120.0f;
    CGFloat labelHeight = 35.0f;
    CGFloat txtWidth = 320.0f;
    CGFloat btnWidth = 140.0f;
    CGFloat labelPosX = 15.0f;
    CGFloat marginX = 15.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        labelWidth = 100.0f;
        labelPosX = 0.0f;
        txtWidth = 230.0f;
        btnWidth = 120.0f;
        marginX = 5.0f;
    }

    CGFloat txtPosX =  labelPosX + labelWidth + marginX;
    CGFloat btnPosX = txtPosX + txtWidth + marginX;
    
   
    
    UILabel* chName = [[UILabel alloc] initWithFrame:CGRectMake(labelPosX, 3.0f, labelWidth, labelHeight)];
    chName.backgroundColor = [UIColor clearColor];
    chName.textAlignment = NSTextAlignmentRight;
    chName.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    chName.text = @"채널이름";
    [tabCreateInPanel addSubview:chName];
    
    txtChlName = [[ExTextField alloc] initWithFrame:CGRectMake(txtPosX, 3.0f, txtWidth, labelHeight)];
    txtChlName.font =[UIFont fontWithName:nil size:14.0f];
    txtChlName.placeholderColor = [UIColor lightGrayColor];
    txtChlName.placeholder = @"채널 이름을 입력하세요.";
    txtChlName.returnKeyType = UIReturnKeyDone;
    txtChlName.delegate = self;
    [tabCreateInPanel addSubview:txtChlName];
    
    btnCrClear = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, 3.0f, btnWidth, labelHeight)];
    [btnCrClear addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btnCrClear.tag = 4;
    [btnCrClear setTitle:@"지우기" forState:UIControlStateNormal];
    [btnCrClear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabCreateInPanel addSubview:btnCrClear];
    
    // line 2
    UILabel* crUserId = [[UILabel alloc] initWithFrame:CGRectMake(labelPosX, 42.0f, labelWidth, labelHeight)];
    crUserId.backgroundColor = [UIColor clearColor];
    crUserId.textAlignment = NSTextAlignmentRight;
    crUserId.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    crUserId.text=@"사용자 아이디";
    [tabCreateInPanel addSubview:crUserId];
    
    txtCrUsrId = [[ExTextField alloc] initWithFrame:CGRectMake(txtPosX, 42.0f, txtWidth, labelHeight)];
    txtCrUsrId.font =[UIFont fontWithName:nil size:14.0f];
    txtCrUsrId.placeholderColor = [UIColor lightGrayColor];
    txtCrUsrId.placeholder = @"사용자 아이디를 입력하세요.";
    txtCrUsrId.returnKeyType = UIReturnKeyDone;
    txtCrUsrId.delegate = self;
    [tabCreateInPanel addSubview:txtCrUsrId];
    
    btnCrCreate = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, 42.0f, btnWidth, labelHeight)];
    [btnCrCreate addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btnCrCreate.tag = 5;
    [btnCrCreate setTitle:@"채널 생성하기" forState:UIControlStateNormal];
    [btnCrCreate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabCreateInPanel addSubview:btnCrCreate];

    
    
    [self addSubview:tabCreateInPanel];
    
    
    CGFloat tabConnectPanelY = 170.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        tabConnectPanelY = 150.0f;
    }

    CGFloat pHeight = frame.size.height - tabConnectPanelY - 5.0f;
    tabCreatePanel = [[UIView alloc] initWithFrame:CGRectMake(10, tabConnectPanelY, frame.size.width - 20.0f, pHeight)];
    tabCreatePanel.backgroundColor = [UIColor clearColor];
    tabCreatePanel.hidden = FALSE;
    [self addSubview:tabCreatePanel];
    
    CGFloat lw = tabCreatePanel.bounds.size.width/2;
    CGFloat lh = 120.0f;
    CGFloat lx = ((tabCreatePanel.bounds.size.width) - lw) /2;
    CGFloat ly = ((tabCreatePanel.bounds.size.height) - lh) /2;
    lbChannelId = [[ExLabel alloc] initWithFrame:CGRectMake(lx, ly, lw, lh)];
    lbChannelId.font =[UIFont fontWithName:nil size:24.0f];
    lbChannelId.text = @"CHANNEL-ID";
    lbChannelId.textAlignment = NSTextAlignmentCenter;
    lbChannelId.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbChannelId.hidden = FALSE;
    [tabCreatePanel addSubview:lbChannelId];
    
    
    /////////////////////
    
    

    tabConnectInPanel = [[UIView alloc] initWithFrame:CGRectMake(10, tabPannelPosY, frame.size.width- 20.0f, 80.0f)];
    tabConnectInPanel.backgroundColor = [UIColor clearColor];
    tabConnectInPanel.hidden = TRUE;
    
    UILabel* crUsrId = [[UILabel alloc] initWithFrame:CGRectMake(labelPosX, 3.0f, labelWidth, labelHeight)];
    crUsrId.backgroundColor = [UIColor clearColor];
    crUsrId.textAlignment = NSTextAlignmentRight;
    crUsrId.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    crUsrId.text = @"사용자 아이디";
    [tabConnectInPanel addSubview:crUsrId];

    txtCnUsrId = [[ExTextField alloc] initWithFrame:CGRectMake(txtPosX, 3.0f, txtWidth, labelHeight)];
    txtCnUsrId.font =[UIFont fontWithName:nil size:14.0f];
    txtCnUsrId.placeholderColor = [UIColor lightGrayColor];
    txtCnUsrId.placeholder = @"사용자 아이디를 입력하세요.";
    txtCnUsrId.returnKeyType = UIReturnKeyDone;
    txtCnUsrId.delegate = self;

    [tabConnectInPanel addSubview:txtCnUsrId];
    
    btnCnClear = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, 3.0f, btnWidth, labelHeight)];
    [btnCnClear addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btnCnClear.tag = 6;
    [btnCnClear setTitle:@"지우기" forState:UIControlStateNormal];
    [btnCnClear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabConnectInPanel addSubview:btnCnClear];

    btnCrCreate = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, 42.0f, btnWidth, labelHeight)];
    [btnCrCreate addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btnCrCreate.tag = 7;
    [btnCrCreate setTitle:@"채널조회" forState:UIControlStateNormal];
    [btnCrCreate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabConnectInPanel addSubview:btnCrCreate];

    
    [self addSubview:tabConnectInPanel];
    
    
    
    
    tabConnectPanel = [[UIView alloc] initWithFrame:CGRectMake(10, tabConnectPanelY, frame.size.width- 20.0f, pHeight)];
    tabConnectPanel.backgroundColor = [UIColor clearColor];
    tabConnectPanel.hidden = TRUE;
    
    
    
    
    [self addSubview:tabConnectPanel];
    
    
    channelList = [[ExTableView alloc] initWithFrame:tabConnectPanel.bounds style:UITableViewStylePlain];
    channelList.listener = (id<ChannelListAdapterListener>)self;
    [tabConnectPanel addSubview:channelList];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)btnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag;
    
    if(tag == 1) //채널생성 탭
    {
        [tabConnectBtn setActive:FALSE];
        [tabCreateBtn setActive:TRUE];
        tabCreateInPanel.hidden = FALSE;
        tabCreatePanel.hidden = FALSE;
        tabConnectInPanel.hidden = TRUE;
        tabConnectPanel.hidden = TRUE;
    }
    else if(tag == 2) // 채널입장 탭
    {
        [tabCreateBtn setActive:FALSE];
        [tabConnectBtn setActive:TRUE];
        tabCreateInPanel.hidden = TRUE;
        tabCreatePanel.hidden = TRUE;
        tabConnectInPanel.hidden = FALSE;
        tabConnectPanel.hidden = FALSE;
        [self showChannelList];
    }
    else if(tag == 3) //팝업닫기버튼
    {
        [self hide];
    }
    else if(tag == 4) //채널 생성 지우기 버튼 버튼
    {
        txtCrUsrId.text = nil;
    }
    else if(tag == 5) //채널 생성하기 버튼
    {
        NSString* userId = txtCrUsrId.text;
        NSString* channelName = txtChlName.text;
        if(channelName.length == 0) {
            channelName = [NSString stringWithFormat:@"%@님의 채널방입니다.", userId];
        }
        if(self.deletgate != nil) {
            [deletgate onClickCreateChannel:channelName userId:userId];
        }
       
    }
    else if(tag == 6) //채널 입장 지우기 버튼
    {
         txtCnUsrId.text = nil;
    }
    else if(tag == 7) //채널입장 버튼
    {
        [self showChannelList];
    }
}

- (NSString*)getRandomServiceMailId
{
    NSMutableString* userMailId = [NSMutableString string];
    [userMailId appendString:@"IOS-"];
    static NSString* possible = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSRange areaStr;
    areaStr.length = 1;
    for(int i = 0 ; i < 5; i++) {
        NSUInteger r = arc4random() % 62;
        areaStr.location = r;
        NSString* s = [possible substringWithRange:areaStr];
        [userMailId appendString:s];
    }
    [userMailId appendString:@"@playrtc.com"];
    return userMailId;
}

- (void)onSelectChannelItem:(Channel*)channel
{
    if(channel != nil && self.deletgate != nil) {
        [deletgate onClickConnectChannel:channel.channelId userId:txtCnUsrId.text];
    }
}
- (void)onServiceHelperResponse:(int)code statusMsg:(NSString*)statusMsg returnParam:(id)returnParam data:(NSDictionary*)oData
{

    if(oData != nil)
    {
        NSDictionary* oError = [oData objectForKey:@"error"];
        if(oError != nil)
        {
            NSString* errMsg = [oError objectForKey:@"message"];
            NSLog(@"[ERROR] onServiceHelperResponse code[%d] statusMsg[%@] errMsg[%@]", code, statusMsg, errMsg);
            oData = nil;
            return;
        }
        
        NSMutableArray* dataList = [NSMutableArray array];
        NSArray* channels = [oData objectForKey:@"channels"];
        if(channels != nil) {
            int cnt = channels.count;
            for(int i = 0 ; i < cnt; i++)
            {
                NSDictionary* channel = [channels objectAtIndex:i];
                NSString* channelId = [channel objectForKey:@"channelId"];
                NSString* channelName = [channel objectForKey:@"channelName"];
                Channel* chItem = [[Channel alloc] init];
                chItem.channelId = channelId;
                chItem.channelName = channelName;
                chItem.userId = @"";
               //for(int k = 0 ; k < 10; k++)
                [dataList addObject:chItem];
               
            }
        }
        [channelList setChannelList:dataList];
    }
   
}
- (void)onServiceHelperFail:(int)code statusMsg:(NSString*)statusMsg returnParam:(id)returnParam
{
    NSLog(@"[ERROR] onServiceHelperFail code[%d] errMsg[%@]", code, statusMsg);

}
@end


