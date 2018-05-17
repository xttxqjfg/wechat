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
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelYConstraint;

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
    
    if([dataDic objectForKey:@"subTitle"])
    {
        self.rightSubTitleLabel.hidden = NO;
        self.labelYConstraint.constant = -10.0;
        self.rightSubTitleLabel.text = [dataDic objectForKey:@"subTitle"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"subTitle"]] : @"";
    }
    else
    {
        self.rightSubTitleLabel.hidden = YES;
        self.labelYConstraint.constant = 0;
    }
    
    self.rightTitleLabel.text = [dataDic objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]] : @"";
}

@end
