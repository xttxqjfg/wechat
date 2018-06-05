//
//  MomentsDataModel.h
//  YBWechat
//
//  Created by 易博 on 2018/5/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentsDataModel : NSObject
//用户id
@property (nonatomic,copy) NSString *userId;
//朋友圈id
@property (nonatomic,copy) NSString *momentsId;
//用户名称
@property (nonatomic,copy) NSString *userName;
//用户头像
@property (nonatomic,copy) NSString *userPic;
//文字内容
@property (nonatomic,copy) NSString *content;
//类型，包括纯文本、纯图片、链接等
@property (nonatomic,copy) NSString *type;
//时间戳
@property (nonatomic,copy) NSString *time;
//图片数组
@property (nonatomic,strong) NSArray *picArr;
//点赞数组
@property (nonatomic,strong) NSMutableArray *praiseArr;
//评论数组
@property (nonatomic,strong) NSMutableArray *commendArr;
//组头高，包括内容、图片、点赞等
@property (nonatomic,assign) CGFloat cellHeaderHeight;
//图片区域的高度
@property (nonatomic,assign) CGFloat picViewHeight;
//点赞列表区域的高度
@property (nonatomic,assign) CGFloat praiseViewHeight;

//根据字典初始化模型
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end
