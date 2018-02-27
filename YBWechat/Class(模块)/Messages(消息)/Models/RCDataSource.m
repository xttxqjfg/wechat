//
//  RCDataSource.m
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "RCDataSource.h"

@implementation RCDataSource

+ (RCDataSource*)shareInstance
{
    static RCDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return;
    
    YBGroupInfo *groupInfo = [[RCDBManager shareInstance] getGroupByGroupId:groupId];
    if (!groupInfo) {
        completion(nil);
        //调用接口查询
        /*
        NSDictionary *temp =@{@"groupId":groupId};
        [AFHttpTool getGroupByID:temp success:^(id response) {
            if ([[response objectForKey:@"code"] integerValue] == 200) {
                
                NSDictionary *dic = response[@"result"];
                RYGroupInfo *group = [RYGroupInfo new];
                group.groupId = [dic objectForKey:@"id"];
                group.groupName = [dic objectForKey:@"name"];
                group.portraitUri = @"";
                if (!group.portraitUri || group.portraitUri.length <= 0) {
                    group.portraitUri = @"";
                }
                [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(group);
                    });
                }
            } else {
                RYGroupInfo *group = [RYGroupInfo new];
                group.groupId = groupID;
                group.groupName = [NSString stringWithFormat:@"name%@", groupID];
                group.portraitUri = @"";
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(group);
                    });
                }
            }
        } failure:^(NSError *err) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RYGroupInfo *group = [RYGroupInfo new];
                    group.groupId = groupID;
                    group.groupName = [NSString stringWithFormat:@"name%@", groupID];
                    group.portraitUri = @"";
                    
                    completion(group);
                });
            }
        }];
         */
    } else {
        if (completion) {
            if (!groupInfo.portraitUri || groupInfo.portraitUri.length <= 0) {
                groupInfo.portraitUri = @"";
            }
            completion(groupInfo);
        }
    }
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    YBUserInfo *userInfo = [[RCDBManager shareInstance] getUserByUserId:userId];
    if (!userInfo) {
        
        completion(nil);
        
        /*
        NSDictionary *params = @{@"userId":[SMAUserManager sharedManager].userID,@"toUserId":userID};
        
        [UserDetailModel initUserDetailModel:params andBlock:^(NSDictionary *result, NSString *errDes) {
            
            if (errDes) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        RYUserInfo *user = [RYUserInfo new];
                        user.userId = userID;
                        user.name = @"用户不存在";
                        user.portraitUri = @"";
                        
                        completion(user);
                    });
                }
            }
            else
            {
                if ([result objectForKey:@"userId"] && [[NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]] length] > 0) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RYUserInfo *userInfo = [[RYUserInfo alloc]init];
                            userInfo.userId = userID;
                            //如果存在备注名则取备注名，不存在则取用户名
                            userInfo.name = [result objectForKey:@"remarksName"] && [[NSString stringWithFormat:@"%@",[result objectForKey:@"remarksName"]] length] > 0 ? [NSString stringWithFormat:@"%@",[result objectForKey:@"remarksName"]] : [NSString stringWithFormat:@"%@",[result objectForKey:@"userName"]];
                            userInfo.portraitUri = [NSString stringWithFormat:@"%@",[result objectForKey:@"avatarUrl"]];
                            
                            [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                            
                            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userID];
                            
                            completion(userInfo);
                        });
                    }
                }
                else
                {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RYUserInfo *user = [RYUserInfo new];
                            user.userId = userID;
                            user.name = @"用户不存在";
                            user.portraitUri = @"";
                            
                            completion(user);
                        });
                    }
                }
            }
        }];
         */
    } else {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!userInfo.portraitUri || userInfo.portraitUri.length <= 0) {
                    userInfo.portraitUri = [YBUtils defaultUserPortrait:userInfo];
                }
                completion(userInfo);
            });
        }
    }
}

#pragma mark - RCIMGroupMemberDataSource
-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock
{
    NSLog(@"getUserInfoWithUserId ----- %@", groupId);
    
    /*
    //根据群id加载群组设置数据
    NSDictionary *dic = @{@"groupId":groupId,@"operateUser":[RCIM sharedRCIM].currentUserInfo.userId};
    
    [AFHttpTool getGroupByID:dic success:^(id response) {
        
        if ([[response objectForKey:@"code"] integerValue] != 200) {
            
            userList(nil);
        }
        else
        {
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[response objectForKey:@"result"]];
            NSMutableArray *userInfoList = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"memberList"]];
            NSMutableArray *userIdList = [[NSMutableArray alloc]init];
            for (NSDictionary *userInfo in userInfoList) {
                //groupId\isManager\userId\userName
                [userIdList addObject:[userInfo objectForKey:@"userId"]];
            }
            userList(userIdList);
        }
    } failure:^(NSError *err) {
        
        userList(nil);
    }];
     */
}

@end
