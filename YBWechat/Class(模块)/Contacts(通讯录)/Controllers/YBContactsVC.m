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

#import "YBSearchView.h"
#import "UITableViewIndex+YB.h"

#import "YBSearchVC.h"

#import "YBUserDetailVC.h"

#import "YBPublicServiceListVC.h"

@interface YBContactsVC ()<UITableViewDelegate,UITableViewDataSource,YBSearchViewDelegate>

@property (nonatomic,strong) UITableView *contactTable;

@property (nonatomic,strong) NSMutableArray *topDefaultData;

@property (nonatomic,strong) NSMutableDictionary *userListInfo;

@property (nonatomic,strong) NSMutableArray *groupKeys;

@property (nonatomic,assign) NSInteger userCount;

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
    
    [weakself sortAndUpdate:[[RCDBManager shareInstance] getAllUserInfo]];
    
    [YBContactsModel userListRequest:@{@"userid":Golble_User_Id} Block:^(NSArray *result, NSString *message) {
        
        if (message) {
            [YBUtils showMessageInView:@"请求出错" inView:weakself.view];
        }
        else
        {
            if ([result count] > 0) {
                [[RCDBManager shareInstance] insertAllUserToDB:[result mutableCopy]];
                [weakself sortAndUpdate:[[RCDBManager shareInstance] getAllUserInfo]];
            }
        }
    }];
}

-(void)sortAndUpdate:(NSArray *)friendList
{
    self.userCount = friendList.count;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDictionary *sortResult = [YBUtils sortedArrayWithPinYinDic:friendList];
        
        self.userListInfo = [sortResult objectForKey:@"infoDic"];
        self.groupKeys = [sortResult objectForKey:@"allKeys"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contactTable reloadData];
        });
    });
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
    [self jumpToSearchVC:1];
}

-(void)searchViewTapped
{
    [self jumpToSearchVC:0];
}

-(void)jumpToSearchVC:(NSInteger)type
{
    YBSearchVC *searchVC = [[YBSearchVC alloc]init];
    [self presentViewController:searchVC animated:YES completion:^{
        //
    }];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupKeys.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return self.topDefaultData.count;
    }
    else
    {
        NSString *letter = [self.groupKeys objectAtIndex:section - 1];
        return [self.userListInfo[letter] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBContactCell"];
    if (!cell) {
        cell = [[YBContactCell alloc]initWithFrame:CGRectZero];
    }
    if (0 == indexPath.section) {
        cell.dataModel = [self.topDefaultData objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *letter = [self.groupKeys objectAtIndex:indexPath.section - 1];
        NSArray *sectionUserInfoList = self.userListInfo[letter];
        cell.dataModel = sectionUserInfoList[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * YB_WIDTH_PRO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                
                break;
            }
            case 1:
            {
                
                break;
            }
            case 2:
            {
                
                break;
            }
            case 3:
            {
                YBPublicServiceListVC *publicServiceVC = [[YBPublicServiceListVC alloc] init];
                publicServiceVC.title = @"公众号";
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:publicServiceVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                break;
            }
            default:
                break;
        }
    }
    else
    {
        NSString *letter = [self.groupKeys objectAtIndex:indexPath.section - 1];
        NSArray *sectionUserInfoList = self.userListInfo[letter];
        
        YBUserDetailVC *detailVC = [[YBUserDetailVC alloc]init];
        detailVC.userInfo = sectionUserInfoList[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
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
    if (self.userListInfo.count == section) {
        return 45 * YB_WIDTH_PRO;
    }
    else
    {
        return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.searchView;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.frame = CGRectMake(13, 3, 15, 15);
        title.font = [UIFont systemFontOfSize:15.f];
        title.textColor = [UIColor grayColor];
        [view addSubview:title];
        title.text = self.groupKeys[section - 1];
        
        return view;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.userListInfo.count == section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.frame = CGRectMake(0, 10, self.view.frame.size.width, 30);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.frame = view.frame;
        title.font = [UIFont systemFontOfSize:18.f];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor grayColor];
        [view addSubview:title];
        title.text = [NSString stringWithFormat:@"%ld位联系人",self.userCount];
        
        return view;
    }
    else
    {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.groupKeys;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return  index;
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
        
        //设置右侧索引
        _contactTable.sectionIndexBackgroundColor = [UIColor clearColor];
        _contactTable.sectionIndexColor = [UIColor blackColor];
        _contactTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_contactTable addIndexTip];
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

-(NSMutableArray *)topDefaultData
{
    if (!_topDefaultData) {
        
        _topDefaultData = [[NSMutableArray alloc]init];
        NSArray *defaultArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contactDefaultList.plist" ofType:nil]];
        for (NSDictionary *dic in defaultArr) {
            YBUserInfo *userInfo = [[YBUserInfo alloc]init];
            userInfo.userId = [dic objectForKey:@"userId"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]] : @"";
            userInfo.name = [dic objectForKey:@"userName"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]] : @"";
            userInfo.portraitUri = [dic objectForKey:@"userPortrait"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"userPortrait"]] : @"";
            [_topDefaultData addObject:userInfo];
        }
    }
    return _topDefaultData;
}

-(NSMutableDictionary *)userListInfo
{
    if (!_userListInfo) {
        _userListInfo = [[NSMutableDictionary alloc]init];
    }
    return _userListInfo;
}

-(NSMutableArray *)groupKeys
{
    if (!_groupKeys) {
        _groupKeys = [[NSMutableArray alloc]init];
    }
    return _groupKeys;
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
