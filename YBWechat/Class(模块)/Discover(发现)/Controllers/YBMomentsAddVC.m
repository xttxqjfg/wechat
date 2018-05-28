//
//  YBMomentsAddVC.m
//  YBWechat
//
//  Created by 易博 on 2018/5/23.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsAddVC.h"

#import "YBMomentsAddCell.h"

@interface YBMomentsAddVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *contentTableView;

@property (nonatomic,strong) NSArray *tableListData;

@end

@implementation YBMomentsAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //增加导航栏的返回和发表按钮
    [self setNaviBarBtns];
    
    [self.view addSubview:self.contentTableView];
}

-(void)setNaviBarBtns
{
    UIView *topToolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 64)];
    topToolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topToolView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 60, 35)];
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancleBtn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    cancleBtn.tag = 10000;
    [topToolView addSubview:cancleBtn];
    
    UIButton *commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(YB_SCREEN_WIDTH - 10 - 60, 25, 60, 35)];
    [commitBtn setTitle:@"发表" forState:(UIControlStateNormal)];
    [commitBtn setTitleColor:YB_Tabbar_TintColorSel forState:(UIControlStateNormal)];
    [commitBtn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    commitBtn.tag = 20000;
    [topToolView addSubview:commitBtn];
}

-(void)naviBtnClicked:(UIButton *)sender
{
    if (10000 == sender.tag) {
        //取消
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    else if (20000 == sender.tag)
    {
        //发表
        
    }
    else
    {
        //
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBMomentsAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBMomentsAddCell"];
    if (!cell) {
        cell = [[YBMomentsAddCell alloc]initWithFrame:CGRectZero];
    }
    cell.dataDic = [self.tableListData objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- get
-(UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, YB_SCREEN_WIDTH, YB_SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = [UIColor whiteColor];
    }
    return _contentTableView;
}

-(NSArray *)tableListData
{
    if (!_tableListData) {
        _tableListData = @[@{@"image":@"moments_location",@"title":@"所在位置"},
                           @{@"image":@"moments_private",@"title":@"谁可以看"},
                           @{@"image":@"moment_metioned",@"title":@"提醒谁看"}];
    }
    return _tableListData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
