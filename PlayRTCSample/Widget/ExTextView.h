//
//  ExTextView.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ExTextView_h__
#define __ExTextView_h__

#import <UIKit/UIKit.h>

@interface ExTextView : UITextView
{
    NSString* realText;
    NSString *placeholder;
}
@property (nonatomic, strong) NSString* realText;
@property(nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;

@end

#endif
