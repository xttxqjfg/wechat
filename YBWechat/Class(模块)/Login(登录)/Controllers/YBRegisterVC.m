//
//  YBRegisterVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBRegisterVC.h"
#import "YBInputTextView.h"
#import "YBButtonView.h"

#import "YBLoginModel.h"
#import "RootViewController.h"
#import "RSATool.h"

@interface YBRegisterVC ()<YBButtonViewDelegate>

@property (nonatomic,strong) UIImageView     *logoImageView;
@property (nonatomic,strong) YBInputTextView *userIdInput;
@property (nonatomic,strong) YBInputTextView *userNameInput;
@property (nonatomic,strong) YBInputTextView *userPswInput;
@property (nonatomic,strong) YBButtonView    *registerBtn;

@end

@implementation YBRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.userIdInput];
    [self.view addSubview:self.userNameInput];
    [self.view addSubview:self.userPswInput];
    [self.view addSubview:self.registerBtn];
}

#pragma mark YBButtonViewDelegate
-(void)btnViewClickedWithTag:(NSInteger)tag
{
    
    if (![YBUtils validateStrByRegExp:[self.userIdInput getInputTextStr] regStr:REG_USERID]) {
        [YBUtils showMessageInView:@"账号至少6位,字母开头\n且包含字母、数字、下划线和减号" inView:self.view];
        return;
    }
    
    if (0 == [[self.userNameInput getInputTextStr] length] || 0 == [[self.userPswInput getInputTextStr] length]) {
        [YBUtils showMessageInView:@"昵称、密码不能为空" inView:self.view];
        return;
    }
    
    NSDictionary *params = @{@"userid":[self.userIdInput getInputTextStr],
                             @"username":[YBUtils urlEncode:[self.userNameInput getInputTextStr]],
                             @"password":[RSATool encryptString:[self.userPswInput getInputTextStr] publicKey:RSA_Public_key]};
    
    YBWeakSelf(self);
    
    [YBUtils showActivityInView:weakself.view];
    [YBLoginModel registerRequest:params Block:^(NSDictionary *result, NSString *message) {
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
            
            YBUserInfo *userInfo = [[YBUserInfo alloc]init];
            userInfo.userId = [result objectForKey:@"userId"] ? [result objectForKey:@"userId"] : @"";
            userInfo.name = [result objectForKey:@"userName"] ? [result objectForKey:@"userName"] : @"";
            userInfo.portraitUri = [result objectForKey:@"userPortrait"] ? [result objectForKey:@"userPortrait"] : @"";
            
            [[RCDBManager shareInstance] insertUserToDB:userInfo];
            
            if ([Golble_User_Token length] > 0) {
                //初始化融云
                [YBLoginModel initRongYun];
                
                [[RCIM sharedRCIM] connectWithToken:Golble_User_Token success:^(NSString *userId) {
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    
                    //与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送
                    RCUserInfo *_currentUserInfo = [[RCDBManager shareInstance] getUserByUserId:Golble_User_Id];
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
                [YBUtils showErrorInView:@"注册失败,请稍后再试" inView:weakself.view];
            }
        }
    }];
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

-(YBInputTextView *)userNameInput
{
    if (!_userNameInput) {
        _userNameInput = [[YBInputTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userIdInput.frame), YB_SCREEN_WIDTH, 50)];
        _userNameInput.dataDict = @{@"name":@"昵称",@"placeholder":@"请填写昵称"};
    }
    return _userNameInput;
}

-(YBInputTextView *)userPswInput
{
    if (!_userPswInput) {
        _userPswInput = [[YBInputTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameInput.frame), YB_SCREEN_WIDTH, 50)];
        _userPswInput.dataDict = @{@"name":@"密码",@"placeholder":@"请填写密码"};
        _userPswInput.isSecure = YES;
    }
    return _userPswInput;
}

-(YBButtonView *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[YBButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.userPswInput.frame) + 100, YB_SCREEN_WIDTH - 60, 50)];
        _registerBtn.btnLabel.text = @"注 册";
        _registerBtn.btnBackView.backgroundColor = YB_Tabbar_TintColorSel;
        _registerBtn.delegate = self;
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
