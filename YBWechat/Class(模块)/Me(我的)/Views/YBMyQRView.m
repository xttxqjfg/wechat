//
//  YBMyQRView.m
//  YBWechat
//
//  Created by 易博 on 2018/4/2.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMyQRView.h"

#import <CoreImage/CoreImage.h>

@interface YBMyQRView()
@property (weak, nonatomic) IBOutlet UIImageView *topUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *topUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topSexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrUserImageView;
@property (weak, nonatomic) IBOutlet UIView *myQRBackView;

@end

@implementation YBMyQRView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBMyQRView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.topUserImageView.layer.cornerRadius = 5.0;
        self.topUserImageView.layer.masksToBounds = YES;
        
        self.myQRBackView.layer.cornerRadius = 5.0;
        self.myQRBackView.layer.masksToBounds = YES;
        
        self.qrUserImageView.layer.cornerRadius = 5.0;
        self.qrUserImageView.layer.masksToBounds = YES;
        self.qrUserImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.qrUserImageView.layer.borderWidth = 3.0;
    }
    return self;
}

-(void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    
    if ([userInfo objectForKey:@"userPortrait"] && [[userInfo objectForKey:@"userPortrait"] hasPrefix:@"http"]) {
        [self.topUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userPortrait"]]] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
        [self.qrUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userPortrait"]]] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
    }
    else
    {
        self.topUserImageView.image = [UIImage imageNamed:@"default_user_image"];
        self.qrUserImageView.image = [UIImage imageNamed:@"default_user_image"];
    }
    
    self.topUserNameLabel.text = [userInfo objectForKey:@"userName"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userName"]] : @"";
    self.topLocationLabel.text = [userInfo objectForKey:@"userLocation"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userLocation"]] : @"";
    
    NSString *userId = [userInfo objectForKey:@"userId"] ? [NSString stringWithFormat:@"微信号:%@,昵称:%@",[userInfo objectForKey:@"userId"],[userInfo objectForKey:@"userName"]] : @"";
    self.qrImageView.image = [YBUtils qrImageWithStr:userId];
}

@end
