//
//  BusinessCardSendMessage.h
//  YBWechat
//
//  Created by 易博 on 2018/5/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 名片发送消息的类型名
 */
#define YBBusinessCardSendMessageTypeIdentifier @"YB:CardSendMsg"

@interface BusinessCardSendMessage : RCMessageContent <NSCoding>

/*!
 名片发送消息的内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 名片发送息的附加信息
 */
@property(nonatomic, strong) NSString *extra;

/*!
 初始化名片发送消息
 
 @param content 文本内容
 @return        消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
