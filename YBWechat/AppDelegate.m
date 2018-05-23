//
//  AppDelegate.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "YBLoginVC.h"
#import "YBLoginModel.h"

#import "YBMyQRVC.h"

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [self redirectNSlogToDocumentFolder];
    
    NSLog(@"==========  didFinishLaunchingWithOptions  ==========");
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    [self setupNavigationBar];

    //3D Touch
    [self addTouch:application];
    
    // 创建配置目录
    [NSFileManager createDir:DIR_PATH_FOR_CONFIG];
    
    if ([YBUserCache exists]) {
        
        if ([Golble_User_Token length] > 0) {
            
            //初始化融云
            [YBLoginModel initRongYun];
            
            //更新用户信息
            [self updateUserCache];
            
            [[RCIM sharedRCIM] connectWithToken:Golble_User_Token success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                
                //与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送
                RCUserInfo *_currentUserInfo = [[RCDBManager shareInstance] getUserByUserId:Golble_User_Id];
                [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
                
                [RCIM sharedRCIM].receiveMessageDelegate = self;
                [RCIM sharedRCIM].connectionStatusDelegate = self;
                //收到新消息的notification
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
                
            } error:^(RCConnectErrorCode status) {
                
                NSLog(@"登陆的错误码为:%ld", (long)status);
                [YBUserCache clearUserInfo];
                
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
                [YBUserCache clearUserInfo];
            }];
        }
        else
        {
            [YBUserCache clearUserInfo];
        }
        self.window.rootViewController = [[RootViewController alloc]init];
    }
    else
    {
        YBLoginVC *loginVC = [[YBLoginVC alloc]init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = rootNav;
    }
    
    return YES;
}

- (void)setupNavigationBar
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barStyle = UIBarStyleBlack;
    bar.barTintColor = YB_Global_NavBackColor;
    bar.tintColor = [UIColor whiteColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

//更新用户信息
-(void)updateUserCache
{
    NSDictionary *params = @{@"userid":Golble_User_Id,
                             @"password":@""};
    [YBLoginModel loginRequest:params Block:^(NSDictionary *result, NSString *message) {
        if (message) {
            [self jumpTpLoginVC];
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
            [RCIM sharedRCIM].currentUserInfo = userInfo;
        }
    }];
}

//异常状态下，清除用户信息后跳转到登录页
-(void)jumpTpLoginVC
{
    //清理缓存后跳转到登录页面
    [YBUserCache clearUserInfo];
    //删除已经缓存的用户和群组数据
    [[RCDBManager shareInstance] clearUserData];
    [[RCDBManager shareInstance] clearGroupsData];
    [[RCDBManager shareInstance] clearGroupMembersData];
    
    //将消息提醒数量重置为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //注销融云连接
    [[RCIM sharedRCIM] logout];
    
    YBLoginVC *loginVC = [[YBLoginVC alloc]init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = rootNav;
}

#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        
        [self jumpTpLoginVC];
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Token已过期，请重新登录"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
            [alertView show];
            
            [self jumpTpLoginVC];
        });
    }
}

