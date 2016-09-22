//
//  MainViewController.m
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import "MainViewController.h"
#import "PlayRTCViewController.h"
#import "ExButton.h"
#import "ExLabel.h"


#define LOG_TAG @"MainViewController"

@interface MainViewController ()
{
    BOOL ringEnable;
    NSString* videoCodec;
    NSString* audioCodec;
}
@property (nonatomic, copy) NSString* videoCodec;
@property (nonatomic, copy) NSString* audioCodec;

-(void)goRtcViewController:(int)playrtcType;

@end

@implementation MainViewController
@synthesize videoCodec;
@synthesize audioCodec;
@synthesize btnVP8;
@synthesize btnVP9;
@synthesize btnH264;
@synthesize btnISAC;
@synthesize btnOPUS;

- (void)viewDidLoad {
    NSLog(@"[%@] viewDidLoad...", LOG_TAG);
    [super viewDidLoad];

     self.navigationController.navigationBarHidden = TRUE;
    
    ringEnable = FALSE;
    self.videoCodec = @"VP8";
    self.audioCodec = @"ISAC";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)switchToggled:(id)sender
{
    UISwitch* switchRing = (UISwitch *)sender;
    if ([switchRing isOn]) {
        NSLog(@"switchRing on!");
        ringEnable = TRUE;
    } else {
        NSLog(@"switchRing off!");
        ringEnable = FALSE;
    }

}

-(IBAction)btnRunTypeClick:(id)sender
{
    ExButton* btn = (ExButton*)sender;
    int type = (int)btn.tag;
    [self goRtcViewController:type];

}


-(IBAction)btnExitClick:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App 종료"
                                                                   message:@"종료할까요?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"종료"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                      {
                          NSLog(@"[%@] exit(0)...", LOG_TAG);
                          exit(0);
                          
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"아니오"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];


}

-(IBAction)btnVideoCodecClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int type = (int)btn.tag;
    if(type == 1) {
        // VP8
        self.videoCodec = @"VP8";
        [self.btnVP8 setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
        [self.btnVP9 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
        [self.btnH264 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
    }
    else if(type == 2) {
        //VP9
        self.videoCodec = @"VP9";
        [self.btnVP8 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
        [self.btnVP9 setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
        [self.btnH264 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
    }
    else {
        //Open H.264
        self.videoCodec = @"H264";
        [self.btnVP8 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
        [self.btnVP9 setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
        [self.btnH264 setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)btnAudioCodecClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int type = (int)btn.tag;
    if(type == 1) {
        // ISAC
        self.audioCodec = @"ISAC";
        [self.btnISAC setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
        [self.btnOPUS setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
    }
    else {
        //OPUS
        self.audioCodec = @"OPUS";
        [self.btnOPUS setImage:[UIImage imageNamed:@"btn_radio_on.png"] forState:UIControlStateNormal];
        [self.btnISAC setImage:[UIImage imageNamed:@"btn_radio_off.png"] forState:UIControlStateNormal];
    }
    
}

-(void)goRtcViewController:(int)playrtcType
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayRTCViewController* rtcController  = [sb instantiateViewControllerWithIdentifier:@"PlayRTCViewController"];
    rtcController.playrtcType = playrtcType;
    rtcController.ringEnable = ringEnable;
    rtcController.videoCodec = self.videoCodec;
    rtcController.audioCodec = self.audioCodec;
    
    [self.navigationController pushViewController:rtcController animated:YES];
    
}

@end
