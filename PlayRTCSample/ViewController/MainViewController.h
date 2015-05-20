//
//  MainViewController.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 14..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//
#ifndef __MainViewController_h__
#define __MainViewController_h__

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController

- (void)initScreenLayoutView:(CGRect)frame;
- (void)goPlayRTCSample1;
- (void)goPlayRTCSample2;
- (void)goPlayRTCSample3;
- (void)sampleBtnClick:(id)sender event:(UIEvent *)event;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

#endif