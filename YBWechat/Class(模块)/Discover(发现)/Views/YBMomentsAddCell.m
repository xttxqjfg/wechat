//
//  YBMomentsAddCell.m
//  YBWechat
//
//  Created by 易博 on 2018/5/23.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsAddCell.h"

@interface YBMomentsAddCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

@end

@implementation YBMomentsAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBMomentsAddCell" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.leftImageView.image = [dataDic objectForKey:@"image"] ? [UIImage imageNamed:[dataDic objectForKey:@"image"]] : [UIImage imageNamed:@"mine_set"];
    self.leftTitleLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
}

@end
