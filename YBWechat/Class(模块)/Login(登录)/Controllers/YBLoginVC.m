//
//  YBLoginVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBLoginVC.h"

#import "YBInputTextView.h"
#import "YBButtonView.h"
#import "YBRegisterVC.h"
#import "YBInfoLabel.h"

#import "YBLoginModel.h"
#import "RootViewController.h"
#import "RSATool.h"

@interface YBLoginVC ()<YBButtonViewDelegate>

@property (nonatomic,strong) UIImageView     *logoImageView;
@property (nonatomic,strong) YBInputTextView *userIdInput;
@property (nonatomic,strong) YBInputTextView *userPswInput;
@property (nonatomic,strong) YBButtonView    *loginBtn;
@property (nonatomic,strong) YBInfoLabel     *markLabel;

@property (nonatomic,strong) UIButton *registerBtn;

@end

@implementation YBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.userIdInput];
    [self.view addSubview:self.userPswInput];
    [self.view addSubview:self.markLabel];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
}

#pragma mark YBButtonViewDelegate
-(void)btnViewClicked
{

    if (0 == [[self.userIdInput getInputTextStr] length] || 0 == [[self.userPswInput getInputTextStr] length]) {
        [YBUtils showMessageInView:@"账号、密码不能为空" inView:self.view];
        return;
    }
    
    NSDictionary *params = @{@"userid":[self.userIdInput getInputTextStr],
                             @"password":[RSATool encryptString:[self.userPswInput getInputTextStr] publicKey:RSA_Public_key]};
    
    YBWeakSelf(self);
    
    [YBUtils showActivityInView:weakself.view];
    [YBLoginModel loginRequest:params Block:^(NSDictionary *result, NSString *message) {
        [YBUtils hideActivityInView:weakself.view];
        if (message) {
            [YBUtils showMessageInView:@"请求出错" inView:weakself.view];
        }
        else
        {
            YBUserCache *info = [YBUserCache unArchiverAccount];
            if (!info) {
                info = [[YBUserCache alloc]init];
            }
            info.userInfoDict = result;
            [info archiverAccount];
            
            if ([Golble_User_Token length] > 0) {
                //初始化融云
                [YBLoginModel initRongYun];
                
                [[RCIM sharedRCIM] connectWithToken:Golble_User_Token success:^(NSString *userId) {
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    
                    //与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送
                    RCUserInfo *_currentUserInfo =
                    [[RCUserInfo alloc] initWithUserId:Golble_User_Id
                                                  name:Golble_User_Name
                                              portrait:@""];
                    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].keyWindow.rootViewController = [[RootViewController alloc]init];
                    });
                    
                } error:^(RCConnectErrorCode status) {
                    
                    NSLog(@"登陆的错误码为:%ld", (long)status);
                    [YBUtils showErrorInView:[NSString stringWithFormat:@"登录失败,错误码为:%ld", (long)status] inView:weakself.view];
                    
                } tokenIncorrect:^{
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    NSLog(@"token错误");
                    [YBUtils showErrorInView:@"登录失败,错误码为0000" inView:weakself.view];
                }];
            }
            else
            {
                [YBUtils showErrorInView:@"您还没有注册,请先注册账号" inView:weakself.view];
            }
        }
    }];
}

//注册按钮点击触发事件
-(void)registerBtnClicked
{
    YBRegisterVC *registerVC = [[YBRegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

-(void)viewTapped
{
    [self.view endEditing:YES];
}

#pragma mark --get
-(UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((YB_SCREEN_WIDTH - 80) / 2, 120, 80, 80)];
        _logoImageView.image = [UIImage imageNamed:@"logo"];
        
        _logoImageView.layer.cornerRadius = 5.0;
        _logoImageView.layer.masksToBounds = YES;
    }
    return _logoImageView;
}

-(YBInputTextView *)userIdInput
{
    if (!_userIdInput) {
        _userIdInput = [[YBInputTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame) + 50, YB_SCREEN_WIDTH, 50)];
        _userIdInput.dataDict = @{@"name":@"账号",@"placeholder":@"请填写账号"};
    }
    return _userIdInput;
}

-(YBInputTextView *)userPswInput
{
    if (!_userPswInput) {
        _userPswInput = [[YBInputTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userIdInput.frame), YB_SCREEN_WIDTH, 50)];
        _userPswInput.dataDict = @{@"name":@"密码",@"placeholder":@"请填写密码"};
        _userPswInput.isSecure = YES;
    }
    return _userPswInput;
}

-(YBInfoLabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[YBInfoLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userPswInput.frame) + 20, YB_SCREEN_WIDTH - 50, 30)];
        _markLabel.leftImageView.image = [UIImage imageNamed:@"grayMark"];
        _markLabel.rightLabel.text = @"登录不验证密码的正确性";
    }
    return _markLabel;
}

-(YBButtonView *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[YBButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.markLabel.frame) + 100, YB_SCREEN_WIDTH - 60, 50)];
        _loginBtn.dataDic = @{@"title":@"登 录"};
        _loginBtn.delegate = self;
    }
    return _loginBtn;
}

-(UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, YB_SCREEN_HEIGHT - 60, YB_SCREEN_WIDTH, 40)];
        _registerBtn.backgroundColor = [UIColor whiteColor];
        [_registerBtn setTitle:@"点击注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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
