//
//  YBButtonView.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBButtonView.h"


@interface YBButtonView()
@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;
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
        self.btnBackView.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:152.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)btnViewTapped
{
    if ([self.delegate respondsToSelector:@selector(btnViewClicked)]) {
        [self.delegate btnViewClicked];
    }
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.btnLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
}

@end
