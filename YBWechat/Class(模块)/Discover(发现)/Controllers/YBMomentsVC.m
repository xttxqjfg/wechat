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
#import "YBOperatePopView.h"

#import "YBCommendModel.h"
#import "YBMomentsCommendCell.h"

@interface YBMomentsVC ()<YBActionSheetViewDelegate,UITableViewDelegate,UITableViewDataSource,YBMomentsHeaderViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,YBMomentsCommendCellDelegate>

@property (nonatomic,strong) YBActionSheetView *actionSheetView;

@property (nonatomic,strong) UITableView *momentsTableView;

@property (nonatomic,strong) NSMutableArray *momentsDataArr;

@property (nonatomic,strong) YBPicsBrowser *picsBrowser;
//点赞和评论的弹出视图
@property (nonatomic,strong) YBOperatePopView *operatePopView;

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
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewBackGroundTapped:)];
    viewTap.delegate = self;
    [self.view addGestureRecognizer:viewTap];
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

-(void)viewBackGroundTapped:(UITapGestureRecognizer *)sender
{
    [self hideOperatePopViewAnimate];
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

#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //解决点赞区点击事件被拦截的问题
    if([touch.view isKindOfClass:[YYLabel class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark YBMomentsCommendCellDelegate
-(void)selectedUserWithIdOnCommendCell:(NSString *)userId
{
    NSLog(@"selectedUserWithIdOnCommendCell:%@",userId);
    [self jumpToUserDetailOnHeaderView:userId];
}

#pragma mark YBMomentsHeaderViewDelegate
-(void)jumpToUserDetailOnHeaderView:(NSString *)userId
{
    [self hideOperatePopViewAnimate];
    
    YBUserInfo *userInfo = [[YBUserInfo alloc]initWithUserId:userId name:@"" portrait:@""];
    YBUserDetailVC *detailVC = [[YBUserDetailVC alloc]init];
    detailVC.userInfo = userInfo;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)jumpToPicBrowserOnHeaderView:(NSArray *)picArr index:(NSInteger)index
{
    [self hideOperatePopViewAnimate];
    
    self.picsBrowser.picArr = picArr;
    [self.picsBrowser showAtPage:index];
}

//点赞或者评论按钮点击事件
-(void)operateMoreTappedOnHeaderView:(MomentsDataModel *)model point:(CGPoint)point
{
    NSLog(@"触发点坐标->:x->%f,y->%f",point.x,point.y);
    if (self.operatePopView.hidden) {
        self.operatePopView.frame = CGRectMake(point.x - 5, point.y - 5, 0, 35);
        [self showOperatePopViewAnimate];
    }
    else
    {
        [self hideOperatePopViewAnimate];
    }
}

//动画展示
-(void)showOperatePopViewAnimate
{
    self.operatePopView.hidden = NO;
    CGRect frame = self.operatePopView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.operatePopView.frame = CGRectMake(frame.origin.x - 200, frame.origin.y, 200, frame.size.height);
    } completion:^(BOOL finished) {
        //
    }];
}

//动画关闭
-(void)hideOperatePopViewAnimate
{
    if (self.operatePopView.hidden) {
        return;
    }
    
    CGRect frame = self.operatePopView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.operatePopView.frame = CGRectMake(frame.origin.x + 200, frame.origin.y, 0, frame.size.height);
    } completion:^(BOOL finished) {
        self.operatePopView.hidden = YES;
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideOperatePopViewAnimate];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBMomentsCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBMomentsCommendCell"];
    if (!cell) {
        cell = [[YBMomentsCommendCell alloc]initWithFrame:CGRectZero];
    }
    cell.delegate = self;
    MomentsDataModel *model = (MomentsDataModel *)[self.momentsDataArr objectAtIndex:indexPath.section];
    YBCommendModel *commendModel = (YBCommendModel *)[model.commendArr objectAtIndex:indexPath.row];
    cell.commendModel = commendModel;
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
    YBCommendModel *commendModel = (YBCommendModel *)[model.commendArr objectAtIndex:indexPath.row];
    return commendModel.cellHeight;
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
    headView.userInteractionEnabled = YES;
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 9, YB_SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    [footView addSubview:lineLabel];
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    
    YBMomentsCommendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell setCommendSelectedAnimation];
    }
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
        _momentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(YBOperatePopView *)operatePopView
{
    if (!_operatePopView) {
        _operatePopView = [[YBOperatePopView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_operatePopView];
        _operatePopView.hidden = YES;
    }
    return _operatePopView;
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
