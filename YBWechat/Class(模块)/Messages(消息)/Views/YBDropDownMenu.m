//
//  YBDropDownMenu.m
//  YBWechat
//
//  Created by 易博 on 2018/2/27.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBDropDownMenu.h"

#import "YBDropDownMenuCell.h"


@interface YBDropDownMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *dropDownTable;

@end


@implementation YBDropDownMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dropDownTable];
    }
    return self;
}

-(void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self.dropDownTable reloadData];
}

-(void)drawRect:(CGRect)rect
{
    [self drawTriangle];
}

-(void)drawTriangle
{
    //顶点横纵坐标
    CGFloat pointX = CGRectGetMaxX(self.bounds) - 25;
    CGFloat pointY = 1;
    CGFloat heightY = CGRectGetMinY(self.dropDownTable.frame);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, pointX, pointY);
    CGContextAddLineToPoint(ctx, pointX + 5.78, heightY);
    
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.dropDownTable.frame), heightY);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.dropDownTable.frame), CGRectGetMaxY(self.dropDownTable.frame));
    CGContextAddLineToPoint(ctx, 0, CGRectGetMaxY(self.dropDownTable.frame));
    CGContextAddLineToPoint(ctx, 0, heightY);
    
    CGContextAddLineToPoint(ctx, pointX - 5.78, heightY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 36.0/255.0, 38.0/255.0, 47.0/255.0, 0.8);
    CGContextSetRGBFillColor(ctx, 36.0/255.0, 38.0/255.0, 47.0/255.0, 0.9);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)setTriangleType:(NSInteger)triangleType
{
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(selectedMenuAtIndex:)]) {
        [self.delegate selectedMenuAtIndex:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35 * YB_WIDTH_PRO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBDropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBDropDownMenuCell"];
    if (!cell) {
        cell = [[YBDropDownMenuCell alloc]initWithFrame:CGRectZero];
    }
    cell.dataDic = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

-(UITableView *)dropDownTable
{
    if (!_dropDownTable) {
        
        CGRect rect = self.bounds;
        rect.size.height = rect.size.height - 10;
        rect.origin.y = rect.origin.y + 10;
        
        _dropDownTable = [[UITableView alloc]initWithFrame:rect];
        _dropDownTable.delegate = self;
        _dropDownTable.dataSource = self;
//        _dropDownTable.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:38.0/255.0 blue:47.0/255.0 alpha:0.9];
        _dropDownTable.backgroundColor = [UIColor clearColor];
        _dropDownTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dropDownTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _dropDownTable.scrollEnabled = NO;
    }
    return _dropDownTable;
}

@end
