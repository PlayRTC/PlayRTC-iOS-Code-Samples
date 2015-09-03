//
//  CanvasUtil.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//

#ifndef __CanvasUtil_H_
#define __CanvasUtil_H_

#import <CoreGraphics/CoreGraphics.h>

 
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(x) ((x) * 180.0 / M_PI)

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


static CGPathRef UXMakeCornerRectPath(CGRect rect, CGFloat leftTopRadius, CGFloat rightTopRadius, CGFloat rightBottomRadius, CGFloat leftBottomRadius)
{
    
    CGMutablePathRef path = CGPathCreateMutable(); 
   
	CGPoint	bl, tl, tr, br;
	
	bl = tl = tr = br = rect.origin;
	tl.y += rect.size.height;
	tr.y += rect.size.height;
	tr.x += rect.size.width;
	br.x += rect.size.width;
    
    // top-left
	CGPathMoveToPoint(path, NULL, bl.x + leftTopRadius, bl.y);
	CGPathAddArcToPoint(path, NULL, bl.x, bl.y, bl.x, bl.y + leftTopRadius, leftTopRadius);
    
    // bottom-left
	CGPathAddLineToPoint(path, NULL, tl.x, tl.y - leftBottomRadius);
	CGPathAddArcToPoint(path, NULL, tl.x, tl.y, tl.x + leftBottomRadius, tl.y, leftBottomRadius);
    
    // bottom-right
	CGPathAddLineToPoint(path, NULL, tr.x - rightBottomRadius, tr.y);
	CGPathAddArcToPoint(path, NULL, tr.x, tr.y, tr.x, tr.y - rightBottomRadius, rightBottomRadius);
    
    // top-right
	CGPathAddLineToPoint(path, NULL, br.x, br.y + rightTopRadius);
	CGPathAddArcToPoint(path, NULL, br.x, br.y, br.x - rightTopRadius, br.y, rightTopRadius);
	
	CGPathCloseSubpath(path);	
	
	CGPathRef ret;
	ret = CGPathCreateCopy(path);
	CGPathRelease(path);
	
    return ret;
}

static CGPathRef UXMakeRoundRectPath(CGRect rect, CGFloat cornerRadius)
{
	return UXMakeCornerRectPath(rect,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
}


static void drawLinearGradientWithPath(CGContextRef context, CGRect rect, CGPathRef rectPath, NSArray *colors) {
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddPath(context, rectPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
} 
#endif
