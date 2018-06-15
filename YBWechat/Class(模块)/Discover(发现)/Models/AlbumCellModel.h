//
//  AlbumCellModel.h
//  YBWechat
//
//  Created by 易博 on 2018/6/14.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumCellModel : NSObject

//朋友圈id
@property (nonatomic,copy) NSString *momentsId;

//文字内容
@property (nonatomic,copy) NSString *content;

//类型，包括纯文本0、纯图片1、链接2等
@property (nonatomic,copy) NSString *type;

//月份
@property (nonatomic,copy) NSString *month;

//日期
@property (nonatomic,copy) NSString *day;

//图片数组
@property (nonatomic,strong) NSArray *picArr;

//高度
@property (nonatomic,assign) CGFloat cellHeight;

//根据字典初始化模型
-(instancetype)initModelWithDict:(NSDictionary *)dict;

@end
