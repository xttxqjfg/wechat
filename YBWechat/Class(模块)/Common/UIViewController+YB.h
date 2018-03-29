//
//  UIViewController+YB.h
//  YBWechat
//
//  Created by 易博 on 2018/2/28.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

//透明导航栏相关
#import "UINavigationController+YB.h"

@interface UIViewController (YB)

//vc的导航bar背景透明度
@property (copy,nonatomic) NSString *navBarBgAlpha;

@end
