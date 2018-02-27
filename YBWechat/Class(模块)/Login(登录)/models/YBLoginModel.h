//
//  YBLoginModel.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLoginModel : NSObject

+ (void)loginRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block;

+ (void)registerRequest:(NSDictionary *)params Block:(void(^)(NSDictionary *result, NSString *message))block;

+ (void)initRongYun;

@end
