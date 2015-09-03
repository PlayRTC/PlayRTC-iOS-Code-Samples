//
//  ExTextView.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//

#import "CanvasUtil.h"

#import "ExTextView.h"

#define ROUND_RADIUX 6.0f



@implementation ExTextView
@synthesize realTextColor;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize realText;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        self.opaque = FALSE;
        self.backgroundColor = [UIColor clearColor];
        self.realText = nil;
        self.realTextColor = self.textColor;
        self.placeholderColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.placeholder = nil;
    self.realText = nil;
}



- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.realText isEqualToString:placeholder] && ![self isFirstResponder]) {
        self.text = aPlaceholder;
    }
    if (aPlaceholder != placeholder) {
        placeholder = aPlaceholder;
    }
    

}

- (void)setPlaceholderColor:(UIColor *)aPlaceholderColor {
    placeholderColor = aPlaceholderColor;
    
    if ([super.text isEqualToString:self.placeholder]) {
        self.textColor = self.placeholderColor;
    }
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    if (([text isEqualToString:@""] || text == nil) && ![self isFirstResponder]) {
        super.text = self.placeholder;
    }
    else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder] || text == nil) {
        self.textColor = self.placeholderColor;
    }
    else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText {
    return [super text];
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if ([textColor isEqual:self.placeholderColor]){
            [super setTextColor:textColor];
        } else {
            self.realTextColor = textColor;
        }
    }
    else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetAllowsAntialiasing(context, YES);
    CGPathRef roundPath = UXMakeRoundRectPath(rect, ROUND_RADIUX);
    
    rect = CGRectInset(rect, 0, 0);
    
    CGContextAddPath(context, roundPath);
    CGContextClip(context);
    NSArray *colors = [NSArray arrayWithObjects:(id)RGB(220,227,209).CGColor, (id)RGB(255,255,255).CGColor, nil];
    drawLinearGradientWithPath(context, rect, roundPath, colors);

    
    // draw border line
    CGContextAddPath(context, roundPath);
    if(self.isEditable) {
        CGContextSetRGBStrokeColor(context, 143/255.0,151/255.0,93/255.0, 1.0f);
        CGContextSetLineWidth(context,2.0);
    }
    else {
        CGContextSetRGBStrokeColor(context, 220/255.0,227/255.0,227/255.0, 1.0f);
        CGContextSetLineWidth(context,1.0);
    }
    CGContextStrokePath(context);
    
    
    CGPathRelease(roundPath);

}

- (void)redraw
{
    [self setNeedsDisplay];
}

@end


