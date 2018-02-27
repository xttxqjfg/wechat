//
//  YBDropDownMenuCell.m
//  YBWechat
//
//  Created by 易博 on 2018/2/27.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBDropDownMenuCell.h"

@interface YBDropDownMenuCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation YBDropDownMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBDropDownMenuCell" owner:nil options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:38.0/255.0 blue:47.0/255.0 alpha:0.85];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.leftImageView.image = [dataDic objectForKey:@"image"] ? [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]]] : [UIImage imageNamed:@"add_scan"];
    
    self.rightLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
