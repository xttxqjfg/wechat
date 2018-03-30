//
//  YBAddFriendsTopView.h
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBAddFriendsTopViewDelegate <NSObject>

//1表示点击了搜索框，2表示点击了二维码
-(void)topViewActionWithType:(NSInteger)type;

@end

@interface YBAddFriendsTopView : UIView

@property (nonatomic,weak) id<YBAddFriendsTopViewDelegate> delegate;

@end
