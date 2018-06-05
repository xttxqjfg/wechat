//
//  YBMomentsCommendCell.m
//  YBWechat
//
//  Created by 易博 on 2018/6/5.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsCommendCell.h"

#define cell_commend_color [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:245.0/255.0 alpha:1.0]

@interface YBMomentsCommendCell()

@property (nonatomic,strong) YYLabel *commendLabel;

@property (nonatomic,strong) UIView *backView;

@end

@implementation YBMomentsCommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"YBMomentsCommendCell"];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = cell_commend_color;
    [self addSubview:_backView];
    
    _commendLabel = [[YYLabel alloc]init];
    _commendLabel.numberOfLines = 0;
    _commendLabel.textAlignment = NSTextAlignmentLeft;
    _commendLabel.displaysAsynchronously = YES;
            YBWeakSelf(self);
    _commendLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([containerView valueForKey:@"_highlight"] && [[containerView valueForKey:@"_highlight"] isKindOfClass:[YYTextHighlight class]]) {
            YYTextHighlight *textHighlight = (YYTextHighlight *)[containerView valueForKey:@"_highlight"];
                if ([weakself.delegate respondsToSelector:@selector(selectedUserWithIdOnCommendCell:)]) {
                    [weakself.delegate selectedUserWithIdOnCommendCell:[textHighlight.userInfo objectForKey:@"userId"]];
                }
        }
    };
    [_backView addSubview:_commendLabel];
}

-(void)setCommendModel:(YBCommendModel *)commendModel
{
    _commendModel = commendModel;
    
    _backView.frame = CGRectMake(80, 0, YB_SCREEN_WIDTH - 80 - 20, commendModel.cellHeight);
    _commendLabel.frame = CGRectMake(5, 0, CGRectGetWidth(_backView.bounds) - 10, commendModel.cellHeight);
    
    NSMutableAttributedString *commendText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",commendModel.content]];
    commendText.yy_font = [UIFont systemFontOfSize:15.0f];
    commendText.yy_lineSpacing = 5;
    
    if ([commendModel.secondUserId length] > 0) {
        //说明回复格式
        NSMutableAttributedString *firstUser = [[NSMutableAttributedString alloc] initWithString:commendModel.firstUserName];
        firstUser.yy_font = [UIFont boldSystemFontOfSize:15];
        firstUser.yy_lineSpacing = 5;
        [firstUser yy_setTextHighlightRange:NSMakeRange(0, commendModel.firstUserName.length) color:YB_Global_LinkTextColor backgroundColor:[UIColor lightGrayColor] userInfo:@{@"userId":commendModel.firstUserId}];
        
        NSMutableAttributedString *middleText = [[NSMutableAttributedString alloc] initWithString:@"回复"];
        middleText.yy_font = [UIFont systemFontOfSize:15];
        middleText.yy_lineSpacing = 5;
        
        NSMutableAttributedString *secondUser = [[NSMutableAttributedString alloc] initWithString:commendModel.secondUserName];
        secondUser.yy_font = [UIFont boldSystemFontOfSize:15];
        secondUser.yy_lineSpacing = 5;
        [secondUser yy_setTextHighlightRange:NSMakeRange(0, commendModel.secondUserName.length) color:YB_Global_LinkTextColor backgroundColor:[UIColor lightGrayColor] userInfo:@{@"userId":commendModel.secondUserId}];

        //插入最前面
        [commendText insertAttributedString:secondUser atIndex:0];
        [commendText insertAttributedString:middleText atIndex:0];
        [commendText insertAttributedString:firstUser atIndex:0];
    }
    else
    {
        //否则是评论格式
        NSMutableAttributedString *pinglun = [[NSMutableAttributedString alloc] initWithString:commendModel.firstUserName];
        pinglun.yy_font = [UIFont boldSystemFontOfSize:15];
        pinglun.yy_lineSpacing = 5;
        [pinglun yy_setTextHighlightRange:NSMakeRange(0, commendModel.firstUserName.length) color:YB_Global_LinkTextColor backgroundColor:[UIColor lightGrayColor] userInfo:@{@"userId":commendModel.firstUserId}];
        //插入最前面
        [commendText insertAttributedString:pinglun atIndex:0];
    }
    
    self.commendLabel.attributedText = commendText;
}

-(void)setCommendSelectedAnimation
{
    self.backView.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:210.0/255.0 blue:221.0/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.backgroundColor = cell_commend_color;
    }];
}

@end
