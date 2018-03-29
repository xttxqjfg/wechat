//
//  RootViewController.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "RootViewController.h"

#import "YBMessageListVC.h"
#import "YBContactsVC.h"
#import "YBDiscoverVC.h"
#import "YBMineVC.h"

#define kClassNameKey   @"rootVCClassName"
#define kTitleKey   @"title"
#define kImageKey     @"imageName"
#define kSelImageKey  @"selectedImageName"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *rootVCItemsArray = @[
                                 @{kClassNameKey  : @"YBMessageListVC",
                                   kTitleKey  : @"微信",
                                   kImageKey    : @"tabbar_message",
                                   kSelImageKey : @"tabbar_messageSel"},
                                 
                                 @{kClassNameKey  : @"YBContactsVC",
                                   kTitleKey  : @"通讯录",
                                   kImageKey    : @"tabbar_contacts",
                                   kSelImageKey : @"tabbar_contactsSel"},
                                 
                                 @{kClassNameKey  : @"YBDiscoverVC",
                                   kTitleKey  : @"发现",
                                   kImageKey    : @"tabbar_discover",
                                   kSelImageKey : @"tabbar_discoverSel"},
                                 
                                 @{kClassNameKey  : @"YBMineVC",
                                   kTitleKey  : @"我",
                                   kImageKey    : @"tabbar_mine",
                                   kSelImageKey : @"tabbar_mineSel"} ];
    
    for (NSDictionary *dic in rootVCItemsArray) {
        UIViewController *vc = [NSClassFromString(dic[kClassNameKey]) new];
        vc.title = dic[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dic[kTitleKey];
        item.image = [UIImage imageNamed:dic[kImageKey]];
        item.selectedImage = [[UIImage imageNamed:dic[kSelImageKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : YB_Tabbar_TintColorSel} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
