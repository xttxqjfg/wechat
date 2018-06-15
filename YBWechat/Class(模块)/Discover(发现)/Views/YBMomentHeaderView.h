//
//  YBMomentHeaderView.h
//  YBWechat
//
//  Created by 易博 on 2018/6/14.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YBMomentHeaderViewDelegate <NSObject>

//用户头像点击事件
-(void)userPicClickedOnYBMomentHeaderView:(NSString *)userId;

//顶部背景点击事件
-(void)topImageClickedOnYBMomentHeaderView;

@end

@interface YBMomentHeaderView : UIView

@property (nonatomic,strong) NSDictionary *dataInfo;

@property (nonatomic,weak) id<YBMomentHeaderViewDelegate> delegate;

@end
