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

-(void)setDataModel:(YBUserInfo *)dataModel
{
    _dataModel = dataModel;
    
    self.rightLabel.text = [dataModel.name length] > 0 ? dataModel.name : @"";
    
    if([dataModel.portraitUri length] > 0 && [dataModel.portraitUri hasPrefix:@"http"])
    {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.portraitUri] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
    }
    else if([dataModel.portraitUri length] > 0 && [dataModel.portraitUri hasPrefix:@"local:"])
    {
        self.leftImageView.image = [UIImage imageNamed:[dataModel.portraitUri substringFromIndex:6]];
    }
    else
    {
        if(0 == [dataModel.name length])
        {
            self.leftImageView.image = [UIImage imageNamed:@"default_user_image"];
        }
        else
        {
            NSString *localUrl = [YBUtils defaultUserPortrait:[[RCUserInfo alloc] initWithUserId:dataModel.userId name:dataModel.name portrait:@""]];
            [self.leftImageView sd_setImageWithURL:[NSURL fileURLWithPath:localUrl] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    frame.size.width = YB_SCREEN_WIDTH;

    self.contentView.frame = frame;
}

@end
