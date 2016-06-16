//
//  SnapshotLayerView.h
//  PlayRTCSample
//
//  Created by ds3grk-mac2 on 2016. 5. 30..
//  Copyright © 2016년 SKTelecom. All rights reserved.
//
#ifndef __SnapshotLayerView_h__
#define __SnapshotLayerView_h__

#import <UIKit/UIKit.h>
#import "ExButton.h"

@protocol SnapshotLayerObserver <NSObject>
@required
-(void)onClickSnapshotButton:(BOOL)localView;
@end

@interface SnapshotLayerView : UIView
{
    __weak ExButton* btnLocalSnashot;
    __weak ExButton* btnRemoteSnashot;
    
    __weak ExButton* btnClearSnashot;
    
    __weak ExButton* btnCloseSnashot;
    
    __weak UIImageView* displayView;
    
    __weak UILabel* lbImageSize;
}
@property (nonatomic, weak) ExButton* btnLocalSnashot;
@property (nonatomic, weak) ExButton* btnRemoteSnashot;
@property (nonatomic, weak) ExButton* btnClearSnashot;
@property (nonatomic, weak) ExButton* btnCloseSnashot;
@property (nonatomic, weak) UIImageView* displayView;
@property (nonatomic, weak) UILabel* lbImageSize;

-(id)initWithFrame:(CGRect)frame;
-(void)dealloc;

-(void)initializePannel:(id<SnapshotLayerObserver>)observer;
-(void)setSnapshotImage:(UIImage*)image;
@end

#endif
