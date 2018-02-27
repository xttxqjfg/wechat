//
//  YBGroupInfo.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface YBGroupInfo : RCGroup <NSCoding>

/** 人数 */
@property(nonatomic, strong) NSString* number;
/** 最大人数 */
@property(nonatomic, strong) NSString* maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString* introduce;

/** 创建者Id */
@property(nonatomic, strong) NSString* creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString* creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL  isJoin;
/** 是否解散 */
@property(nonatomic, strong) NSString *isDismiss;

@end
