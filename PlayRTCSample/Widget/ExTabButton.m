//
//  ExTabButton.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "CanvasUtil.h"
#import "ExTabButton.h"

#define STAT_PRESS  0
#define STAT_UP     1
#define ROUND_RADIUX 6.0f

@interface ExTabButton(Private)
- (void)redraw;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


@implementation ExTabButton


- (id)initWithFrame:(CGRect)frame active:(BOOL)active
{
    self = [super initWithFrame:frame];
    if(self) {
        touch_stat = STAT_UP;
        isSelected = active;
    }
    return self;
    
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    touch_stat = STAT_UP;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
}
- (void)setActive:(BOOL)active
{
    
    if(isSelected != active) {
        isSelected = active;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGPathRef roundPath = UXMakeCornerRectPath(rect, ROUND_RADIUX, ROUND_RADIUX, 0.0f, 0.0f);
    rect = CGRectInset(rect, 0, 0);
    
    
    

    CGContextAddPath(context, roundPath);
    CGContextClip(context);

    
    CGContextAddPath(context, roundPath);
    if(isSelected == TRUE) {
        CGContextSetRGBFillColor(context, 220/255.0,227/255.0,209/255.0, 1.0f);
    }
    else {
        CGContextSetRGBFillColor(context, 220/255.0,227/255.0,227/255.0, 1.0f);
    }
    CGContextFillPath(context);

    
    // draw border line
    //CGContextSetRGBStrokeColor(그래픽컨텍스트,R,G,B,A):선의 색상
    CGContextSetRGBStrokeColor(context, 143/255.0,151/255.0,93/255.0, 1.0f);
    CGContextAddPath(context, roundPath);
     
    //CGContextSetLineWidth(그래픽컨텍스트, 두께)
    CGContextSetLineWidth(context,3.0);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath (context);
    
    if(isSelected == TRUE) {
        CGContextSetRGBStrokeColor(context, 220/255.0,227/255.0,209/255.0, 1.0f);
    }
    else {
        CGContextSetRGBStrokeColor(context, 220/255.0,227/255.0,227/255.0, 1.0f);

    }
    CGContextSetLineWidth(context,3.0f);
    CGPoint points[2] = { CGPointMake(2.0f, rect.size.height), CGPointMake(rect.size.width-2.0f, rect.size.height)};
    CGContextStrokeLineSegments(context, points, 2);
    
    CGContextStrokePath(context);
    
    
    if(touch_stat == STAT_PRESS)
    {
        CGContextAddPath(context, roundPath);
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.2f);
        CGContextFillPath(context);
    }
    CGPathRelease(roundPath);

}

- (void)redraw
{
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touch_stat = STAT_PRESS;
    [self redraw];
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    touch_stat = STAT_UP;
    [self redraw];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch* touch = [[touches allObjects] objectAtIndex:0];
    touch_stat = STAT_UP;
    [self redraw];
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    
    if(touch_stat == STAT_PRESS && !CGRectContainsPoint(self.bounds, [touch locationInView:self]))
    {
        touch_stat = STAT_UP;
        [self redraw];
    }
}


@end


