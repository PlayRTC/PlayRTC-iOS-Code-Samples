//
//  MainViewController.m
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import "MainViewController.h"
#import "PlayRTCViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ExButton.h"
#import "ExLabel.h"


#define LOG_TAG @"MainViewController"

@interface MainViewController ()
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)setNavigationBar;
- (void)onLeftTitleBarButton:(id)sender;
- (void)initScreenLayoutView;
- (void)onBtnClick:(id)sender event:(UIEvent *)event;
@end

@implementation MainViewController

- (void)viewDidLoad {
    NSLog(@"[%@] viewDidLoad...", LOG_TAG);
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    
    [self initScreenLayoutView ];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // apple 정책을 확인하세요.
        NSLog(@"[%@] exit(0)...", LOG_TAG);
        exit(0);
    }
}
//
- (void)setNavigationBar
{
    self.navigationController.navigationBarHidden = FALSE;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
  
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc ] initWithTitle:@"App 종료"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(onLeftTitleBarButton:)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}
- (void) onLeftTitleBarButton:(id)sender
{
    
    //release the popover content
    NSLog(@"[%@] onLeftTitleBarButton  Click !!!", LOG_TAG);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"종료할까요?"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"종료",@"취소", nil];
    [alert show];
    
    
}

- (void)initScreenLayoutView
{
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    if(bounds.origin.y > 0){
        bounds.size.height+=bounds.origin.y;
        bounds.origin.y = 0;
    }
    
    CGRect mainFrame = bounds;
    mainFrame.origin.y = 0;
    mainFrame.size.height = bounds.size.height;
    
    CGFloat posY = 10;
    CGFloat posX = 10;
    CGFloat lblPosX = posX + 160;
    CGFloat lblWidth = mainFrame.size.width-(posX + 160);
    
    
    UILabel* lblt = [[UILabel alloc] initWithFrame:CGRectMake(posX + 100, posY, lblWidth, 28.0f)];
    lblt.backgroundColor = [UIColor clearColor];
    lblt.textAlignment = NSTextAlignmentLeft;
    lblt.font =[UIFont systemFontOfSize:24.0f];
    lblt.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lblt.text = @"SKT PlayRTC Sample For v2.2.2";
    [self.view addSubview:lblt];

    
    posY += (30.0f + 10.0f);
    
    // 영상 + 음성 + Data 실행 버튼
    ExButton* btn1 = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, 150, 40)];
    [btn1 addTarget:self action:@selector(onBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1;
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn1 setTitle:@"PlayRTC 실행" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosX, posY+ 5, lblWidth, 30.0f)];
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font =[UIFont systemFontOfSize:20.0f];
    lbl1.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbl1.text = @"영상 + 음성 + Data를 실행합니다.";
    [self.view addSubview:lbl1];
    
    // 영상 + 음성 실행 버튼
    posY += (30.0f + 20.0f);
    ExButton* btn2 = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, 150, 40)];
    [btn2 addTarget:self action:@selector(onBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 2;
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn2 setTitle:@"PlayRTC 실행" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UILabel* lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosX, posY+ 5, lblWidth, 30.0f)];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.textAlignment = NSTextAlignmentLeft;
    lbl2.font =[UIFont systemFontOfSize:20.0f];
    lbl2.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbl2.text = @"영상 + 음성을 실행합니다.";
    [self.view addSubview:lbl2];
    
    // 음성 실행 버튼
    posY += (30.0f + 20.0f);
    ExButton* btn3 = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, 150, 40)];
    [btn3 addTarget:self action:@selector(onBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 3;
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn3 setTitle:@"PlayRTC 실행" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UILabel* lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosX, posY+ 5, lblWidth, 30.0f)];
    lbl3.backgroundColor = [UIColor clearColor];
    lbl3.textAlignment = NSTextAlignmentLeft;
    lbl3.font =[UIFont systemFontOfSize:20.0f];
    lbl3.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbl3.text = @"음성을 실행합니다.";
    [self.view addSubview:lbl3];
    
    // Data 실행 버튼
    posY += (30.0f + 20.0f);
    ExButton* btn4 = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, 150, 40)];
    [btn4 addTarget:self action:@selector(onBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = 4;
    [btn4.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn4 setTitle:@"PlayRTC 실행" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    UILabel* lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosX, posY+ 5, lblWidth, 30.0f)];
    lbl4.backgroundColor = [UIColor clearColor];
    lbl4.textAlignment = NSTextAlignmentLeft;
    lbl4.font =[UIFont systemFontOfSize:20.0f];
    lbl4.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbl4.text = @"Data를 실행합니다.";
    [self.view addSubview:lbl4];
    
    // App 종료 버튼
    posY += (30.0f + 20.0f);
    ExButton* btn5 = [[ExButton alloc] initWithFrame:CGRectMake(posX, posY, 150, 40)];
    [btn5 addTarget:self action:@selector(onBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    btn5.tag = 5;
    [btn5.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn5 setTitle:@"App 종료" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    
    UILabel* lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosX, posY+ 5, lblWidth, 30.0f)];
    lbl5.backgroundColor = [UIColor clearColor];
    lbl5.textAlignment = NSTextAlignmentLeft;
    lbl5.font =[UIFont systemFontOfSize:20.0f];
    lbl5.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lbl5.text = @"App을 종료합니다.";
    [self.view addSubview:lbl5];


}

- (void)onBtnClick:(id)sender event:(UIEvent *)event
{
    
    UIButton* btn = (UIButton*)sender;
    int type = (int)btn.tag;
    if(type == 1) //영상 + 음성 + Data
    {
        
    }
    else if(type == 2) //영상 + 음성
    {

    }
    else if(type == 3) //음성
    {

    }
    else if(type == 4) //Data
    {

    }
    else if(type == 5) //App Close
    {
        //release the popover content
        NSLog(@"[%@] onLeftTitleBarButton  Click !!!", LOG_TAG);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"종료할까요?"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"종료",@"취소", nil];
        [alert show];
        return;
    }
    PlayRTCViewController* rtcController = [[PlayRTCViewController alloc] initWithType:type];
    [self.navigationController pushViewController:rtcController animated:YES];

}

@end
