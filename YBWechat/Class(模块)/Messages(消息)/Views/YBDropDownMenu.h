//
//  YBDropDownMenu.h
//  YBWechat
//
//  Created by 易博 on 2018/2/27.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBDropDownMenuDelegate <NSObject>

-(void)selectedMenuAtIndex:(NSInteger)index;

@end

@interface YBDropDownMenu : UIView

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,assign) NSInteger triangleType;

@property (nonatomic,assign) id<YBDropDownMenuDelegate> delegate;

@end
