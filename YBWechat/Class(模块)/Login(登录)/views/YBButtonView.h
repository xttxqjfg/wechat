//
//  YBButtonView.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBButtonViewDelegate <NSObject>

-(void)btnViewClickedWithTag:(NSInteger)tag;

@end

@interface YBButtonView : UIView

@property (nonatomic,assign) id<YBButtonViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;

@end
