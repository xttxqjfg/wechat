//
//  YBMineVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMineVC.h"

#import "YBSettingTableViewCell.h"
#import "YBMineHeadTableViewCell.h"

#import "YBLoginVC.h"

@interface YBMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mineTableview;

@property (nonatomic,strong) NSArray *mineDataArr;

@end

@implementation YBMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mineTableview];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mineDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        YBMineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBMineHeadTableViewCell"];
        if (!cell) {
            cell = [[YBMineHeadTableViewCell alloc]initWithFrame:CGRectZero];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else
    {
        YBSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBSettingTableViewCell"];
        if (!cell) {
            cell = [[YBSettingTableViewCell alloc]initWithFrame:CGRectZero];
        }
        cell.dataDict = [[self.mineDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 100;
    }
    else
    {
        return 45;
    }
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
    return [[self.mineDataArr objectAtIndex:section] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (3 == indexPath.section) {
        [YBUtils showAlert:@"确定注销当前登录?" title:@"提示" showInVC:self showCancleBtn:YES sureAction:^{
            //清理缓存后跳转到登录页面
            [YBUserCache clearUserInfo];
            //删除已经缓存的用户和群组数据
            [[RCDBManager shareInstance] clearUserData];
            [[RCDBManager shareInstance] clearGroupsData];
            [[RCDBManager shareInstance] clearGroupMembersData];
            
            //将消息提醒数量重置为0
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            //注销融云连接
            [[RCIM sharedRCIM] logout];
            
            YBLoginVC *loginVC = [[YBLoginVC alloc]init];
            UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            });
        }];
    }
}

#pragma mark -- get
-(UITableView *)mineTableview
{
    if (!_mineTableview) {
        _mineTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mineTableview.delegate = self;
        _mineTableview.dataSource = self;
        _mineTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _mineTableview;
}

-(NSArray *)mineDataArr
{
    if (!_mineDataArr) {
        _mineDataArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mineDataList.plist" ofType:nil]];
    }
    return _mineDataArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
