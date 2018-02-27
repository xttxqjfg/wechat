//
//  YBSearchView.m
//  YBWechat
//
//  Created by 易博 on 2018/2/12.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBSearchView.h"

@interface YBSearchView()
@property (weak, nonatomic) IBOutlet UIView *seachBackView;

@end

@implementation YBSearchView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)searchType
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBSearchView" owner:nil options:nil][searchType];
        self.frame = frame;
        
        self.seachBackView.layer.cornerRadius = 5.0;
        self.seachBackView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
        [self.seachBackView addGestureRecognizer:tap];
    }
    return self;
}

- (IBAction)voiceBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(voiceBtnTapped)]) {
        [self.delegate voiceBtnTapped];
    }
}

-(void)viewTapped
{
    if ([self.delegate respondsToSelector:@selector(searchViewTapped)]) {
        [self.delegate searchViewTapped];
    }
}

@end
