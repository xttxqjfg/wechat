//
//  YBContactsModel.m
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBContactsModel.h"
#import "ContactDateModel.h"

@implementation YBContactsModel

+ (void)userListRequest:(NSDictionary *)params Block:(void(^)(NSArray *result, NSString *message))block
{
    [[YBNetRequestManager sharedManager] requestDataWithPath:SNet_User_List WithParameters:params WithRequstStyle:@"post" Progress:^(NSProgress * _Nonnull progress) {
        //
    } andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (![data objectForKey:@"msg"]) {
                NSArray *userList = [[NSArray alloc]initWithArray:data[@"result"]];
                NSMutableArray *userModelList = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in userList) {
                    [userModelList addObject:[ContactDateModel yy_modelWithDictionary:dic]];
                }
                block(userModelList,nil);
            }
            else {
                NSString *message = data[@"msg"];
                block(nil,message);
            }
        }
        else {
            block(nil,error.localizedDescription);
        }
    }];
}

+ (void)userDetailRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block
{
    [[YBNetRequestManager sharedManager] requestDataWithPath:SNet_User_Detail WithParameters:params WithRequstStyle:@"post" Progress:^(NSProgress * _Nonnull progress) {
        //
    } andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (![data objectForKey:@"msg"]) {
                NSDictionary *userInfo = data[@"result"];
                block(userInfo,nil);
            }
            else {
                NSString *message = data[@"msg"];
                block(nil,message);
            }
        }
        else {
            block(nil,error.localizedDescription);
        }
    }];
}

@end
