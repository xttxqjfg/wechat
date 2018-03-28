//
//  UINavigationController+YB.m
//  YBWechat
//
//  Created by 易博 on 2018/2/28.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "UINavigationController+YB.h"


@implementation UINavigationController (YB)

//设置导航栏背景透明度
-(void)setNavigationBackground:(CGFloat)alpha
{
    NSLog(@"UINavigationController (YB)");
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    
    //设置导航栏下的黑线的透明度
    UIView *shadowView = (UIView *)[barBackgroundView valueForKey:@"_shadowView"];
    if (shadowView) {
        shadowView.alpha = alpha;
    }
    
    //如果设置了导航栏的毛玻璃效果，同样设置这层的透明度。iOS7及以上有
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
}

+ (void)initialize {
    if (self == [UINavigationController self]) {
        // 交换方法
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 交换的方法，监控滑动手势
- (void)et__updateInteractiveTransition:(CGFloat)percentComplete {
    [self et__updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = [[coor viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            CGFloat toAlpha = [[coor viewControllerForKey:UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            [self setNavigationBackground:nowAlpha];
        }
    }  
}

#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                [self dealInteractionChanges:context];
            }];
        }
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            [self setNavigationBackground:nowAlpha];
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            [self setNavigationBackground:nowAlpha];
        }];
    }
}

#pragma mark - UINavigationBar Delegate
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= navigationBar.items.count) {// 点击返回按钮
        UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 1];
        [self setNavigationBackground:[popToVC.navBarBgAlpha floatValue]];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    // push到一个新界面
    [self setNavigationBackground:[self.topViewController.navBarBgAlpha floatValue]];
}

@end


