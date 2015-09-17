//
//  ExTextView.h
//  MainViewController.h
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#ifndef __ExTextView_h__
#define __ExTextView_h__

#import <UIKit/UIKit.h>

@interface ExTextView : UITextView
{
    NSString *placeholder;
}
@property(nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;

@end

#endif
