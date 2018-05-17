//
//  YBDiscoverVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBDiscoverVC.h"

#import "YBSettingTableViewCell.h"

#import "YBMomentsVC.h"

@interface YBDiscoverVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *discoverTableview;

@property (nonatomic,strong) NSArray *discoverDataArr;

@end

@implementation YBDiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.discoverTableview];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.discoverDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBSettingTableViewCell"];
    if (!cell) {
        cell = [[YBSettingTableViewCell alloc]initWithFrame:CGRectZero];
    }
    cell.dataDict = [[self.discoverDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.discoverDataArr objectAtIndex:section] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section && 0 == indexPath.row) {
        //朋友圈
        YBMomentsVC *momentsVC = [[YBMomentsVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:momentsVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark -- get
-(UITableView *)discoverTableview
{
    if (!_discoverTableview) {
        _discoverTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _discoverTableview.delegate = self;
        _discoverTableview.dataSource = self;
        _discoverTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _discoverTableview;
}

-(NSArray *)discoverDataArr
{
    if (!_discoverDataArr) {
        _discoverDataArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"discoverDataList.plist" ofType:nil]];
    }
    return _discoverDataArr;
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
