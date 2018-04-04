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

#import "YBSearchVC.h"

#import "YBMyQRView.h"

@interface YBAddFriendsVC ()<UITableViewDelegate,UITableViewDataSource,YBAddFriendsTopViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *addFriendTable;

@property (nonatomic,strong) YBAddFriendsTopView *addFriendsTopView;

@property (nonatomic,strong) UIView *myQRView;

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
//1表示点击了搜索框，2表示点击了二维码
-(void)topViewActionWithType:(NSInteger)type
{
    switch (type) {
        case 1:
        {
            YBSearchVC *searchVC = [[YBSearchVC alloc]init];
            [self presentViewController:searchVC animated:YES completion:^{
                //
            }];
            break;
        }
        case 2:
        {
            self.myQRView.userInteractionEnabled = YES;
            self.myQRView.hidden = NO;
            [self.view addSubview:self.myQRView];
            
            break;
        }
        default:
            break;
    }
}

-(void)myQRViewTapped
{
    self.myQRView.userInteractionEnabled = YES;
    self.myQRView.hidden = NO;
    [self.myQRView removeFromSuperview];
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

-(UIView *)myQRView
{
    if (!_myQRView) {
        _myQRView = [[UIView alloc]initWithFrame:self.view.bounds];
        _myQRView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5];
        _myQRView.hidden = YES;
        _myQRView.userInteractionEnabled = NO;
        
        CGFloat qrViewW = YB_SCREEN_WIDTH - 40;
        CGFloat qrViewH = qrViewW * 1.4;;
        CGFloat qrViewY = (YB_SCREEN_HEIGHT - qrViewH) / 2;
        
        YBMyQRView *qrView = [[YBMyQRView alloc]initWithFrame:CGRectMake(20, qrViewY, qrViewW, qrViewH)];
        [_myQRView addSubview:qrView];
        qrView.userInfo = [YBUserCache unArchiverAccount].userInfoDict;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myQRViewTapped)];
        [_myQRView addGestureRecognizer:tap];
    }
    return _myQRView;
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
