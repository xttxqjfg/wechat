//
//  YBContactsModel.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBContactsModel : NSObject

+ (void)userListRequest:(NSDictionary *)params Block:(void(^)(NSArray *result, NSString *message))block;

+ (void)userDetailRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block;

+ (void)pubSerMenuListRequest:(NSDictionary *)params Block:(void(^)(NSArray *result, NSString *message))block;

@end
