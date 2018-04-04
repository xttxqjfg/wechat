//
//  YBActionSheetView.h
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBActionSheetViewDelegate <NSObject>

//消失
@optional -(void)actionSheetViewDismiss;

//点击
-(void)selectedActionSheetViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YBActionSheetView : UIView

@property (nonatomic,weak) id<YBActionSheetViewDelegate> delegate;

//不包含取消按钮的数据
@property (nonatomic,copy) NSArray *btnArr;

//显示菜单
-(void)showActionSheet;

@end
