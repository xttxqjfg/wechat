//
//  YBSearchVC.m
//  YBWechat
//
//  Created by 易博 on 2018/3/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBSearchVC.h"

#import "YBSearchToolView.h"

@interface YBSearchVC ()<YBSearchToolViewDelegate>

@property (nonatomic,strong) YBSearchToolView *searchView;

@end

@implementation YBSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.searchView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark YBSearchToolViewDelegate
-(void)searchCancleBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(YBSearchToolView *)searchView
{
    if (!_searchView) {
        _searchView = [[YBSearchToolView alloc]initWithFrame:CGRectMake(0, 20, YB_SCREEN_WIDTH, 54)];
        _searchView.delegate = self;
    }
    return _searchView;
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
