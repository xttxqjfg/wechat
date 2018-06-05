//
//  YBCommendModel.h
//  YBWechat
//
//  Created by 易博 on 2018/5/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBCommendModel : NSObject

//评论用户id
@property (nonatomic,copy) NSString *firstUserId;
//评论用户名称
@property (nonatomic,copy) NSString *firstUserName;
//回复评论用户id
@property (nonatomic,copy) NSString *secondUserId;
//回复评论用户名称
@property (nonatomic,copy) NSString *secondUserName;
//评论内容
@property (nonatomic,copy) NSString *content;
//高度
@property (nonatomic,assign) CGFloat cellHeight;

@end
