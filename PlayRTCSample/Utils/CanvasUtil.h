//
//  CanvasUtil.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#ifndef __CanvasUtil_H_
#define __CanvasUtil_H_

#import <UIKit/UIKit.h>

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(x) ((x) * 180.0 / M_PI)

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

extern CGPathRef UXMakeCornerRectPath(CGRect rect, CGFloat leftTopRadius, CGFloat rightTopRadius, CGFloat rightBottomRadius, CGFloat leftBottomRadius);
extern CGPathRef UXMakeRoundRectPath(CGRect rect, CGFloat cornerRadius);
extern CGPathRef UXMakeTrianglePath(CGRect rect , BOOL reverse );
extern void drawLinearGradientWithRect(CGContextRef context, CGRect rect, NSArray *colors);
extern void drawLinearGradientWithPath(CGContextRef context, CGRect rect, CGPathRef rectPath, NSArray *colors);

#endif
