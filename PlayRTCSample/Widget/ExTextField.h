//
//  ExTextField.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 4. 30..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExTextField : UITextField
{
     NSString *placeholder;
}
@property(nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;
@end
