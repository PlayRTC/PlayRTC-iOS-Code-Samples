//
//  ExButton.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "CanvasUtil.h"
#import "ExButton.h"

#define STAT_PRESS  0
#define STAT_UP     1
#define ROUND_RADIUX 6.0f

@interface ExButton(Private)
- (void)redraw;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


@implementation ExButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        touch_stat = STAT_UP;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
    
}

- (void)dealloc
{
    
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetAllowsAntialiasing(context, YES);
    CGPathRef roundPath = UXMakeRoundRectPath(rect, ROUND_RADIUX);
    
    rect = CGRectInset(rect, 0, 0);
    
    CGContextAddPath(context, roundPath);
    CGContextClip(context);
    //(id)RGB(136,136,136)
   // NSArray *colors = [NSArray arrayWithObjects:(id)RGB(80,80,80).CGColor, (id)RGB(40,40,40).CGColor, (id)RGB(80,80,80).CGColor, nil];
    NSArray *colors = [NSArray arrayWithObjects:(id)RGB(220,227,227).CGColor, (id)RGB(255,255,255).CGColor, nil];
    drawLinearGradientWithPath(context, rect, roundPath, colors);
    
    
    
    // draw border line
    CGContextAddPath(context, roundPath);
    CGContextSetRGBStrokeColor(context, 143/255.0,151/255.0,93/255.0, 1.0f);
    CGContextSetLineWidth(context,2.0);
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


