//
//  YBNetRequestManager.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YBNetRequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestDataWithPath:(NSString *)path
             WithParameters:(NSDictionary *)parameters
            WithRequstStyle:(NSString *)requestStyle
                   Progress:(nullable void (^)(NSProgress *progress))Progress
                   andBlock:(nullable void (^)(id data, NSError *error))resultBlock;

- (void)postRequestDataWithPath:(NSString *)path
                 WithParameters:(NSDictionary *)parameters
      constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                       Progress:(nullable void (^)(NSProgress *progress))Progress
                       andBlock:(nullable void (^)(id data, NSError *error))resultBlock;
@end
NS_ASSUME_NONNULL_END
