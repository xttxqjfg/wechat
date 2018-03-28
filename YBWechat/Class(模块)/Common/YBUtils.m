//
//  YBUtils.m
//  YBWechat
//
//  Created by 易博 on 2018/2/6.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBUtils.h"
#import "DefaultPortraitView.h"
#import "pinyin.h"

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

+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList {
    if (!userList)
        return nil;
    NSArray *_keys = @[
                       @"A",
                       @"B",
                       @"C",
                       @"D",
                       @"E",
                       @"F",
                       @"G",
                       @"H",
                       @"I",
                       @"J",
                       @"K",
                       @"L",
                       @"M",
                       @"N",
                       @"O",
                       @"P",
                       @"Q",
                       @"R",
                       @"S",
                       @"T",
                       @"U",
                       @"V",
                       @"W",
                       @"X",
                       @"Y",
                       @"Z",
                       @"#"
                       ];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    NSMutableArray *_tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    
    for (NSString *key in _keys) {
        
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        NSMutableArray *tempArr = [NSMutableArray new];
        for (id user in userList) {
            NSString *firstLetter;
            if ([user isMemberOfClass:[YBUserInfo class]]) {
                YBUserInfo *userInfo = (YBUserInfo*)user;
                if (userInfo.name.length > 0 && ![userInfo.name isEqualToString:@""]) {
                    firstLetter = [self getFirstUpperLetter:userInfo.name];
                }
            }
            if ([user isMemberOfClass:[RCUserInfo class]]) {
                RCUserInfo *userInfo = (RCUserInfo*)user;
                firstLetter = [self getFirstUpperLetter:userInfo.name];
            }
            if ([firstLetter isEqualToString:key]) {
                [tempArr addObject:user];
            }
            
            if (isReturn)
                continue;
            char c = [firstLetter characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:user];
            }
        }
        if (![tempArr count])
            continue;
        [infoDic setObject:tempArr forKey:key];
    }
    if ([_tempOtherArr count])
        [infoDic setObject:_tempOtherArr forKey:@"#"];
    
    NSArray *keys = [[infoDic allKeys]
                     sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         
                         return [obj1 compare:obj2 options:NSNumericSearch];
                     }];
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:keys];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    [resultDic setObject:infoDic forKey:@"infoDic"];
    [resultDic setObject:allKeys forKey:@"allKeys"];
    return resultDic;
}

+ (NSString *)getFirstUpperLetter:(NSString *)hanzi {
    NSString *pinyin = [self hanZiToPinYinWithString:hanzi];
    NSString *firstUpperLetter = [[pinyin substringToIndex:1] uppercaseString];
    if ([firstUpperLetter compare:@"A"] != NSOrderedAscending &&
        [firstUpperLetter compare:@"Z"] != NSOrderedDescending) {
        return firstUpperLetter;
    } else {
        return @"#";
    }
}

/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
+ (NSString *)hanZiToPinYinWithString:(NSString *)hanZi {
    if (!hanZi) {
        return nil;
    }
    NSString *pinYinResult = [NSString string];
    for (int j = 0; j < hanZi.length; j++) {
        NSString *singlePinyinLetter = nil;
        if ([self isChinese:[hanZi substringWithRange:NSMakeRange(j, 1)]]) {
            singlePinyinLetter = [[NSString
                                   stringWithFormat:@"%c", pinyinFirstLetter([hanZi characterAtIndex:j])]
                                  uppercaseString];
        }else{
            singlePinyinLetter = [hanZi substringWithRange:NSMakeRange(j, 1)];
        }
        
        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}

+ (BOOL)isChinese:(NSString *)text
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:text];
}

@end
