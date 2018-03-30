//
//  YBUserDetailAlbumCell.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUserDetailAlbumCell.h"

@interface YBUserDetailAlbumCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forthImageView;

@end

@implementation YBUserDetailAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBUserDetailAlbumCell" owner:nil options:nil][0];
        self.frame = frame;
        
//        self.firstImageView.hidden = YES;
//        self.secondImageView.hidden = YES;
//        self.thirdImageView.hidden = YES;
//        self.forthImageView.hidden = YES;
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.leftLabel.text = @"个人相册";
    
    self.firstImageView.image = [UIImage imageNamed:@"album1"];
    self.secondImageView.image = [UIImage imageNamed:@"album2"];
    self.thirdImageView.image = [UIImage imageNamed:@"album3"];
    self.forthImageView.image = [UIImage imageNamed:@"album4"];
}

@end
