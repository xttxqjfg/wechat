//
//  YBOperatePopView.h
//  YBWechat
//
//  Created by 易博 on 2018/6/1.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBOperatePopViewDelegate <NSObject>

//点击按钮事件
//operateType: 0-点赞操作  1-评论操作
//dict:目前包含所点击的朋友圈id
-(void)operateBtnClickedOnPopView:(NSString *)operateType info:(NSDictionary *)dict;

@end

@interface YBOperatePopView : UIView

@property (nonatomic,weak) id<YBOperatePopViewDelegate> delegate;

//初始化数据
@property (nonatomic,strong) NSDictionary *dataDic;

@end
