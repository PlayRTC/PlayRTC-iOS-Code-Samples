//
//  ExButton.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ExButton_h__
#define __ExButton_h__

#import <UIKit/UIKit.h>

@interface ExButton : UIButton
{
    int touch_stat;

}
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;


@end

#endif
