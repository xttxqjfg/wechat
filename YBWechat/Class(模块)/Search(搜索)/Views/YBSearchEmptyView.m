//
//  YBSearchEmptyView.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBSearchEmptyView.h"

@interface YBSearchEmptyView()

@end

@implementation YBSearchEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBSearchEmptyView" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

@end
