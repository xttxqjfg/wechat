//
//  YBAddFriensCell.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBAddFriensCell.h"

@interface YBAddFriensCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDescribeLabel;

@end

@implementation YBAddFriensCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBAddFriensCell" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.rightTitleLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
    
    self.rightDescribeLabel.text = [dataDic objectForKey:@"subtitle"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"subtitle"]] : @"";
    
    if ([dataDic objectForKey:@"image"]) {
        self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]]];
    }
    else
    {
        self.leftImageView.image = [UIImage imageNamed:@"logo"];
    }
}

@end
