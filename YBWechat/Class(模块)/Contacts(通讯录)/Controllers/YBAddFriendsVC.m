//
//  YBAddFriendsVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBAddFriendsVC.h"

#import "YBAddFriensCell.h"
#import "YBAddFriendsTopView.h"

@interface YBAddFriendsVC ()<UITableViewDelegate,UITableViewDataSource,YBAddFriendsTopViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *addFriendTable;

@property (nonatomic,strong) YBAddFriendsTopView *addFriendsTopView;

@end

@implementation YBAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加朋友";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.addFriendTable];
}

#pragma mark YBAddFriendsTopViewDelegate
-(void)topViewActionWithType:(NSInteger)type
{
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBAddFriensCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBAddFriensCell"];
    if (!cell) {
        cell = [[YBAddFriensCell alloc]initWithFrame:CGRectZero];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dataDic = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * YB_WIDTH_PRO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90 * YB_WIDTH_PRO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.addFriendsTopView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)addFriendTable
{
    if (!_addFriendTable) {
        _addFriendTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _addFriendTable.delegate = self;
        _addFriendTable.dataSource = self;
        _addFriendTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _addFriendTable;
}

-(YBAddFriendsTopView *)addFriendsTopView
{
    if (!_addFriendsTopView) {
        _addFriendsTopView = [[YBAddFriendsTopView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 90 * YB_WIDTH_PRO)];
        _addFriendsTopView.delegate = self;
    }
    return _addFriendsTopView;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addFriendsData.plist" ofType:nil]];
    }
    return _dataArr;
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
