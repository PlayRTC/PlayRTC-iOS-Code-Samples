//
//  Sample2PlayRTC.h
//  PlayRTCSample
//
//  Created by ds3grk on 2015. 5. 6..
//  Copyright (c) 2015년 playrtc. All rights reserved.
//

#ifndef __Sample2PlayRTC_h__
#define __Sample2PlayRTC_h__

#import <Foundation/Foundation.h>
#import "PlayRTCFactory.h"
#import "PlayRTCVideoView.h"
#import "PlayRTCMedia.h"
#import "PlayRTCServiceHelperListener.h"
#import "PlayRTCObserver.h"

#import "ExTextView.h"


@interface Sample2PlayRTC : NSObject<PlayRTCObserver>
{
    BOOL isClose;
    BOOL isConnect;
    PlayRTC* playRTC;
    NSString* channelId;
    NSString* channelName;
    NSString* token;
    NSString* userUid;
    NSString* userPid;
    NSString* otherPeerId;
    NSString* otherPeerUid;
    PlayRTCVideoView* localVideoView;
    PlayRTCVideoView* remoteVideoView;
    CGSize _localVideoSize;
    CGSize _remoteVideoSize;
    
    __weak PlayRTCMedia* localMedia;
    __weak PlayRTCMedia* remoteMedia;
    __weak ExTextView* logView;
    __weak ExTextView* dataView;
    __weak id controller;
    
}
@property (nonatomic, assign) BOOL isClose;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, copy) NSString* channelName;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userUid;
@property (nonatomic, copy) NSString* userPid;
@property (nonatomic, copy) NSString* otherPeerId;
@property (nonatomic, copy) NSString* otherPeerUid;
@property (nonatomic, strong) PlayRTC* playRTC;
@property (nonatomic, strong) PlayRTCVideoView* localVideoView;
@property (nonatomic, strong) PlayRTCVideoView* remoteVideoView;
@property (nonatomic, weak) PlayRTCData* dataChannel;
@property (nonatomic, weak) PlayRTCMedia* localMedia;
@property (nonatomic, weak) PlayRTCMedia* remoteMedia;
@property (nonatomic, weak) ExTextView* logView;
@property (nonatomic, weak) ExTextView* dataView;
@property (nonatomic, weak) id controller;

+(NSString*)getPlayRTCStatusString:(PlayRTCStatus)status;
+(NSString*)getPlayRTCCodeString:(PlayRTCCode)code;

- (void)setConfiguration; 

- (void)createChannel:(NSString*)chName userId:(NSString*)userId;
- (void)connectChannel:(NSString*)chId userId:(NSString*)userId;
- (void)disconnectChannel;
- (void)deleteChannel;

- (void)userCommand:(NSString*)peerId command:(NSString*)command;
- (void)getChannelList:(id<PlayRTCServiceHelperListener>)listener;

#pragma mark - PlayRTCDataObserver
-(void)onConnectChannel:(PlayRTC*)obj channelId:(NSString*)channelId reason:(NSString*)reason;
-(void)onRing:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
-(void)onAccept:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
-(void)onReject:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
-(void)onUserCommand:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(NSString*)data;
-(void)onAddLocalStream:(PlayRTC*)obj media:(PlayRTCMedia*)media;
-(void)onAddRemoteStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid media:(PlayRTCMedia*)media;
-(void)onAddDataStream:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid data:(PlayRTCData*)data;
-(void)onDisconnectChannel:(PlayRTC*)obj reason:(NSString*)reason;
-(void)onOtherDisconnectChannel:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid;
-(void)onError:(PlayRTC*)obj status:(PlayRTCStatus)status code:(PlayRTCCode)code desc:(NSString*)desc;
-(void)onStateChange:(PlayRTC*)obj peerId:(NSString*)peerId peerUid:(NSString*)peerUid status:(PlayRTCStatus)status desc:(NSString*)desc;

@end

#endif
