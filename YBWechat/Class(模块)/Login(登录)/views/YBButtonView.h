//
//  YBButtonView.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBButtonViewDelegate <NSObject>

-(void)btnViewClicked;

@end

@interface YBButtonView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) id<YBButtonViewDelegate> delegate;

@end
