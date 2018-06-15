//
//  YBMomentHeaderView.m
//  YBWechat
//
//  Created by 易博 on 2018/6/14.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentHeaderView.h"

@interface YBMomentHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *topBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userPicImageView;
@property (weak, nonatomic) IBOutlet UIView *userPicBackView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@end

@implementation YBMomentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBMomentHeaderView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.userPicBackView.layer.borderWidth = 0.5;
        self.userPicBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

-(void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo = dataInfo;
    
    self.signatureLabel.text = @"Stay hungry,Stay foolish!";
}


@end
