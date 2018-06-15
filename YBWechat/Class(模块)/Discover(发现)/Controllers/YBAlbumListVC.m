//
//  YBAlbumListVC.m
//  YBWechat
//
//  Created by 易博 on 2018/6/14.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBAlbumListVC.h"

#import "YBMomentHeaderView.h"

#import "AlbumCellModel.h"

@interface YBAlbumListVC ()<UITableViewDelegate,UITableViewDataSource,YBMomentHeaderViewDelegate>

@property (nonatomic,strong) UITableView *albumTableView;

@property (nonatomic,strong) NSMutableArray *albumDataArr;

//顶部视图
@property (nonatomic,strong) YBMomentHeaderView *albumHeaderView;

@end

@implementation YBAlbumListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.albumTableView];
    [self.albumTableView addSubview:self.albumHeaderView];
}

#pragma mark--YBMomentHeaderViewDelegate
-(void)userPicClickedOnYBMomentHeaderView:(NSString *)userId
{
    
}

- (void)topImageClickedOnYBMomentHeaderView
{
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld",(long)indexPath.row);
}

#pragma mark 懒加载
-(UITableView *)albumTableView
{
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, YB_SCREEN_WIDTH, YB_SCREEN_HEIGHT + 64) style:(UITableViewStyleGrouped)];
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _albumTableView.contentInset = UIEdgeInsetsMake(YB_SCREEN_WIDTH * 0.8, 0, 0, 0);
    }
    return _albumTableView;
}

-(NSMutableArray *)albumDataArr
{
    if (!_albumDataArr) {
        _albumDataArr = [[NSMutableArray alloc]init];
        NSArray *sourceArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"albumDataList.plist" ofType:nil]];
        for (NSDictionary *dic in sourceArr) {
            AlbumCellModel *model = [[AlbumCellModel alloc] initModelWithDict:dic];
            [_albumDataArr addObject:model];
        }
    }
    return _albumDataArr;
}

-(YBMomentHeaderView *)albumHeaderView
{
    if (!_albumHeaderView) {
        _albumHeaderView = [[YBMomentHeaderView alloc]initWithFrame:CGRectMake(0, -YB_SCREEN_WIDTH * 0.8, YB_SCREEN_WIDTH, YB_SCREEN_WIDTH * 0.8)];
        _albumHeaderView.delegate = self;
        _albumHeaderView.dataInfo = @{};
    }
    return _albumHeaderView;
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
