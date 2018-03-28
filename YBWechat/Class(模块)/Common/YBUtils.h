//
//  YBUtils.h
//  YBWechat
//
//  Created by 易博 on 2018/2/6.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBUtils : NSObject


/**
 url地址进行编码，包括中文

 @param str 待编码串
 @return return value description
 */
+(NSString *) urlEncode:(NSString *)str;

/**
 通过正则表达式验证指定字符串是否符合格式

 @param str str 待验证的字符串
 @param regStr str 正则表达式
 @return return value description
 */
+(BOOL) validateStrByRegExp:(NSString *)str regStr:(NSString *)regStr;


/**
 显示转圈

 @param view 显示转圈的view
 */
+(void) showActivityInView:(UIView *)view;


/**
 隐藏转圈

 @param view 隐藏转圈的view
 */
+(void) hideActivityInView:(UIView *)view;


/**
 显示成功提示，1.5秒后消失

 @param view view description
 */
+(void) showSuccessInView:(NSString *)title inView:(UIView *)view;


/**
 显示错误提示，1.5秒后消失

 @param view view description
 */
+(void) showErrorInView:(NSString *)title inView:(UIView *)view;


/**
 显示文本提示，1.5秒后消失

 @param title title description
 @param view view description
 */
+(void) showMessageInView:(NSString *)title inView:(UIView *)view;


/**
 弹出框

 @param message 消息
 @param title 标题
 @param vc 弹出的载体
 @param cancleBtn 是否显示取消按钮
 @param actiond 确定按钮触发事件
 */
+ (void)showAlert:(NSString *)message
            title:(NSString *)title
         showInVC:(UIViewController *)vc
    showCancleBtn:(BOOL)cancleBtn
       sureAction:(void (^)())actiond;

/**
 *  获取默认的群组头像路径
 *
 *  @param groupInfo 群组信息
 *
 *  @return 群组头像路径
 */
+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo;

/**
 *  获取默认的个人头像路径
 *
 *  @param userInfo 个人信息
 *
 *  @return 个人头像路径
 */
+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo;

//通讯录排序相关
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList;
+ (NSString *)hanZiToPinYinWithString:(NSString *)hanZi;
+ (NSString *)getFirstUpperLetter:(NSString *)hanzi;
@end
