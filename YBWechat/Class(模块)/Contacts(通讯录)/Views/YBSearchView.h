//
//  YBSearchView.h
//  YBWechat
//
//  Created by 易博 on 2018/2/12.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBSearchViewDelegate <NSObject>

-(void)searchViewTapped;

-(void)voiceBtnTapped;

@end

@interface YBSearchView : UIView

@property (nonatomic,assign) id<YBSearchViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)searchType;

@end
