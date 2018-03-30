//
//  YBButtonView.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBButtonView.h"


@interface YBButtonView()

@end

@implementation YBButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBButtonView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.btnBackView.layer.cornerRadius = 5.0;
        self.btnBackView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)btnViewTapped
{
    if ([self.delegate respondsToSelector:@selector(btnViewClickedWithTag:)]) {
        [self.delegate btnViewClickedWithTag:self.tag];
    }
}

@end
