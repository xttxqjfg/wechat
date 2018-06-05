//
//  UserDefine.h
//  YBWechat
//
//  Created by 易博 on 2018/2/7.
//  Copyright © 2018年 易博. All rights reserved.
//

#ifndef UserDefine_h
#define UserDefine_h

//屏幕相关参数定义
#define YB_SCREEN_FRAME ([UIScreen mainScreen].applicationFrame)
#define YB_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YB_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define YB_SCREEN_RATIO ([UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width)

#define YB_HEIGHT_PRO [UIScreen mainScreen].bounds.size.height/568
#define YB_WIDTH_PRO [UIScreen mainScreen].bounds.size.width/320

//颜色相关宏定义
#define YB_Global_TintColor [UIColor lightGrayColor]
#define YB_Tabbar_TintColorSel [UIColor colorWithRed:27.0/255.0 green:163.0/255.0 blue:25.0/255.0 alpha:1.0]
#define YB_Global_NavBackColor [UIColor colorWithRed:36.0/255.0 green:38.0/255.0 blue:47.0/255.0 alpha:1.0]

// 详细日志打印
#ifdef DEBUG
# define YBLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define YBLog(...);
#endif

//融云相关通知
#define UPDATE_UNREAD_COUNT @"UpdateUnreadCount"    // 刷新未读消息数
#define REMOVE_OUT @"RemoveOut"                     // 被移出群组或者群组被解散
#define UPDATE_GROUP_NAME @"UpdateGroupName"        // 群组更名

//调用：Weakself(self);然后使用weakself；StrongSelf(self) 使用strongself (名字可以根据##任意改)
#define YBWeakSelf(obj)  __weak typeof(obj) weak##obj = obj;
#define YBStrongSelf(obj)  __strong typeof(obj) strong##obj = weak##obj;

#define RSA_Public_key @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/Mg8pFfTAD/iJmk7GY1s0v+exDIWKzYY1fNY6ODMLaZ//Hd4PpgMkyBsGQEDlN2XxCX8JUtwS9DJ6MbjbIH7z/etN4e4XUAuEklQP44DW0mh8O/7njeHofwdR7Ob48JKEECmrVfpotlWhBDD7ay9s+shTGpUQwbY05dTcbbZr4wIDAQAB"

#define RSA_Private_key @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL8yDykV9MAP+ImaTsZjWzS/57EMhYrNhjV81jo4Mwtpn/8d3g+mAyTIGwZAQOU3ZfEJfwlS3BL0MnoxuNsgfvP9603h7hdQC4SSVA/jgNbSaHw7/ueN4eh/B1Hs5vjwkoQQKatV+mi2VaEEMPtrL2z6yFMalRDBtjTl1NxttmvjAgMBAAECgYAM2RxTsnoD/g7BkHECu+KBJPQ43ZKLxUvjhEQRHX2woqRxzFwDyTAk5J2MSf0Saiqbi/vRcJQBYg+STo0RjJl7Ri/57Vl2/HE5iSZsQovVSdU7ZsCYTpNyix7gIdWKv2eEHE9yJd38R//a88PA8KtNRADpuFjv+wQIp/0F7Z1VIQJBAOVmrRB2rQ/LrWTxEq0Nv16ytur9gkRsvAABb8FW9KArFzMw7WHk17nKx2eP66YhDhSGSHduITzTferfCOH9Ms8CQQDVXVOLvz4x0jXn3eh2YtM6XVfNZtPHumYCxupEWC3hITvP+f6EPIEPXkSXW0QPrf8krZihmj6TxAqvS4NoMQqtAkEA4L7iSSHr1XDXlPB2OqMgXRe8C6eIi5735Q2DPqkBizYMSbPiraj1DOo0yCqBVUZHNCaHMrLrz1ron0YZvsZAkwJBANNzQxnqtMOBNWUN2ZSByh48ZYitUFLPGsvDwGVtEkLbwcASXDdHEwxc+xMZIrF7WbFKzUnSaBPfJEunRZqbh50CQA2w+bEOZ6ZFcVcP0W5e9++WOqMyjoN5WSN++Vhpdi/llsvTXAmvypquG3S4Vc06Uig59rT5UID6KxkT3sN7lcE="

// 沙箱缓存路径
//NSDocumentDirectory：能长时间保存
//NSCachesDirectory：不能长时间保存，会被系统删除
#define DIR_PATH_FOR_CACHE NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
// 配置信息保存目录
#define DIR_PATH_FOR_CONFIG [DIR_PATH_FOR_CACHE stringByAppendingPathComponent:@"config"]

//正则表达式
//手机号码
#define REG_TELNUMBER @"^([\\+]?)\\d{1,4}$"

//强密码验证(8至50位，包含大小写、数字和特殊字符)
#define REG_STRONG_PASSWORD @"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9 ])).{8,50}$"

//用户名验证(6至20位，以字母开头，字母，数字，减号，下划线)
#define REG_USERID @"^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$"

// 数据库加密key
#define DATABASE_KEY @"yb123"

//用户id的全局变量
#define Golble_User_Id [NSString stringWithFormat:@"%@",[[YBUserCache unArchiverAccount].userInfoDict objectForKey:User_Info_ID]]

//用户昵称的全局变量
#define Golble_User_Name [NSString stringWithFormat:@"%@",[[YBUserCache unArchiverAccount].userInfoDict objectForKey:User_Info_Name]]

//用户token的全局变量
#define Golble_User_Token [NSString stringWithFormat:@"%@",[[YBUserCache unArchiverAccount].userInfoDict objectForKey:User_Info_Token]]

//融云即时通讯key
#define RONGCLOUD_INT_KEY @"ik1qhw09iv72p"

#endif /* UserDefine_h */
