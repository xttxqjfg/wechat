//
//  YBMomentsVC.m
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsVC.h"

#import "YBActionSheetView.h"

#import "YBMomentsAddVC.h"

#import "MomentsDataModel.h"
#import "YBMomentsHeaderView.h"
#import "YBUserDetailVC.h"

#import "YBPicsBrowser.h"

@interface YBMomentsVC ()<YBActionSheetViewDelegate,UITableViewDelegate,UITableViewDataSource,YBMomentsHeaderViewDelegate>

@property (nonatomic,strong) YBActionSheetView *actionSheetView;

@property (nonatomic,strong) UITableView *momentsTableView;

@property (nonatomic,strong) NSMutableArray *momentsDataArr;

@property (nonatomic,strong) YBPicsBrowser *picsBrowser;

@end

@implementation YBMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"朋友圈";
    
    //增加右上角相机按钮的点击和长按事件
    [self setNaviBarBtns];
    
    [self.view addSubview:self.momentsTableView];
}

-(void)setNaviBarBtns
{
    UIImageView *caremaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    caremaView.image = [UIImage imageNamed:@"moment_bar_camera"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:caremaView];
    
    //点击事件
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cammeraBtnPressed:)];
    [caremaView addGestureRecognizer:imageTap];
    
    //长按事件
    UILongPressGestureRecognizer *imageLongTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cammeraBtnLongPressed:)];
    imageLongTap.minimumPressDuration = 1.0;
    [caremaView addGestureRecognizer:imageLongTap];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)cammeraBtnPressed:(UITapGestureRecognizer *)sender
{
    [self.view addSubview:self.actionSheetView];
    [self.actionSheetView showActionSheet];
}

-(void)cammeraBtnLongPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"cammeraBtnLongPressed");
        YBMomentsAddVC *addVC = [[YBMomentsAddVC alloc]init];
        [self presentViewController:addVC animated:YES completion:^{
            //
        }];
    }
}

#pragma mark YBMomentsHeaderViewDelegate
-(void)jumpToUserDetailOnHeaderView:(NSString *)userId
{
    YBUserInfo *userInfo = [[YBUserInfo alloc]initWithUserId:userId name:@"" portrait:@""];
    YBUserDetailVC *detailVC = [[YBUserDetailVC alloc]init];
    detailVC.userInfo = userInfo;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)jumpToPicBrowserOnHeaderView:(NSArray *)picArr index:(NSInteger)index
{
    self.picsBrowser.picArr = picArr;
    [self.picsBrowser showAtPage:index];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"momentCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.momentsDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MomentsDataModel *model = (MomentsDataModel *)[self.momentsDataArr objectAtIndex:section];
    return model.commendArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MomentsDataModel *model = (MomentsDataModel *)[self.momentsDataArr objectAtIndex:indexPath.section];
    return model.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MomentsDataModel *model = (MomentsDataModel *)[self.momentsDataArr objectAtIndex:section];
    return model.cellHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MomentsDataModel *model = (MomentsDataModel *)[self.momentsDataArr objectAtIndex:section];
    YBMomentsHeaderView *headView = [[YBMomentsHeaderView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, model.cellHeaderHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.headerViewData = model;
    headView.delegate = self;
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark YBActionSheetViewDelegate
-(void)selectedActionSheetViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        //
    }
    else if (1 == indexPath.row)
    {
        //
    }
    else
    {
        //
    }
}

#pragma mark 懒加载
-(YBActionSheetView *)actionSheetView
{
    if (!_actionSheetView) {
        _actionSheetView = [[YBActionSheetView alloc]initWithFrame:self.view.bounds];
        _actionSheetView.delegate = self;
        _actionSheetView.btnArr = @[@{@"title":@"拍摄",@"subTitle":@"照片或视频"},@{@"title":@"从手机相册选择"}];
    }
    return _actionSheetView;
}

-(UITableView *)momentsTableView
{
    if (!_momentsTableView) {
        _momentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, YB_SCREEN_WIDTH, YB_SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _momentsTableView.delegate = self;
        _momentsTableView.dataSource = self;
    }
    return _momentsTableView;
}

-(NSMutableArray *)momentsDataArr
{
    if (!_momentsDataArr) {
        _momentsDataArr = [[NSMutableArray alloc]init];
        NSArray *sourceArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"momentsDataList.plist" ofType:nil]];
        for (NSDictionary *dic in sourceArr) {
            MomentsDataModel *model = [[MomentsDataModel alloc] initModelWithDict:dic];
            [_momentsDataArr addObject:model];
        }
    }
    return _momentsDataArr;
}

-(YBPicsBrowser *)picsBrowser
{
    if (!_picsBrowser) {
        _picsBrowser = [[YBPicsBrowser alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, YB_SCREEN_HEIGHT)];
    }
    return _picsBrowser;
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
