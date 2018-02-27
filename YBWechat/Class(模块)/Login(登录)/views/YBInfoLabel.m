//
//  YBInfoLabel.m
//  YBWechat
//
//  Created by 易博 on 2018/2/6.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBInfoLabel.h"

@implementation YBInfoLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBInfoLabel" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

@end
