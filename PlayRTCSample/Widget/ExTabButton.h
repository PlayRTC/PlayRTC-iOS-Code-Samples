//
//  ExTabButton.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
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
