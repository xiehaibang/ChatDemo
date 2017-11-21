//
//  XHBXMPPTool.h
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/20.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBXMPPTool : NSObject <XMPPStreamDelegate>

@property (nonatomic, strong) XMPPStream * xmppStream;

@property (nonatomic, strong) XMPPAutoPing * xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect * xmppReconnect;

@property (nonatomic, assign) BOOL xmppNeedRegister;
@property (nonatomic, copy)   NSString * myPassword;


+ (instancetype)sharedInstance;
- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password;
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password;

@end
