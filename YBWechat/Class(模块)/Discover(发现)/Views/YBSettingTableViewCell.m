//
//  YBSettingTableViewCell.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBSettingTableViewCell.h"

@interface YBSettingTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YBSettingTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBSettingTableViewCell" owner:nil options:nil][0];
    }
    return self;
}

-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.leftImageView.image = [dataDict objectForKey:@"image"] ? [UIImage imageNamed:[dataDict objectForKey:@"image"]] : [UIImage imageNamed:@"mine_set"];
    self.nameLabel.text = [dataDict objectForKey:@"title"] ? [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"title"]] : @"";
}

@end
