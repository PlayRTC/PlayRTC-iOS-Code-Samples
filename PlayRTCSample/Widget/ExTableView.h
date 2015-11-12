//
//  ExTableView.h
//  PlayRTCDemo
//
//  Created by ds3grk on 2015. 8. 11..
//  Copyright (c) 2015년 sktelecom. All rights reserved.
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
