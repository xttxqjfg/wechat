//
//  RCDBHelper.m
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "RCDBHelper.h"

@implementation RCDBHelper

static FMDatabaseQueue *databaseQueue = nil;

+(FMDatabaseQueue *) getDatabaseQueue
{
    if (![YBUserCache exists]) {
        return nil;
    }
    if (!databaseQueue) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"WechatDB%@",Golble_User_Id]];
        
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database setKey:DATABASE_KEY];
    }
    
    return databaseQueue;
    
}

+(void)closeDataBase
{
    databaseQueue = nil;
}

+ (BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isOK = NO;
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            isOK =  NO;
        }
        else
        {
            isOK = YES;
        }
    }
    [rs close];
    
    return isOK;
}

@end
