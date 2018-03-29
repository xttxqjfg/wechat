//
//  YBSearchToolView.h
//  YBWechat
//
//  Created by 易博 on 2018/3/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBSearchToolViewDelegate <NSObject>

-(void)searchCancleBtnClicked;

@end

@interface YBSearchToolView : UIView

@property (nonatomic,weak) id<YBSearchToolViewDelegate> delegate;

@end
