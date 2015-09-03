//
//  ExTabButton.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ExTabButton_h__
#define __ExTabButton_h__

#import <UIKit/UIKit.h>

@interface ExTabButton : UIButton
{
    int touch_stat;
    bool isSelected;
}

- (id)initWithFrame:(CGRect)frame active:(BOOL)active;
- (void)dealloc;
- (void)setActive:(BOOL)active;

@end

#endif
