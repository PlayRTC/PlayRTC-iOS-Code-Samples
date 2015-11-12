//
//  CanvasUtil.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//


#import "CanvasUtil.h"


CGPathRef UXMakeCornerRectPath(CGRect rect, CGFloat leftTopRadius, CGFloat rightTopRadius, CGFloat rightBottomRadius, CGFloat leftBottomRadius)
{
    
    CGMutablePathRef path = CGPathCreateMutable(); 
   
    CGPoint	bl;
    CGPoint	tl;
    CGPoint	tr;
    CGPoint	br;
	
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


CGPathRef UXMakeRoundRectPath(CGRect rect, CGFloat cornerRadius)
{
	return UXMakeCornerRectPath(rect,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
}


CGPathRef UXMakeTrianglePath(CGRect rect , BOOL reverse ) {
    CGMutablePathRef path = CGPathCreateMutable(); 
    CGPoint	t,l,r;
    t = l = r = rect.origin;
    t.x += (rect.size.width/2);
    r.x += rect.size.width;
    
    if(reverse == TRUE)
    {
        t.y += (rect.size.height);
    }
    else
    {
        l.y += (rect.size.height);
        r.y += (rect.size.height);
    }
    
    CGPathMoveToPoint(path, NULL, t.x , t.y);
    CGPathAddLineToPoint(path, NULL, l.x, l.y);
    CGPathAddLineToPoint(path, NULL, r.x, r.y);
    CGPathAddLineToPoint(path, NULL, t.x, t.y);
    CGPathCloseSubpath(path);	
    CGPathRef ret;
	ret = CGPathCreateCopy(path);
	CGPathRelease(path);
	
    return ret;

    
}


void drawLinearGradientWithRect(CGContextRef context, CGRect rect, NSArray *colors) {
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
} 


void drawLinearGradientWithPath(CGContextRef context, CGRect rect, CGPathRef rectPath, NSArray *colors) {
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

