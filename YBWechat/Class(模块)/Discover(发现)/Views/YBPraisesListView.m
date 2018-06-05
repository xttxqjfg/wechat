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

@end

@implementation YBPraisesListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self setNeedsLayout];
}

-(void)drawRect:(CGRect)rect
{
    [self drawTriangle];
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
