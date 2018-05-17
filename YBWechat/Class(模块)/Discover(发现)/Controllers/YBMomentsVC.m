//
//  YBMomentsVC.m
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsVC.h"

#import "YBActionSheetView.h"

@interface YBMomentsVC ()<YBActionSheetViewDelegate>

@property (nonatomic,strong) YBActionSheetView *actionSheetView;

@end

@implementation YBMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"朋友圈";
    
    //增加右上角相机按钮的点击和长按事件
    [self setNaviBarBtns];
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

-(YBActionSheetView *)actionSheetView
{
    if (!_actionSheetView) {
        _actionSheetView = [[YBActionSheetView alloc]initWithFrame:self.view.bounds];
        _actionSheetView.delegate = self;
        _actionSheetView.btnArr = @[@{@"title":@"拍摄",@"subTitle":@"照片或视频"},@{@"title":@"从手机相册选择"}];
    }
    return _actionSheetView;
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
