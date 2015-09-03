//
//  ExTableView.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//
#ifndef __ExTableView_h__
#define __ExTableView_h__

#import <UIKit/UIKit.h>
#import "Channel.h"

@protocol ChannelListAdapterListener <NSObject>

- (void)onSelectChannelItem:(Channel*)channel;

@end

@interface ExTableView : UITableView<UITableViewDataSource, UITableViewDelegate >
{
     NSMutableArray* dataList;
    __weak id<ChannelListAdapterListener> listener;
}
@property (nonatomic, weak) id<ChannelListAdapterListener> listener;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void) dealloc;

- (void)setChannelList:(NSArray*)list;

/* UITableViewDataSource */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

#endif
