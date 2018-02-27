//
//  YBUserCache.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户信息key值
#define User_Info_ID @"userId"
#define User_Info_Name @"userName"
#define User_Info_Token @"userToken"

@interface YBUserCache : NSObject

/**
 *  用户信息字典
 */
@property (nonatomic,copy) NSDictionary *userInfoDict;

/**
 *  归档账户
 */
- (void)archiverAccount;

/**
 *  解档账户
 *
 *  @return 返回解档对象
 */
+ (YBUserCache*)unArchiverAccount;

/**
 *  检查用户是否存在
 *
 */
+ (BOOL)exists;

/**
 *  清空用户本地信息
 */
+ (void)clearUserInfo;

@end
