//
//  MainViewController.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 14..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import "SampleDefine.h"
#import "MainViewController.h"
#import "ExButton.h"
#import "Sample1ViewController.h"
#import "Sample2ViewController.h"
#import "Sample3ViewController.h"

#define LOG_TAG @"MainViewController"

@implementation MainViewController


- (id)init
{

    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[%@] dealloc...", LOG_TAG);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[%@] viewWillAppear", LOG_TAG);
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = TRUE;
    CGRect bounds = self.view.bounds;
    [self initScreenLayoutView:bounds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@] viewWillDisappear", LOG_TAG);
    if ([self.navigationController.viewControllers containsObject:self] == FALSE) {
        NSLog(@"[%@] viewWillDisappear 현재 viewController가 더이상 유효하지 않다.", LOG_TAG);
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[%@] viewDidDisappear", LOG_TAG);
    [super viewDidDisappear:animated];
}



- (void) initScreenLayoutView:(CGRect)frame
{
    NSLog(@"[%@] initScreenLayoutView...", LOG_TAG);
    CGRect bounds = frame;
    CGRect mainFrame = bounds;
    mainFrame.origin.y = 0;
    mainFrame.size.height = bounds.size.height;
    
    CGFloat titleLbHeight = 40.0f;
    CGFloat btnPosX = 20.0f;
    CGFloat btnPosY = 30.0f;
    CGFloat btnHeight = 40.0f;
    CGFloat btnWidth = 130.0f;
    CGFloat lbPosX = btnPosX + btnWidth + 5.0f;
    CGFloat lbPosY = btnPosY;
    CGFloat lbWidth = mainFrame.size.width - (lbPosX + 5.0f);
    CGFloat lbHeight = 40.0f;
    
    UILabel* lSample1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(btnPosX,btnPosY, mainFrame.size.width - btnPosX, titleLbHeight)];
    lSample1Lbl.backgroundColor = [UIColor clearColor];
    lSample1Lbl.textAlignment = NSTextAlignmentCenter;
    lSample1Lbl.font =[UIFont fontWithName:nil size:26.0f];
    lSample1Lbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    lSample1Lbl.text = (NSString*)LABEL_SAMPLE_TITLE;
    [self.view addSubview:lSample1Lbl];
    
    btnPosY += btnHeight + 10.0f;
    ExButton* sample1Btn = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, btnPosY, btnWidth, btnHeight)];
    [sample1Btn addTarget:self action:@selector(sampleBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    sample1Btn.tag = 1;
    [sample1Btn setTitle:BTN_SAMPLE1 forState:UIControlStateNormal];
    [sample1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:sample1Btn];
    
    lbPosY = btnPosY ;
    UILabel* sample1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbPosX, lbPosY, lbWidth, lbHeight)];
    sample1Lbl.backgroundColor = [UIColor clearColor];
    sample1Lbl.textAlignment = NSTextAlignmentLeft;
    sample1Lbl.font =[UIFont fontWithName:nil size:16.0f];
    sample1Lbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    sample1Lbl.text = LABEL_SAMPLE1_DESC;
    [self.view addSubview:sample1Lbl];

    btnPosY += btnHeight + 20.0f;
    ExButton* sample2Btn = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, btnPosY, btnWidth, btnHeight)];
    [sample2Btn addTarget:self action:@selector(sampleBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    sample2Btn.tag = 2;
    [sample2Btn setTitle:BTN_SAMPLE2 forState:UIControlStateNormal];
    [sample2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:sample2Btn];
    
    lbPosY = btnPosY ;
    UILabel* sample2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbPosX, lbPosY, lbWidth, lbHeight)];
    sample2Lbl.backgroundColor = [UIColor clearColor];
    sample2Lbl.textAlignment = NSTextAlignmentLeft;
    sample2Lbl.font =[UIFont fontWithName:nil size:16.0f];
    sample2Lbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    sample2Lbl.text = LABEL_SAMPLE2_DESC;
    [self.view addSubview:sample2Lbl];

    btnPosY += btnHeight + 20.0f;
    ExButton* sample3Btn = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, btnPosY, btnWidth, btnHeight)];
    [sample3Btn addTarget:self action:@selector(sampleBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    sample3Btn.tag = 3;
    [sample3Btn setTitle:BTN_SAMPLE3 forState:UIControlStateNormal];
    [sample3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:sample3Btn];
    
    lbPosY = btnPosY ;
    UILabel* sample3Lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbPosX, lbPosY, lbWidth, lbHeight)];
    sample3Lbl.backgroundColor = [UIColor clearColor];
    sample3Lbl.textAlignment = NSTextAlignmentLeft;
    sample3Lbl.font =[UIFont fontWithName:nil size:16.0f];
    sample3Lbl.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    sample3Lbl.text = LABEL_SAMPLE3_DESC;
    [self.view addSubview:sample3Lbl];
    
    btnPosY += btnHeight + 20.0f;
    btnPosX = mainFrame.size.width - (btnWidth + 10.0f);
    ExButton* closeBtn = [[ExButton alloc] initWithFrame:CGRectMake(btnPosX, btnPosY, btnWidth, btnHeight)];
    [closeBtn addTarget:self action:@selector(sampleBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = 100;
    [closeBtn setTitle:BTN_APPCLOSE forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];

}


-(void)closeApp
{
    UIViewController* viewController = [self.navigationController popViewControllerAnimated:TRUE];
    viewController = nil;

    // 아래 코드는 앱스토어 승인 확인이 필요함.
    NSLog(@"[%@] exit(0)...", LOG_TAG);
    exit(0);

}

- (void)goPlayRTCSample1
{
    Sample1ViewController* rtcController = [[Sample1ViewController alloc] init];
    [self.navigationController pushViewController:rtcController animated:YES];
}
- (void)goPlayRTCSample2
{
    Sample2ViewController* rtcController = [[Sample2ViewController alloc] init];
    [self.navigationController pushViewController:rtcController animated:YES];
}
- (void)goPlayRTCSample3
{
    Sample3ViewController* rtcController = [[Sample3ViewController alloc] init];
    [self.navigationController pushViewController:rtcController animated:YES];
}

- (void)btnAppClose
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LABEL_APP
                                                    message:LABEL_APP_CLOSE
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:BTN_CLOSE,BTN_CANCEL , nil];
    [alert show];
}
         
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self closeApp];
    }
}

         
- (void)sampleBtnClick:(id)sender event:(UIEvent *)event
{
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag;
    if(tag == 1) //Sample1
    {
        [self performSelector:@selector(goPlayRTCSample1) withObject:nil afterDelay:0.1];
    }
    else if(tag == 2) // Sample2
    {
        [self performSelector:@selector(goPlayRTCSample2) withObject:nil afterDelay:0.1];
    }
    else if(tag == 3) // Sample3
    {
        [self performSelector:@selector(goPlayRTCSample3) withObject:nil afterDelay:0.1];
    }
    else if(tag == 100) // close App
    {
        [self performSelector:@selector(btnAppClose) withObject:nil afterDelay:0.1];
    }
}

@end
