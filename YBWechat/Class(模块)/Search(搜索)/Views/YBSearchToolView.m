//
//  YBSearchToolView.m
//  YBWechat
//
//  Created by 易博 on 2018/3/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBSearchToolView.h"

@interface YBSearchToolView()
@property (weak, nonatomic) IBOutlet UITextField *searchContentTextField;
@property (weak, nonatomic) IBOutlet UIView *searchBackgroundView;
@end

@implementation YBSearchToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBSearchToolView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.searchBackgroundView.layer.cornerRadius = 5.0;
        self.searchBackgroundView.layer.masksToBounds = YES;
        
        self.searchContentTextField.tintColor = YB_Tabbar_TintColorSel;
    }
    return self;
}

- (IBAction)onVoiceBtnClicked:(UIButton *)sender {
}

- (IBAction)onCancleBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchCancleBtnClicked)]) {
        [self.delegate searchCancleBtnClicked];
    }
}

@end
