//
//  YBMomentsCommendCell.h
//  YBWechat
//
//  Created by 易博 on 2018/6/5.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBCommendModel.h"

@protocol YBMomentsCommendCellDelegate <NSObject>

-(void)selectedUserWithIdOnCommendCell:(NSString *)userId;

@end

@interface YBMomentsCommendCell : UITableViewCell

@property (nonatomic,strong) YBCommendModel *commendModel;

@property (nonatomic,assign) id<YBMomentsCommendCellDelegate> delegate;

//设置cell选中时评论区域的背景色，0.2秒后恢复
-(void)setCommendSelectedAnimation;

@end
