//
//  YBUserCache.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUserCache.h"

// 用户信息归档Key
#define kUserInfoArchiver @"UserInfoArchiver"
// 用户信息归档文件路径
#define FILE_PATH_FOR_USER_ARCHIVER [DIR_PATH_FOR_CONFIG stringByAppendingPathComponent:kUserInfoArchiver]

static NSString *const kUserInfo         = @"userinfo";

@interface YBUserCache()

@end

@implementation YBUserCache

// 归档帐户信息
- (void)archiverAccount{
    [NSFileManager archiver:self forKey:kUserInfoArchiver toFile:FILE_PATH_FOR_USER_ARCHIVER];
}

// 解档帐户信息
+ (YBUserCache *)unArchiverAccount{
    return [NSFileManager unArchiverFromFile:FILE_PATH_FOR_USER_ARCHIVER withKey:kUserInfoArchiver];
}

#pragma mark - NSCoding Delegate method
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _userInfoDict = [aDecoder decodeObjectForKey:kUserInfo];
    }
    return self;
}

// 解档用户信息
- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *userinfoDict = _userInfoDict;
    [aCoder encodeObject: userinfoDict forKey:kUserInfo];
}

// 判断登录用户是否存在
+ (BOOL)exists{
    if (![YBUserCache unArchiverAccount]) {
        return NO;
    }
    
    NSDictionary *userDic = [YBUserCache unArchiverAccount].userInfoDict;
    if ([userDic objectForKey:User_Info_ID] && [[userDic objectForKey:User_Info_ID] length] > 0) {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 清空用户本地信息
+ (void)clearUserInfo{
    YBUserCache *user = [YBUserCache unArchiverAccount];
    user.userInfoDict = nil;
    [user archiverAccount];
}

- (NSString*)description{
    NSMutableString *userInfoStr = [NSMutableString stringWithString:@"用户归档信息\n"];
    [userInfoStr appendString:@"----------------------------- ↓"];
    [userInfoStr appendFormat:@"userInfoDict:%@\n",_userInfoDict];
    [userInfoStr appendString:@"----------------------------- ↑"];
    return [userInfoStr description];
}

@end
