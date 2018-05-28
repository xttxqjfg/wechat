//
//  YBActionSheetView.m
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBActionSheetView.h"
#import "YBActionSheetCell.h"

@interface YBActionSheetView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *sheetTable;

@end

@implementation YBActionSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sheetTable];
        self.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideActionSheet)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

//解决手势和cell点击事件的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    else if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]){
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)showActionSheet
{
    CGFloat sheetH = 5.0 + (self.btnArr.count + 1) * 45 * YB_WIDTH_PRO;
    self.sheetTable.frame = CGRectMake(0, YB_SCREEN_HEIGHT, YB_SCREEN_WIDTH, sheetH);
    [self.sheetTable reloadData];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.sheetTable.frame = CGRectMake(0, YB_SCREEN_HEIGHT - sheetH, YB_SCREEN_WIDTH, sheetH);
                     }
                     completion:nil];
}

-(void)hideActionSheet
{
    CGFloat sheetH = 5.0 + (self.btnArr.count + 1) * 45 * YB_WIDTH_PRO;
    self.sheetTable.frame = CGRectMake(0, YB_SCREEN_HEIGHT, YB_SCREEN_WIDTH, sheetH);
    [self removeFromSuperview];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.btnArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBActionSheetCell"];
    if (!cell) {
        cell = [[YBActionSheetCell alloc]initWithFrame:CGRectZero];
    }
    if(1 == indexPath.section)
    {
        cell.dataDic = @{@"title":@"取消"};
    }
    else
    {
        cell.dataDic = [[NSDictionary alloc]initWithDictionary:[self.btnArr objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if ([self.delegate respondsToSelector:@selector(selectedActionSheetViewAtIndexPath:)]) {
            [self.delegate selectedActionSheetViewAtIndexPath:indexPath];
        }
    }
    [self hideActionSheet];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * YB_WIDTH_PRO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 5.0;
    }
    else
    {
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

-(UITableView *)sheetTable
{
    if (!_sheetTable) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height;
        
        _sheetTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _sheetTable.dataSource = self;
        _sheetTable.delegate = self;
        _sheetTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _sheetTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sheetTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _sheetTable.scrollEnabled = NO;
    }
    return _sheetTable;
}
@end
