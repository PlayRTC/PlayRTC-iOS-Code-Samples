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
    __weak ExButton* btnRunType1;
    __weak ExButton* btnRunType2;
    __weak ExButton* btnRunType3;
    __weak ExButton* btnRunType4;
    __weak ExButton* btnExit;

}

-(void)btnRunTypeClick:(id)sender;
-(void)btnExitClick:(id)sender;

@end

