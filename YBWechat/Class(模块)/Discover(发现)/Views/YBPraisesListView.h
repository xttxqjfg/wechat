//
//  YBPraisesListView.h
//  YBWechat
//
//  Created by 易博 on 2018/6/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBPraisesListViewDelegate <NSObject>

-(void)selectedUserAtIndex:(NSInteger)index;

@end

@interface YBPraisesListView : UIView

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,assign) id<YBPraisesListViewDelegate> delegate;

@end
