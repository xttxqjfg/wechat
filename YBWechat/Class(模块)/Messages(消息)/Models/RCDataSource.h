//
//  RCDataSource.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDataSource : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource>

+(RCDataSource *) shareInstance;

@end
