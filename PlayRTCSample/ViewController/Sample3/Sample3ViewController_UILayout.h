//
//  Sample3ViewController_UILayout.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample3ViewController_Layout_h__
#define __Sample3ViewController_Layout_h__

#import "Sample3ViewController.h"

@interface Sample3ViewController(Layout)
- (void)initScreenLayoutView:(CGRect)frame;
- (void)initDataLayout;
- (void)initBottomButtonLayout;
- (void)bottomBtnClick:(id)sender event:(UIEvent *)event;
- (void)dataSendBtnClick:(id)sender event:(UIEvent *)event;

@end

#endif
