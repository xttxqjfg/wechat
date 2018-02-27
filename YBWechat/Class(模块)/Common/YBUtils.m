//
//  YBUtils.m
//  YBWechat
//
//  Created by 易博 on 2018/2/6.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUtils.h"
#import "DefaultPortraitView.h"

@implementation YBUtils

+(NSString *) urlEncode:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

+(BOOL) validateStrByRegExp:(NSString *)str regStr:(NSString *)regStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
    BOOL isValid = [predicate evaluateWithObject:str];
    
    if (isValid) {
        return YES;
    }
    return NO;
}

+(void) showActivityInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"加载中...";
}

+(void) hideActivityInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void) showSuccessInView:(NSString *)title inView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"successMark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor lightGrayColor];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

+(void) showErrorInView:(NSString *)title inView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorMark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor lightGrayColor];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

+(void) showMessageInView:(NSString *)title inView:(UIView *)view
{
    if (!view || !title)
    {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if ([title length] > 10) {
        hud.detailsLabel.text = title;
    }
    else
    {
        hud.label.text = title;
    }
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor lightGrayColor];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showAlert:(NSString *)message
            title:(NSString *)title
         showInVC:(UIViewController *)vc
    showCancleBtn:(BOOL)cancleBtn
       sureAction:(void (^)())actiond
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actiond();
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    
    [alertController addAction:sureAction];
    if (cancleBtn) {
        [alertController addAction:cancleAction];
    }
    
    [vc presentViewController:alertController animated:YES completion:^{
        
    }];
}

+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo {
    NSString *filePath = [[self class] getIconCachePath:[NSString stringWithFormat:@"group%@.png",groupInfo.groupId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
        return [portraitPath absoluteString];
    } else {
        DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [defaultPortrait setColorAndLabel:[NSString stringWithFormat:@"%@",groupInfo.groupId] Nickname:groupInfo.groupName];
        UIImage *portrait = [defaultPortrait imageFromView];
        
        BOOL result = [UIImagePNGRepresentation(portrait)writeToFile:filePath atomically:YES];
        if (result) {
            NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
            return [portraitPath absoluteString];
        } else {
            return nil;
        }
    }
}

+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo {
    if ([userInfo.portraitUri length] > 0) {
        return userInfo.portraitUri;
    }
    
    NSString *filePath = [[self class] getIconCachePath:[NSString stringWithFormat:@"user%@.png",userInfo.userId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    else
    {
        DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [defaultPortrait setColorAndLabel:[NSString stringWithFormat:@"%@",userInfo.userId] Nickname:[NSString stringWithFormat:@"%@",userInfo.name]];
        UIImage *portrait = [defaultPortrait imageFromView];
        
        BOOL result = [UIImagePNGRepresentation(portrait)writeToFile: filePath atomically:YES];
        if (result) {
            NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
            return [portraitPath absoluteString];
        } else {
            return nil;
        }
    }
}

+ (NSString *)getIconCachePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"CachedIcons/%@",fileName]];   // 保存文件的名称
    
    NSString *dirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"CachedIcons"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath]) {
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return filePath;
}

@end
