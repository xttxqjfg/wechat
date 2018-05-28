//
//  MsgOperateModel.h
//  YBWechat
//
//  Created by 易博 on 2018/5/28.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgOperateModel : NSObject

@property (nonatomic,strong) NSString *msgId;
//1:名片请求、2:好友请求
@property (nonatomic,strong) NSString *operateType;
//0、1
@property (nonatomic,strong) NSString *operateValue;

@end
