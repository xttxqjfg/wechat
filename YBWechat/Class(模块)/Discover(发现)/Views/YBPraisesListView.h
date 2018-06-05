//
//  YBPraisesListView.h
//  YBWechat
//
//  Created by 易博 on 2018/6/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBPraiseModel.h"

@protocol YBPraisesListViewDelegate <NSObject>

-(void)selectedUserWithId:(NSString *)userId;

@end

@interface YBPraisesListView : UIView

@property (nonatomic,strong) NSArray *modelList;

//点赞区和评论区之间的分割线
@property (nonatomic,assign) BOOL showBottomLine;

@property (nonatomic,assign) id<YBPraisesListViewDelegate> delegate;

@end
