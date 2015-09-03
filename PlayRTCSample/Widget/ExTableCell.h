//
//  ExTableCell.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ExTableCell_h__
#define __ExTableCell_h__

#define LIST_ROW_HEIGHT     80.0f
#import <UIKit/UIKit.h>
#import "ExButton.h"
#import "Channel.h"

@interface ExTableCell : UITableViewCell
{
    UILabel* lbRowChannelId;
    UILabel* lbRowChannelName;
    ExButton* btnRowSelect;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) dealloc;
- (void)setChannelData:(NSString*)channelId channelName:(NSString*)channelName tag:(int)tag;
- (ExButton*) getButton;
@end

#endif
