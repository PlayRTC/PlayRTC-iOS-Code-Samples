//
//  ExTableCell.m
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
//

#import "ExTableCell.h"



@implementation ExTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        lbRowChannelId = [[UILabel alloc] initWithFrame:CGRectZero];
        lbRowChannelId.font = [UIFont systemFontOfSize:18.0f];
        lbRowChannelId.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        lbRowChannelName = [[UILabel alloc] initWithFrame:CGRectZero];
        lbRowChannelName.font = [UIFont systemFontOfSize:16.0f];
        lbRowChannelName.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        btnRowSelect = [[ExButton alloc] initWithFrame:CGRectZero];
        [btnRowSelect setTitle:@"채널 입장" forState:UIControlStateNormal];
        [btnRowSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:lbRowChannelId];
        [self.contentView addSubview:lbRowChannelName];
        [self.contentView addSubview:btnRowSelect];
    }
    return self;
}


- (void)dealloc
{
}

- (ExButton*) getButton
{
    return btnRowSelect;
}
- (void)setChannelData:(NSString*)channelId channelName:(NSString*)channelName tag:(int)tag
{
    [lbRowChannelId setText:channelId];
    [lbRowChannelName setText:channelName];
    btnRowSelect.tag = tag;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat h = 40;
    CGFloat lw = contentRect.size.width *0.70;
    CGFloat bw = contentRect.size.width *0.20;
    
    CGRect frame;
    
    frame = CGRectMake(boundsX+20, 0, lw, h);
    lbRowChannelId.frame = frame;
    
    frame = CGRectMake(boundsX+20, h, lw, h);
    lbRowChannelName.frame = frame;
    
    frame = CGRectMake(lw + 20, 20, bw, h);
    btnRowSelect.frame = frame;
}
@end


