//
//  YBMyQRVC.m
//  YBWechat
//
//  Created by 易博 on 2018/4/7.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMyQRVC.h"

#import "YBMyQRView.h"

@interface YBMyQRVC ()

@property (nonatomic,strong) UIView *myQRView;

@end

@implementation YBMyQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.myQRView];
}

-(UIView *)myQRView
{
    if (!_myQRView) {
        _myQRView = [[UIView alloc]initWithFrame:self.view.bounds];
        _myQRView.backgroundColor = [UIColor clearColor];
        
        CGFloat qrViewW = YB_SCREEN_WIDTH - 40;
        CGFloat qrViewH = qrViewW * 1.4;;
        CGFloat qrViewY = (YB_SCREEN_HEIGHT - qrViewH) / 2;
        
        YBMyQRView *qrView = [[YBMyQRView alloc]initWithFrame:CGRectMake(20, qrViewY, qrViewW, qrViewH)];
        [_myQRView addSubview:qrView];
        qrView.userInfo = [YBUserCache unArchiverAccount].userInfoDict;
    }
    return _myQRView;
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
