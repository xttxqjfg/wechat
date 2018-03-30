//
//  YBUserDetailVC.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUserDetailVC.h"

#import "YBUserDetailTopCell.h"
#import "YBUserDetailAlbumCell.h"

#import "YBButtonView.h"

@interface YBUserDetailVC ()<UITableViewDelegate,UITableViewDataSource,YBButtonViewDelegate>

@property (nonatomic,strong) UITableView *detailTable;

@property (nonatomic,strong) YBButtonView *messageBtn;
@property (nonatomic,strong) YBButtonView *mediaBtn;

@end

@implementation YBUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *detailMore = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barbtn_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = detailMore;
    
    [self.view addSubview:self.detailTable];
}

-(void)rightBarButtonClicked
{
    
}

#pragma mark YBButtonViewDelegate
-(void)btnViewClickedWithTag:(NSInteger)tag
{
    switch (tag)
    {
        case 1000:
        {
            //系统导航栏自带的返回按钮
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            
            YBConversationVC *chatVC = [[YBConversationVC alloc]init];
            chatVC.conversationType = ConversationType_PRIVATE;
            chatVC.title = self.userInfo.name;
            chatVC.targetId = self.userInfo.userId;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
            break;
        }
            
        case 2000:
        {
            [[RCCall sharedRCCall] startSingleCall:self.userInfo.userId mediaType:RCCallMediaAudio];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        YBUserDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBUserDetailTopCell"];
        if (!cell) {
            cell = [[YBUserDetailTopCell alloc]initWithFrame:CGRectZero];
        }
        cell.dataDic = @{};
        return cell;
    }
    else if (1 == indexPath.section)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultUITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"设置备注和标签";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        return cell;
    }
    else
    {
        if(0 == indexPath.row)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultUITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
            }
            cell.textLabel.text = @"地区      北京 海淀";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            return cell;
        }
        else if (1 == indexPath.row)
        {
            YBUserDetailAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBUserDetailAlbumCell"];
            if (!cell) {
                cell = [[YBUserDetailAlbumCell alloc]initWithFrame:CGRectZero];
            }
            cell.dataDic = @{};
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultUITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"更多";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(2 == section)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section || (2 == indexPath.section && 1 == indexPath.row))
    {
        return 70 * YB_WIDTH_PRO;
    }
    else
    {
        return 35 * YB_WIDTH_PRO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        return 200;
    }
    else
    {
        return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 200)];
        footView.backgroundColor = [UIColor clearColor];
        
        self.messageBtn.frame = CGRectMake(20, 20, YB_SCREEN_WIDTH - 40, 45);
        self.mediaBtn.frame = CGRectMake(20, CGRectGetMaxY(self.messageBtn.frame) + 15, YB_SCREEN_WIDTH - 40, 45);
        
        [footView addSubview:self.messageBtn];
        [footView addSubview:self.mediaBtn];
        
        return footView;
    }
    else
    {
        return [[UIView alloc]initWithFrame:CGRectZero];;
    }
}

-(UITableView *)detailTable
{
    if (!_detailTable) {
        _detailTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _detailTable.delegate = self;
        _detailTable.dataSource = self;
        _detailTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _detailTable;
}

-(YBButtonView *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn = [[YBButtonView alloc]initWithFrame:CGRectZero];
        _messageBtn.btnLabel.text = @"发消息";
        _messageBtn.btnLabel.font = [UIFont systemFontOfSize:18.0];
        _messageBtn.tag = 1000;
        _messageBtn.btnBackView.backgroundColor = YB_Tabbar_TintColorSel;
        _messageBtn.delegate = self;
    }
    return _messageBtn;
}

-(YBButtonView *)mediaBtn
{
    if (!_mediaBtn) {
        _mediaBtn = [[YBButtonView alloc]initWithFrame:CGRectZero];
        _mediaBtn.btnLabel.text = @"视频通话";
        _mediaBtn.btnLabel.font = [UIFont systemFontOfSize:18.0];
        _mediaBtn.tag = 2000;
        _mediaBtn.btnLabel.textColor = [UIColor blackColor];
        _mediaBtn.btnBackView.backgroundColor = [UIColor whiteColor];
        _mediaBtn.delegate = self;
    }
    return _mediaBtn;
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
