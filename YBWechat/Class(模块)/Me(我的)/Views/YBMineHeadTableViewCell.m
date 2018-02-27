//
//  YBMineHeadTableViewCell.m
//  YBWechat
//
//  Created by 易博 on 2018/1/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMineHeadTableViewCell.h"

@interface YBMineHeadTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *myPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myNumberLabel;

@end

@implementation YBMineHeadTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBMineHeadTableViewCell" owner:nil options:nil][0];
        
        self.myPortraitImageView.layer.cornerRadius = 5.0;
        self.myPortraitImageView.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.myPortraitImageView.image = [dataDict objectForKey:@"image"] ? [UIImage imageNamed:[dataDict objectForKey:@"image"]] : [UIImage imageNamed:@"mine_portail"];
    self.myNameLabel.text = [dataDict objectForKey:@"name"] ? [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"name"]] : @"";
    self.myNumberLabel.text = [dataDict objectForKey:@"number"] ? [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"number"]] : @"";
}

@end
