//
//  RCDBManager.m
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "RCDBManager.h"

#import "RCDBHelper.h"

@implementation RCDBManager

static NSString * const userTableName = @"USERTABLE";
static NSString * const groupTableName = @"GROUPTABLE";
static NSString * const groupMemberTableName = @"GROUPMEMBERTABLE";

+ (RCDBManager*)shareInstance
{
    static RCDBManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance CreateUserTable];
    });
    return instance;
}

//创建用户存储表
-(void)CreateUserTable
{
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db setKey:DATABASE_KEY];
        
        if (![RCDBHelper isTableOK: userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![RCDBHelper isTableOK: groupTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPTABLE (id integer PRIMARY KEY autoincrement, groupId text,name text, portraitUri text,inNumber text,maxNumber text ,introduce text ,creatorId text,creatorTime text, isJoin text, isDismiss text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_groupid ON GROUPTABLE(groupId);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![RCDBHelper isTableOK: groupMemberTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPMEMBERTABLE (id integer PRIMARY KEY autoincrement, groupid text, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_groupmemberId ON GROUPMEMBERTABLE(groupid,userid);";
            [db executeUpdate:createIndexSQL];
        }
    }];
}

#pragma mark 用户相关的数据库操作 ---开始---
//存储用户信息
-(void)insertUserToDB:(YBUserInfo*)user
{
    NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.name,user.portraitUri];
    }];
}

//存储全部好友信息,采用事务实现，效率高
-(void)insertAllUserToDB:(NSMutableArray *)userList
{
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < userList.count; i++) {
                NSString *sql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
                YBUserInfo *userinfo = (YBUserInfo *)[userList objectAtIndex:i];
                BOOL a = [db executeUpdate:sql,userinfo.userId,userinfo.name,userinfo.portraitUri];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
    }];
}

//从表中获取用户信息
-(YBUserInfo*) getUserByUserId:(NSString*)userId
{
    __block YBUserInfo *model = nil;
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?",userId];
        while ([rs next]) {
            model = [[YBUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}

//从表中获取所有用户信息
-(NSArray *) getAllUserInfo
{
    NSMutableArray *allUsers = [[NSMutableArray alloc]init];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE"];
        while ([rs next]) {
            YBUserInfo *model;
            model = [[YBUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return [allUsers copy];
}

//清空用户缓存数据
-(void)clearUserData
{
    NSString *deleteSql = @"DELETE FROM USERTABLE";
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//删除用户
-(void)deleteUserFromDB:(NSString *)userId
{
    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM USERTABLE WHERE userid=%@",userId];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}
#pragma mark 用户相关的数据库操作 ---结束---

#pragma mark 群组相关的数据库操作 ---开始---
//存储群组信息
-(void)insertGroupToDB:(YBGroupInfo *)group
{
    if(group == nil || [group.groupId length]<1)
        return;
    
    NSString *insertSql = @"REPLACE INTO GROUPTABLE (groupId, name,portraitUri,inNumber,maxNumber,introduce,creatorId,creatorTime,isJoin,isDismiss) VALUES (?,?,?,?,?,?,?,?,?,?)";
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,group.groupId, group.groupName,group.portraitUri,group.number,group.maxNumber,group.introduce,group.creatorId,group.creatorTime,[NSString stringWithFormat:@"%d",group.isJoin],group.isDismiss];
    }];
}

//存储全部群组信息,采用事务实现，效率高
-(void)insertAllGroupToDB:(NSMutableArray *)groupList
{
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < groupList.count; i++) {
                NSString *sql = @"REPLACE INTO GROUPTABLE (groupId, name,portraitUri,inNumber,maxNumber,introduce,creatorId,creatorTime,isJoin,isDismiss) VALUES (?,?,?,?,?,?,?,?,?,?)";
                YBGroupInfo *groupinfo = (YBGroupInfo *)[groupList objectAtIndex:i];
                BOOL a = [db executeUpdate:sql,groupinfo.groupId, groupinfo.groupName,groupinfo.portraitUri,groupinfo.number,groupinfo.maxNumber,groupinfo.introduce,groupinfo.creatorId,groupinfo.creatorTime,[NSString stringWithFormat:@"%d",groupinfo.isJoin],groupinfo.isDismiss];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
    }];
}

//从表中获取群组信息
-(YBGroupInfo*) getGroupByGroupId:(NSString*)groupId
{
    __block YBGroupInfo *model = nil;
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLE where groupId = ?",groupId];
        while ([rs next]) {
            model = [[YBGroupInfo alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.number=[rs stringForColumn:@"inNumber"];
            model.maxNumber=[rs stringForColumn:@"maxNumber"];
            model.introduce=[rs stringForColumn:@"introduce"];
            model.creatorId=[rs stringForColumn:@"creatorId"];
            model.creatorTime=[rs stringForColumn:@"creatorTime"];
            model.isJoin=[rs boolForColumn:@"isJoin"];
            model.isDismiss = [rs stringForColumn:@"isDismiss"];
            
        }
        [rs close];
    }];
    return model;
}

//删除表中的群组信息
-(void)deleteGroupToDB:(NSString *)groupId
{
    if([groupId length]<1)
        return;
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",@"GROUPTABLE", @"groupid", groupId];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//从表中获取所有群组信息
-(NSArray *) getAllGroup
{
    NSMutableArray *allGroups = [NSMutableArray new];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 ORDER BY groupId"];
        while ([rs next]) {
            YBGroupInfo *model;
            model = [[YBGroupInfo alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.number=[rs stringForColumn:@"inNumber"];
            model.maxNumber=[rs stringForColumn:@"maxNumber"];
            model.introduce=[rs stringForColumn:@"introduce"];
            model.creatorId=[rs stringForColumn:@"creatorId"];
            model.creatorTime=[rs stringForColumn:@"creatorTime"];
            model.isJoin=[rs boolForColumn:@"isJoin"];
            [allGroups addObject:model];
        }
        [rs close];
    }];
    return allGroups;
}

//清空表中的所有的群组信息
-(BOOL)clearGroupfromDB
{
    __block BOOL result = NO;
    NSString *clearSql =[NSString stringWithFormat:@"DELETE FROM GROUPTABLE"];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return result;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:clearSql];
    }];
    return result;
}

//清空群组缓存数据
-(void)clearGroupsData
{
    NSString *deleteSql = @"DELETE FROM GROUPTABLE";
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//存储群组成员信息
-(void)insertGroupMemberToDB:(NSMutableArray *)groupMemberList groupId:(NSString *)groupId
{
    if(groupMemberList == nil || [groupMemberList count]<1)
        return;
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",@"GROUPMEMBERTABLE", @"groupid", groupId];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
        for (RCUserInfo *user in groupMemberList) {
            NSString *insertSql = @"REPLACE INTO GROUPMEMBERTABLE (groupid, userid, name, portraitUri) VALUES (?, ?, ?, ?)";
            //            [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:insertSql,groupId, user.userId, user.name, user.portraitUri];
            //            }];
        }
    }];
}

//从表中获取群组成员信息
-(NSMutableArray *)getGroupMember:(NSString *)groupId
{
    NSMutableArray *allUsers = [NSMutableArray new];
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPMEMBERTABLE where groupid=? order by id", groupId];
        while ([rs next]) {
            RCUserInfo *model;
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

//清空群组成员缓存数据
-(void)clearGroupMembersData
{
    NSString *deleteSql = @"DELETE FROM GROUPMEMBERTABLE";
    FMDatabaseQueue *queue = [RCDBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

#pragma mark 群组相关的数据库操作 ---结束---

@end
