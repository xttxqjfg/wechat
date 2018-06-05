//
//  YBMomentsHeaderView.h
//  YBWechat
//
//  Created by 易博 on 2018/5/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MomentsDataModel.h"

@protocol YBMomentsHeaderViewDelegate <NSObject>

//跳转到用户详情
-(void)jumpToUserDetailOnHeaderView:(NSString *)userId;

//跳转到图片浏览控制器
-(void)jumpToPicBrowserOnHeaderView:(NSArray *)picArr index:(NSInteger)index;

//点赞或者评论按钮点击事件
-(void)operateMoreTappedOnHeaderView:(MomentsDataModel *)model point:(CGPoint)point;

@end

@interface YBMomentsHeaderView : UIView

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) MomentsDataModel *headerViewData;

@property (nonatomic,weak) id<YBMomentsHeaderViewDelegate> delegate;

@end
