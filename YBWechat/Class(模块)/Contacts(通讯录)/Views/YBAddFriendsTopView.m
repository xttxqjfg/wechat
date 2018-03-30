//
//  YBAddFriendsTopView.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBAddFriendsTopView.h"

@interface YBAddFriendsTopView()
@property (weak, nonatomic) IBOutlet UIView *searchActionView;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myQRImageView;
@end

@implementation YBAddFriendsTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBAddFriendsTopView" owner:nil options:nil][0];
        self.frame = frame;
        
        NSDictionary *userInfo = [YBUserCache unArchiverAccount].userInfoDict;
        
        self.userInfoLabel.text = [NSString stringWithFormat:@"我的微信号:%@",[userInfo objectForKey:@"userId"]];
        
        UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchViewClicked)];
        [self.searchActionView addGestureRecognizer:searchTap];
        
        UITapGestureRecognizer *qrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myQRClicked)];
        [self.myQRImageView addGestureRecognizer:qrTap];
    }
    return self;
}

-(void)searchViewClicked
{
    if ([self.delegate respondsToSelector:@selector(topViewActionWithType:)]) {
        [self.delegate topViewActionWithType:1];
    }
}

-(void)myQRClicked
{
    if ([self.delegate respondsToSelector:@selector(topViewActionWithType:)]) {
        [self.delegate topViewActionWithType:2];
    }
}

@end
