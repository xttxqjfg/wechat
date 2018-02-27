//
//  RCDBHelper.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface RCDBHelper : NSObject

+(FMDatabaseQueue *) getDatabaseQueue;

+(void)closeDataBase;

+(BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db;

@end
