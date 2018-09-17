//
//  YBAlbumTextMediaCell.m
//  YBWechat
//
//  Created by 易博 on 2018/6/15.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBAlbumTextMediaCell.h"

@interface YBAlbumTextMediaCell()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *picArrView;
@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoMarkImageView;

@end

@implementation YBAlbumTextMediaCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBAlbumTextMediaCell" owner:nil options:nil][0];
        self.frame = frame;
        
        self.videoMarkImageView.hidden = YES;
    }
    return self;
}

-(void)setModel:(AlbumCellModel *)model
{
    _model = model;
    
    self.monthLabel.text = _model.month;
    self.dayLabel.text = _model.day;
    self.contentLabel.text = _model.content;
    self.picCountLabel.text = _model.picArr.count > 0 ? [NSString stringWithFormat:@"共%lu张",(unsigned long)_model.picArr.count] : @"";
    
    if([_model.type isEqualToString:@"3"])
    {
        self.videoMarkImageView.hidden = NO;
    }
    else
    {
        self.videoMarkImageView.hidden = YES;
    }
}

@end
