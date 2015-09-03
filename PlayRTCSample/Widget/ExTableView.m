//
//  ExTableView.m
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 1. 15..
//  Copyright (c) 2014년 playrtc. All rights reserved.
//

#import "ExTableView.h"
#import "ExButton.h"

#import "Channel.h"
#import "ExTableCell.h"


@interface ExTableView() {
    UILabel* lbRowChannelId;
    UILabel* lbRowChannelName;
    ExButton* btnRowSelect;
   
}
@end

@implementation ExTableView
@synthesize listener;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self != nil)
    {
        dataList = nil;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        self.dataSource = self;
        self.delegate = self;
        self.listener = nil;
    }
    return self;
}

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    if(dataList != nil)
    {
        [dataList removeAllObjects];
        dataList = nil;
    }

    self.listener = nil;
}

- (void)setChannelList:(NSArray*)list
{
    if(dataList != nil)
    {
        [dataList removeAllObjects];
        dataList = nil;
    }
    if(list != nil) {
        dataList = [NSMutableArray arrayWithArray:list];
    }
    else {
        dataList = [NSMutableArray array];
    }
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataList == nil) {
        return 0;
    }
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channelcell"];
    if (cell==nil) {
        
        cell = [[ExTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"channelcell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        ExButton* btn = [cell getButton];
        [btn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    int index = (int)indexPath.row;
    Channel* channelData = [dataList objectAtIndex:index];
    if(channelData != nil)
    {
        [cell setChannelData:channelData.channelId channelName:channelData.channelName tag:index];
      
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LIST_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)btnClick:(id)sender event:(UIEvent *)event
{
    ExButton* btn = (ExButton*)sender;
    int tag = btn.tag;
    Channel* channelData = [dataList objectAtIndex:tag];
    if(self.listener != nil)
    {
        [self.listener onSelectChannelItem:channelData];
    }
}

@end


