//
//  YBContactCell.m
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBContactCell.h"

@interface YBContactCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@end

@implementation YBContactCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBContactCell" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

-(void)setDataModel:(ContactDateModel *)dataModel
{
    _dataModel = dataModel;
    
    self.rightLabel.text = [dataModel.userName length] > 0 ? dataModel.userName : @"";
    
    if([dataModel.userPortrait length] > 0 && [dataModel.userPortrait hasPrefix:@"http"])
    {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.userPortrait] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
    }
    else if([dataModel.userPortrait length] > 0 && [dataModel.userPortrait hasPrefix:@"local:"])
    {
        self.leftImageView.image = [UIImage imageNamed:[dataModel.userPortrait substringFromIndex:6]];
    }
    else
    {
        if(0 == [dataModel.userName length])
        {
            self.leftImageView.image = [UIImage imageNamed:@"default_user_image"];
        }
        else
        {
            NSString *localUrl = [YBUtils defaultUserPortrait:[[RCUserInfo alloc] initWithUserId:dataModel.userId name:dataModel.userName portrait:@""]];
            [self.leftImageView sd_setImageWithURL:[NSURL fileURLWithPath:localUrl] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
        }
    }
}

@end
