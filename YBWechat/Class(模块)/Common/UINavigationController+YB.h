//
//  UINavigationController+YB.h
//  YBWechat
//
//  Created by 易博 on 2018/2/28.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

//透明导航栏相关
#import "UIViewController+YB.h"

@interface UINavigationController (YB) <UINavigationBarDelegate,UINavigationControllerDelegate>

/**
 设置导航栏背景透明度
 
 @param alpha 透明度的浮点值
 */
-(void)setNavigationBackground:(CGFloat)alpha;

@end
