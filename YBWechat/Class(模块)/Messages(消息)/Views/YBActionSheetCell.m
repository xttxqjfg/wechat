//
//  YBActionSheetCell.m
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBActionSheetCell.h"

@interface YBActionSheetCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;

@end

@implementation YBActionSheetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBActionSheetCell" owner:nil options:nil][0];
        self.frame = frame;
    }
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    if ([dataDic objectForKey:@"image"] && [[dataDic objectForKey:@"image"] length] > 0) {
        self.leftImageView.hidden = NO;
        self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]]];
        self.labelConstraint.constant = 10.0;
    }
    else
    {
        self.leftImageView.hidden = YES;
        self.labelConstraint.constant = 0;
    }
    
    self.rightTitleLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
}

@end
