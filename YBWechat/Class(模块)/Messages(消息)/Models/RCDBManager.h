//
//  RCDBManager.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MsgOperateModel.h"

@interface RCDBManager : NSObject

+ (RCDBManager*)shareInstance;

#pragma mark 用户相关的数据库操作 ---开始---
//存储用户信息
-(void)insertUserToDB:(YBUserInfo*)user;

//存储全部好友信息,采用事务实现，效率高
-(void)insertAllUserToDB:(NSMutableArray *)userList;

//从表中获取用户信息
-(YBUserInfo*) getUserByUserId:(NSString*)userId;

//从表中获取所有用户信息
-(NSArray *) getAllUserInfo;

//清空用户缓存数据
-(void)clearUserData;

//删除用户
-(void)deleteUserFromDB:(NSString *)userId;
#pragma mark 用户相关的数据库操作 ---结束---

#pragma mark 群组相关的数据库操作 ---开始---
//存储群组信息
-(void)insertGroupToDB:(YBGroupInfo *)group;

//存储全部群组信息,采用事务实现，效率高
-(void)insertAllGroupToDB:(NSMutableArray *)groupList;

//从表中获取群组信息
-(YBGroupInfo*) getGroupByGroupId:(NSString*)groupId;

//删除表中的群组信息
-(void)deleteGroupToDB:(NSString *)groupId;

//从表中获取所有群组信息
-(NSArray *) getAllGroup;

//清空表中的所有的群组信息
-(BOOL)clearGroupfromDB;

//清空群组缓存数据
-(void)clearGroupsData;

//存储群组成员信息
-(void)insertGroupMemberToDB:(NSMutableArray *)groupMemberList groupId:(NSString *)groupId;

//从表中获取群组成员信息
-(NSMutableArray *)getGroupMember:(NSString *)groupId;

//清空群组成员缓存数据
-(void)clearGroupMembersData;

#pragma mark 群组相关的数据库操作 ---结束---

#pragma mark 消息记录相关的数据库操作 ---开始---
//存储用户信息
-(void)insertOperateToDB:(MsgOperateModel *)model;

//从表中获取用户信息
-(MsgOperateModel *)getOperateModelById:(NSString *)msgId;

//删除用户
-(void)deleteOperateFromDB:(NSString *)msgId;
#pragma mark 消息记录相关的数据库操作 ---结束---

@end
