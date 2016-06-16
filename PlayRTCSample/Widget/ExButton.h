//
//  ExButton.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//
#ifndef __ExButton_h__
#define __ExButton_h__

#import <UIKit/UIKit.h>

@interface ExButton : UIButton
{
    int touch_stat;

}
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;


@end

#endif
