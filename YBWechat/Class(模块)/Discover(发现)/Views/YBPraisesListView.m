//
//  YBPraisesListView.m
//  YBWechat
//
//  Created by 易博 on 2018/6/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBPraisesListView.h"

@interface YBPraisesListView()

@property (nonatomic,strong) UIView *grayBackGroundView;

@property (nonatomic,strong) YYLabel *praiseListLabel;

@property (nonatomic,strong) UIImageView *lineImageView;

@end

@implementation YBPraisesListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.praiseListLabel];
        [self addSubview:self.lineImageView];
    }
    return self;
}

-(void)setModelList:(NSArray *)modelList
{
    _modelList = modelList;
    
    [self setNeedsLayout];
    if (modelList.count > 0) {
        [self setupLabel];
    }
}

-(void)setShowBottomLine:(BOOL)showBottomLine
{
    if (showBottomLine) {
        self.lineImageView.hidden = NO;
    }
    else
    {
        self.lineImageView.hidden = YES;
    }
}

-(void)setupLabel
{
    self.praiseListLabel.frame = CGRectMake(5, 10, self.bounds.size.width - 10, self.bounds.size.height - 15);
    self.lineImageView.frame = CGRectMake(0, CGRectGetMaxY(self.praiseListLabel.frame) + 2, self.bounds.size.width, 1);
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    text.yy_font = [UIFont boldSystemFontOfSize:15.0f];

    //记录位置用
    NSInteger location = 0;
    //逗号和空格，用于间隔
    NSMutableAttributedString *separateStr = [[NSMutableAttributedString alloc] initWithString:@", "];
    separateStr.yy_font = [UIFont boldSystemFontOfSize:15.0f];
    
    for (int i = 0; i < self.modelList.count; i++) {
        YBPraiseModel *model = (YBPraiseModel *)self.modelList[i];
        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:model.userName];
        tempStr.yy_font = [UIFont boldSystemFontOfSize:15.0f];
        tempStr.yy_color = YB_Global_LinkTextColor;
        [text appendAttributedString:tempStr];
        
        //如果不是最后一个，则在后面拼接逗号和空格
        if (i != self.modelList.count - 1) {
            [text appendAttributedString:separateStr];
        }
        
        [text yy_setTextHighlightRange:NSMakeRange(location, model.userName.length) color:YB_Global_LinkTextColor backgroundColor:[UIColor lightGrayColor] userInfo:@{@"userId":model.userId}];
        location = [text length];
    }
    
    NSMutableAttributedString *attachImage = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:[UIImage imageNamed:@"moment_praise_HL"] fontSize:15];
    [attachImage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    //插入到开头
    [text insertAttributedString:attachImage atIndex:0];
    
    self.praiseListLabel.attributedText = text;
}

-(void)drawRect:(CGRect)rect
{
    [self drawTriangle];
}

-(YYLabel *)praiseListLabel
{
    if (!_praiseListLabel) {
        _praiseListLabel = [[YYLabel alloc] init];
        _praiseListLabel.userInteractionEnabled = YES;
        _praiseListLabel.backgroundColor = [UIColor clearColor];
        _praiseListLabel.numberOfLines = 0;
        _praiseListLabel.textAlignment = NSTextAlignmentLeft;
        YBWeakSelf(self);
        _praiseListLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([containerView valueForKey:@"_highlight"] && [[containerView valueForKey:@"_highlight"] isKindOfClass:[YYTextHighlight class]]) {
                YYTextHighlight *textHighlight = (YYTextHighlight *)[containerView valueForKey:@"_highlight"];
                ;
                if ([weakself.delegate respondsToSelector:@selector(selectedUserWithId:)]) {
                    [weakself.delegate selectedUserWithId:[textHighlight.userInfo objectForKey:@"userId"]];
                }
            }
        };
        _praiseListLabel.displaysAsynchronously = YES;
    }
    return _praiseListLabel;
}

-(UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc]init];
        _lineImageView.image = [UIImage imageNamed:@"CommentHorizontalLine"];
    }
    return _lineImageView;
}

-(void)drawTriangle
{
    //顶点横纵坐标
    CGFloat pointX = 20;
    CGFloat pointY = 1;
    CGFloat heightY = 5;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, pointX, pointY);
    CGContextAddLineToPoint(ctx, pointX + 6, heightY);
    
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.frame), heightY);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    CGContextAddLineToPoint(ctx, 0, CGRectGetMaxY(self.frame));
    CGContextAddLineToPoint(ctx, 0, heightY);
    
    CGContextAddLineToPoint(ctx, pointX - 6, heightY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 243.0/255.0, 243.0/255.0, 245.0/255.0, 1.0);
    CGContextSetRGBFillColor(ctx, 243.0/255.0, 243.0/255.0, 245.0/255.0, 1.0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
