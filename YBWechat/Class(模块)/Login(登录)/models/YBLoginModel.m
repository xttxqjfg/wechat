//
//  YBLoginModel.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBLoginModel.h"

#import "RCDataSource.h"

#import "TranslationMessage.h"

@implementation YBLoginModel

+ (void)loginRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block
{
    [[YBNetRequestManager sharedManager] requestDataWithPath:SNet_User_Login WithParameters:params WithRequstStyle:@"post" Progress:^(NSProgress * _Nonnull progress) {
        //
    } andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (![data objectForKey:@"msg"]) {
                NSDictionary *userInfo = data[@"result"];
                block(userInfo,nil);
            }
            else {
                NSString *message = data[@"msg"];
                block(nil,message);
            }
        }
        else {
            block(nil,error.localizedDescription);
        }
    }];
}

+ (void)registerRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block
{
    [[YBNetRequestManager sharedManager] requestDataWithPath:SNet_User_Register WithParameters:params WithRequstStyle:@"post" Progress:^(NSProgress * _Nonnull progress) {
        //
    } andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (![data objectForKey:@"msg"]) {
                NSDictionary *userInfo = data[@"result"];
                block(userInfo,nil);
            }
            else {
                NSString *message = data[@"msg"];
                block(nil,message);
            }
        }
        else {
            block(nil,error.localizedDescription);
        }
    }];
}

+ (void)initRongYun
{
    //融云注册
    //appkey cpj2xarljn8on
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_INT_KEY];
    
    // 注册自定义测试消息
    [[RCIM sharedRCIM] registerMessageType:[TranslationMessage class]];
    
    //设置红包扩展的Url Scheme。Scheme自定义，extensionModule不做修改
    [[RCIM sharedRCIM] setScheme:@"ybwechat" forExtensionModule:@"JrmfPacketManager"];
    
    //设置会话列表头像和会话界面头像

    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40 * YB_WIDTH_PRO, 40 * YB_WIDTH_PRO);
    //会话列表的头像形状
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    //聊天界面头像的大小
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(35 * YB_WIDTH_PRO, 35 * YB_WIDTH_PRO);
    //聊天界面的头像形状
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = NO;
    
    //设置消息发送携带用户信息
    [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    //显示输入状态
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //设置消息回执
//    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),
//                                                                 @(ConversationType_GROUP)];
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //消息撤回
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //群组@功能
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = [RCDataSource shareInstance];
    [RCIM sharedRCIM].groupInfoDataSource = [RCDataSource shareInstance];
    [RCIM sharedRCIM].groupMemberDataSource = [RCDataSource shareInstance];
}

@end
