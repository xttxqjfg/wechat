//
//  TranslationDataModel.h
//  YBWechat
//
//  Created by 易博 on 2018/5/22.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslationDataModel : AFHTTPSessionManager

+ (instancetype)sharedManager;

+ (void)baiduTextTranslationRequest:(NSDictionary *)params Block:(void(^)(NSString *result, NSString *message))block;

@end
