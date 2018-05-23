//
//  TranslationMessage.h
//  YBWechat
//
//  Created by 易博 on 2018/5/21.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>


/*!
 翻译消息的类型名
 */
#define YBTranslationMessageTypeIdentifier @"YB:TranslationMsg"

@interface TranslationMessage : RCMessageContent <NSCoding>

/*!
 翻译消息的内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 翻译消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;

/*!
 初始化翻译消息
 
 @param content 文本内容
 @return        消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
