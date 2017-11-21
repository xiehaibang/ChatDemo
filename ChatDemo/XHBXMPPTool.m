//
//  XHBXMPPTool.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/20.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBXMPPTool.h"

static XHBXMPPTool * _sharedInstance;

@implementation XHBXMPPTool

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[XHBXMPPTool alloc] init];
    });
    
    return _sharedInstance;
}



/**
 登录
 @param JID 用户的JID
 @param password 用户密码
 */
- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password {
    
    [self.xmppStream setMyJID:JID];
    
    self.myPassword = password;
    self.xmppNeedRegister = NO;
    
    //建立 TCP 连接
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

/**
 注册

 @param JID 用户的JID
 @param password 用户的密码
 */
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password {
    
    [self.xmppStream setMyJID:JID];
    
    self.myPassword = password;
    self.xmppNeedRegister = YES;
    
    //建立 TCP 连接
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}


/**
 将用户的状态更改为在线
 */
- (void)goOnline {
    
    //创建在线状态，空值默认为在线
    XMPPPresence * presence = [XMPPPresence presence];
    
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"哈哈哈"]];
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"......"]];
    
    [self.xmppStream sendElement:presence];
}


#pragma mark - XMPPStreamDelegate
//建立连接成功
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    
    NSLog(@"%s", __func__);
}

//xmpp 流初始化成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSLog(@"%s", __func__);
    
    if (self.xmppNeedRegister) {
        
        BOOL result = [self.xmppStream registerWithPassword:self.myPassword error:nil];
        
        NSNumber * resultNumber = [NSNumber numberWithBool:result];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kREGISTER_RESULT object:resultNumber];
    }
    else {
        
        [self.xmppStream authenticateWithPassword:self.myPassword error:nil];
    }
}

//xmpp 流初始化失败
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    NSLog(@"%s", __func__);
}

//登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    
    NSLog(@"%s", __func__);
}

//登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    NSLog(@"%s", __func__);
    
    //更改在线状态
    [self goOnline];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLOGIN_SUCCESE object:nil];
    
}


#pragma mark - getter
- (XMPPStream *)xmppStream {
    
    if (!_xmppStream) {
        
        _xmppStream = [[XMPPStream alloc] init];
        
        [_xmppStream setHostName:@"127.0.0.1"];
        [_xmppStream setHostPort:5222];
        
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _xmppStream;
}

@end
