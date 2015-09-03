//
//  Sample1ViewController_UILayout.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 29..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample1ViewController_Layout_h__
#define __Sample1ViewController_Layout_h__

#import "Sample1ViewController.h" 

@interface Sample1ViewController(Layout)
- (void)initScreenLayoutView:(CGRect)frame;
- (void)initVideoLayoutView:(UIView*)parent videoFrame:(CGRect)videoFrame;
- (void)initMuteButtonLayout;
- (void)initBottomButtonLayout;
- (void)bottomBtnClick:(id)sender event:(UIEvent *)event;
- (void)muteBtnClick:(id)sender event:(UIEvent *)event;

@end

#endif
