//
//  SnapshotLayerView.m
//  PlayRTCSample
//
//  Created by ds3grk-mac2 on 2016. 5. 30..
//  Copyright © 2016년 SKTelecom. All rights reserved.
//

#import "SnapshotLayerView.h"

@implementation SnapshotLayerView
{
    __weak id<SnapshotLayerObserver> snapshotObserver;
    CGPoint centerPoint;
}
@synthesize btnLocalSnashot;
@synthesize btnRemoteSnashot;
@synthesize btnClearSnashot;
@synthesize btnCloseSnashot;
@synthesize displayView;
@synthesize lbImageSize;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        snapshotObserver = nil;
        self.opaque = NO;
        self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
        
        self.displayView.hidden = TRUE;
    }
    return self;
}

-(void)dealloc
{
    snapshotObserver = nil;
    self.btnLocalSnashot = nil;
    self.btnRemoteSnashot = nil;
    self.btnClearSnashot = nil;
    self.btnCloseSnashot = nil;
    self.displayView = nil;
    self.lbImageSize = nil;
}

-(void)initializePannel:(id<SnapshotLayerObserver>)observer
{
    snapshotObserver = observer;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imageView];
    self.displayView = imageView;
    
    ExButton* btnLocal = [[ExButton alloc] initWithFrame:CGRectMake(5, 5 , 60.0, 30.0f)];
    btnLocal.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnLocal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLocal setTitle:@"Local" forState:UIControlStateNormal];
    [self addSubview:btnLocal];
    self.btnLocalSnashot = btnLocal;
    
    ExButton* btnRemote = [[ExButton alloc] initWithFrame:CGRectMake(70, 5 , 60.0, 30.0f)];
    btnRemote.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnRemote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRemote setTitle:@"Remote" forState:UIControlStateNormal];
    [self addSubview:btnRemote];
    self.btnRemoteSnashot = btnRemote;
    
    ExButton* btnClear = [[ExButton alloc] initWithFrame:CGRectMake(135, 5 , 60.0, 30.0f)];
    btnClear.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnClear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClear setTitle:@"Clear" forState:UIControlStateNormal];
    [self addSubview:btnClear];
    self.btnClearSnashot = btnClear;
    
    
    ExButton* btnClose = [[ExButton alloc] initWithFrame:CGRectMake(200, 5 , 60.0, 30.0f)];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClose setTitle:@"Close" forState:UIControlStateNormal];
    [self addSubview:btnClose];
    self.btnCloseSnashot = btnClose;
    
    
    
    
    UILabel* lbSize = [[UILabel alloc] initWithFrame:CGRectMake(270, 10 , 120.0, 30.0f)];
    lbSize.text = @"[0X0]";
    lbSize.font = [UIFont systemFontOfSize:15.0f];
    lbSize.textColor = [UIColor redColor];
    [self.lbImageSize sizeToFit];
    [self addSubview:lbSize];
    self.lbImageSize = lbSize;
    
    
    centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.displayView.hidden = TRUE;
    [self.btnLocalSnashot addTarget:self action:@selector(btnLocalSnapshotClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRemoteSnashot addTarget:self action:@selector(btnRemoteSnapshotClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClearSnashot addTarget:self action:@selector(btnClearSnapshotClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCloseSnashot addTarget:self action:@selector(btnCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setSnapshotImage:(UIImage*)image
{
    self.displayView.frame = CGRectMake(0, 0 , image.size.width, image.size.height);
    self.displayView.center = centerPoint;
    
    self.displayView.hidden = FALSE;
    [self.displayView setImage:image];
    
    [self.lbImageSize setText:[NSString stringWithFormat:@"[%dx%d]", (int)image.size.width, (int)image.size.height]];
    [self.lbImageSize sizeToFit];
    
}
-(void)btnLocalSnapshotClick:(id)sender
{
    if(snapshotObserver != nil && [snapshotObserver respondsToSelector:@selector(onClickSnapshotButton:)])
    {
        [snapshotObserver onClickSnapshotButton:TRUE];
    }
}
-(void)btnRemoteSnapshotClick:(id)sender
{
    if(snapshotObserver != nil && [snapshotObserver respondsToSelector:@selector(onClickSnapshotButton:)])
    {
        [snapshotObserver onClickSnapshotButton:FALSE];
    }
}
-(void)btnClearSnapshotClick:(id)sender
{
    self.displayView.hidden = TRUE;
    [self.lbImageSize setText:@"[0x0]"];
}
-(void)btnCloseClick:(id)sender
{
    self.displayView.hidden = TRUE;
    self.hidden = TRUE;
    [self.lbImageSize setText:@"[0x0]"];
}

@end

