//
//  YBContactsVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBContactsVC.h"

#import "YBAddFriendsVC.h"
#import "YBContactCell.h"
#import "YBContactsModel.h"
#import "ContactDateModel.h"

#import "YBSearchView.h"

@interface YBContactsVC ()<UITableViewDelegate,UITableViewDataSource,YBSearchViewDelegate>

@property (nonatomic,strong) UITableView *contactTable;

@property (nonatomic,strong) NSMutableArray *contactDataList;

@property (nonatomic,strong) YBSearchView *searchView;

@end

@implementation YBContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addFriends = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contacts_addfriend"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = addFriends;
    
    [self.view addSubview:self.contactTable];
    
    [self requestUserListData];
}

-(void)requestUserListData
{
    YBWeakSelf(self);
    
    [YBUtils showActivityInView:weakself.view];
    
    [YBContactsModel userListRequest:@{@"userid":Golble_User_Id} Block:^(NSArray *result, NSString *message) {
        [YBUtils hideActivityInView:weakself.view];
        if (message) {
            [YBUtils showMessageInView:@"请求出错" inView:weakself.view];
        }
        else
        {
            if ([result count] > 0) {
                [weakself.contactDataList addObject:result];
                [weakself.contactTable reloadData];
            }
        }
    }];
}

#pragma mark private method
-(void)rightBarButtonClicked
{
    YBAddFriendsVC *addFriendsVC = [[YBAddFriendsVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addFriendsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark --YBSearchViewDelegate
-(void)voiceBtnTapped
{
    
}

-(void)searchViewTapped
{
    
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contactDataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contactDataList objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBContactCell"];
    if (!cell) {
        cell = [[YBContactCell alloc]initWithFrame:CGRectZero];
    }
    cell.dataModel = [[self.contactDataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * YB_WIDTH_PRO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 45 * YB_WIDTH_PRO;
    }
    else
    {
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.contactDataList.count == section) {
//        return 45 * YB_WIDTH_PRO;
//    }
//    else
//    {
        return 0.1;
//    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.searchView;
    }
    else
    {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
}

#pragma mark --get
-(UITableView *)contactTable
{
    if (!_contactTable) {
        _contactTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _contactTable.dataSource = self;
        _contactTable.delegate = self;
        _contactTable.tableFooterView = [UIView new];
        _contactTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contactTable;
}

-(YBSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[YBSearchView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 45 * YB_WIDTH_PRO) type:0];
        _searchView.delegate = self;
    }
    return _searchView;
}

-(NSMutableArray *)contactDataList
{
    if (!_contactDataList) {
        
        _contactDataList = [[NSMutableArray alloc]init];
        NSArray *defaultArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contactDefaultList.plist" ofType:nil]];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in defaultArr) {
            [tempArr addObject:[ContactDateModel yy_modelWithDictionary:dic]];
        }
        [_contactDataList addObject:tempArr];
    }
    return _contactDataList;
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
