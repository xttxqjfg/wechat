//
//  UITableViewIndex+YB.h
//  YBWechat
//
//  Created by 易博 on 2018/3/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (YBIndexTip)

//显示索引字符悬浮提示;在点击或滑动索引时，在UITableView中间显示一个Label显示当前的索引字符
-(void)addIndexTip;

@end
