//
//  YBUserDetailTopCell.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUserDetailTopCell.h"

@interface YBUserDetailTopCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end

@implementation YBUserDetailTopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBUserDetailTopCell" owner:nil options:nil][0];
        self.frame = frame;
        
        self.leftImageView.layer.cornerRadius = 5.0;
        self.leftImageView.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.leftImageView.image = [UIImage imageNamed:@"mine_portail"];
    
    self.nameLabel.text = @"/相知、相惜/mg";
    self.userIdLabel.text = @"微信号：yibo3513";
    self.userNameLabel.text = @"昵称：/相知、相惜/mg";
}

@end
