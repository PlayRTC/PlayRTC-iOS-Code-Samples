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
- (void)initScreenLayoutView;
@end

@implementation MainViewController


- (void)viewDidLoad {
    NSLog(@"[%@] viewDidLoad...", LOG_TAG);
    [super viewDidLoad];

     self.navigationController.navigationBarHidden = TRUE;
    
    [self initScreenLayoutView ];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScreenLayoutView
{
    
    for (UIView *v in self.view.subviews){
        
        if([v isKindOfClass:[ExButton class]]){
            
            ExButton* btn = (ExButton*)v;
            
            if(btn.tag == 0)
            {
                btnExit = btn;
            }
            else if(btn.tag == 1) {
                btnRunType1 = btn;
            }
            else if(btn.tag == 2) {
                btnRunType2 = btn;
            }
            else if(btn.tag == 3) {
                btnRunType3 = btn;
            }
            else if(btn.tag == 4) {
                btnRunType4 = btn;
            }
        }
    }

    [btnExit addTarget:self action:@selector(btnExitClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRunType1 addTarget:self action:@selector(btnRunTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRunType2 addTarget:self action:@selector(btnRunTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRunType3 addTarget:self action:@selector(btnRunTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRunType4 addTarget:self action:@selector(btnRunTypeClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)btnRunTypeClick:(id)sender
{
    ExButton* btn = (ExButton*)sender;
    int type = (int)btn.tag;
    //PlayRTCViewController* rtcController = [[PlayRTCViewController alloc] initWithType:type];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayRTCViewController* rtcController  = [sb instantiateViewControllerWithIdentifier:@"PlayRTCViewController"];
    rtcController.playrtcType = type;
    
    [self.navigationController pushViewController:rtcController animated:YES];

}
-(void)btnExitClick:(id)sender
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

@end
