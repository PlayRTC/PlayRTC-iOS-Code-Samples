//
//  MainViewController.h
//  PlayRTCSDKSample
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExButton.h"

@interface MainViewController : UIViewController
{
    
    
    __weak IBOutlet UIButton* btnVP8;
    __weak IBOutlet UIButton* btnVP9;
    __weak IBOutlet UIButton* btnH264;
    
    __weak IBOutlet UIButton* btnISAC;
    __weak IBOutlet UIButton* btnOPUS;

}
@property (nonatomic, weak) IBOutlet UIButton* btnVP8;
@property (nonatomic, weak) IBOutlet UIButton* btnVP9;
@property (nonatomic, weak) IBOutlet UIButton* btnH264;

@property (nonatomic, weak) IBOutlet UIButton* btnISAC;
@property (nonatomic, weak) IBOutlet UIButton* btnOPUS;

-(IBAction)switchToggled:(id)sender;

-(IBAction)btnRunTypeClick:(id)sender;
-(IBAction)btnExitClick:(id)sender;

-(IBAction)btnVideoCodecClick:(id)sender;
-(IBAction)btnAudioCodecClick:(id)sender;

@end

