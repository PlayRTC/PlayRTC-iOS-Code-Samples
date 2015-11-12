//
//  ExLabel.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import "ExLabel.h"


@implementation ExLabel


- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        
    }
    return self;
}

- (void)dealloc
{



}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    rect = CGRectInset(rect, 0, 0);
    
    CGContextSetRGBStrokeColor(context, 0/255.0,0/255.0,0/255.0, 1.0f);
    CGContextSetLineWidth(context,4.0);
    CGContextStrokeRect(context, rect);
}
@end


