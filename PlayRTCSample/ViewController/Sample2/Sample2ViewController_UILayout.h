//
//  Sample2ViewController_UILayout.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample2ViewController_Layout_h__
#define __Sample2ViewController_Layout_h__

#import "Sample2ViewController.h"

@interface Sample2ViewController(Layout)
- (void)initScreenLayoutView:(CGRect)frame;
- (void)initMuteButtonLayout;
- (void)initBottomButtonLayout;
- (void)bottomBtnClick:(id)sender event:(UIEvent *)event;
- (void)muteBtnClick:(id)sender event:(UIEvent *)event;


@end
 
#endif