#pragma mark 融云收到消息的代理事件，群组更名以及退出解散的判断
//根据收到的群组消息内容来判断操作
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    //发送更新会话页面左上角未读消息数以及tabbar的未读消息数
    NSString *messageId = [NSString stringWithFormat:@"%@",message.targetId];
    
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msgContent = (RCInformationNotificationMessage *)message.content;
        if([msgContent.message rangeOfString:@"发起"].location != NSNotFound || [msgContent.message rangeOfString:@"加入"].location != NSNotFound)
        {
            YBLog(@"**************收到发起群组或者被加入群组的消息*****************");
            //            根据当前消息的targetId去网络请求群组信息后存入本地
            if (!([RCIM sharedRCIM].currentUserInfo.userId == nil)) {
                YBGroupInfo *groupinfo = [[YBGroupInfo alloc]init];
                groupinfo.groupId = messageId;
                groupinfo.groupName = msgContent.extra;
                
                [[RCDBManager shareInstance] insertGroupToDB:groupinfo];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_UNREAD_COUNT object:nil userInfo:@{@"groupId":messageId}];
        } else if ([msgContent.message rangeOfString:@"解散"].location != NSNotFound){
            YBLog(@"**************收到群组解散的消息*****************");
            
            //群组被解散
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
            
            //如果当前用户在会话界面，则将群设置按钮置空
            [[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_OUT object:nil userInfo:@{@"groupId":messageId,@"mark":@"解散"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_UNREAD_COUNT object:nil userInfo:@{@"groupId":messageId}];
            
        } else if ([msgContent.message rangeOfString:@"移出"].location != NSNotFound) {
            //被踢出群组
            YBLog(@"**************收到被踢出群组的消息*****************");
            //网络查询当前用户的群组列表之后匹配
            /*
            [GroupInfoModel getMyGroupList:nil andBlock:^(NSMutableArray *result, NSString *errDes) {
                if (!errDes) {
                    //检查当前消息的targetId是不是在我的群组中，在则不做任何处理，不在则删除该id在本地的缓存信息
                    BOOL imIn = NO;
                    for (NSDictionary *dic in result) {
                        if ([[dic objectForKey:@"id"] isEqualToString:messageId]) {
                            imIn = YES;
                            break;
                        }
                    }
                    
                    if (!imIn) {
                        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
                        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
                        
                        //如果当前用户在会话界面，则将群设置按钮置空
                        [[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_OUT object:nil userInfo:@{@"groupId":messageId,@"mark":@"移出"}];
                        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_UNREAD_COUNT object:nil userInfo:@{@"groupId":messageId}];
                        
                    }
                }
            }];
             */
        } else if ([msgContent.message rangeOfString:@"群名称"].location != NSNotFound) {
            //群组更名，网络请求最新的群组名称后替换本地的缓存
            YBLog(@"**************收到群名称被修改的消息*****************");
            if (!([RCIM sharedRCIM].currentUserInfo.userId == nil)) {
                YBGroupInfo *group = [[YBGroupInfo alloc]initWithGroupId:messageId groupName:msgContent.extra portraitUri:@""];
                [[RCDBManager shareInstance] insertGroupToDB:group];
                [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:group.groupId];
                
                //发送群名称修改的通知UpdateGroupName
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GROUP_NAME object:nil userInfo:@{@"groupName":msgContent.extra,@"groupId":messageId}];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_UNREAD_COUNT object:nil userInfo:@{@"groupId":messageId}];
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_UNREAD_COUNT object:nil userInfo:@{@"groupId":messageId}];
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    }
}

#pragma mark 3D Touch
-(void)addTouch:(UIApplication *) application{
    /**
     type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    
    //我的二维码
    UIApplicationShortcutIcon *myqrIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_myqr"];
    UIApplicationShortcutItem *myqrItem = [[UIApplicationShortcutItem alloc] initWithType:@"myqr" localizedTitle:@"我的二维码" localizedSubtitle:@"" icon:myqrIcon userInfo:nil];
    
    //扫一扫
    UIApplicationShortcutIcon *scanIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_scan"];
    UIApplicationShortcutItem *scanItem = [[UIApplicationShortcutItem alloc] initWithType:@"scan" localizedTitle:@"扫一扫" localizedSubtitle:@"" icon:scanIcon userInfo:nil];
    
    //收付款
    UIApplicationShortcutIcon *payIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_pay"];
    UIApplicationShortcutItem *payItem = [[UIApplicationShortcutItem alloc] initWithType:@"pay" localizedTitle:@"收付款" localizedSubtitle:@"" icon:payIcon userInfo:nil];
    
    /** 将items 添加到app图标 */
    application.shortcutItems = @[myqrItem, scanItem, payItem];
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"==========  performActionForShortcutItem  ==========");
    
    NSLog(@"################:%@",shortcutItem.type);
    // 创建配置目录
    
    [NSFileManager createDir:DIR_PATH_FOR_CONFIG];
    
    if ([YBUserCache exists]) {
        UIViewController *rootVC = self.window.rootViewController;
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            UIViewController *rootNavVC = [(UITabBarController *)rootVC selectedViewController];
            if ([rootNavVC isKindOfClass:[UINavigationController class]]) {
                UIViewController *currentVC = [(UINavigationController *)rootNavVC topViewController];
                
                if ([shortcutItem.type isEqualToString:@"myqr"]) {
                    NSInteger vcsCount = [(UINavigationController *)rootNavVC viewControllers].count;
                    YBMyQRVC *qrVC = [[YBMyQRVC alloc]init];
                    currentVC.hidesBottomBarWhenPushed = YES;
                    [currentVC.navigationController pushViewController:qrVC animated:YES];
                    if (!(vcsCount > 1)) {
                        currentVC.hidesBottomBarWhenPushed = NO;
                    }
                }
                else if ([shortcutItem.type isEqualToString:@"scan"])
                {
                    
                }
                else if ([shortcutItem.type isEqualToString:@"pay"])
                {
                    
                }
                else
                {
                    
                }
            }
        }
    }
}

#pragma mark 融云红包回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    return NO;
}

#pragma mark 日志本地记录
-(void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"log%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    NSLog(@"==========  applicationWillResignActive  ==========");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"==========  applicationDidEnterBackground  ==========");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"==========  applicationWillEnterForeground  ==========");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"==========  applicationDidBecomeActive  ==========");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"==========  applicationWillTerminate  ==========");
}

@end
