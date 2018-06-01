//
//  YBPicsBrowser.h
//  YBWechat
//
//  Created by 易博 on 2018/5/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPicsBrowser : UIView

@property (nonatomic,copy) NSArray *picArr;

//从指定页开始显示
-(void)showAtPage:(NSInteger)page;
@end
