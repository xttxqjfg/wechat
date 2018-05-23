//
//  TranslationDataModel.m
//  YBWechat
//
//  Created by 易博 on 2018/5/22.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "TranslationDataModel.h"

#import <CommonCrypto/CommonDigest.h>

#define BaiduTranslationUrl @"https://fanyi-api.baidu.com/api/trans/vip/translate?"

@implementation TranslationDataModel

static TranslationDataModel *_sharedManager;

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _sharedManager = [[TranslationDataModel manager] initWithBaseURL:[NSURL URLWithString:BaiduTranslationUrl]];
        _sharedManager = [[TranslationDataModel manager] init];
        
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.requestSerializer.timeoutInterval = 15.0f;
        [_sharedManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/xml", nil];
    });
    
    return _sharedManager;
}

- (void)requestDataWithPath:(NSString *)path
             WithParameters:(NSDictionary *)parameters
            WithRequstStyle:(NSString *)requestStyle
                   Progress:(nullable void (^)(NSProgress *progress))Progress
                   andBlock:(nullable void (^)(id data, NSError *error))resultBlock{
    // 请求地址打印
    NSString *baseURLStr = self.baseURL.absoluteString;
    NSString *requstURLStr = [NSString stringWithFormat:@"%@",path];
    NSLog(@"\n=========== request ===========\n%@%@%@",baseURLStr,requstURLStr,parameters);
    
    if([[requestStyle lowercaseString] isEqualToString:@"get"])
    {
        [self GET:requstURLStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            resultBlock(responseObject,nil);
            NSLog(@"\n=========== GET request success ===========\n");
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resultBlock(nil,error);
            NSLog(@"\n=========== GET request fail ===========\n");
            
        }];
    }
    else if ([[requestStyle lowercaseString] isEqualToString:@"post"])
    {
        [self POST:requstURLStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            resultBlock(responseObject,nil);
            NSLog(@"\n=========== POST  request success ===========\n");
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resultBlock(nil,error);
            NSLog(@"\n=========== POST request fail ===========\n");
            
        }];
    }
    else
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"request faile" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:SNet_BaseURL code:-1009 userInfo:userInfo];
        resultBlock(nil,error);
    }
}

+ (void)baiduTextTranslationRequest:(NSDictionary *)params Block:(void(^)(NSString *result, NSString *message))block
{
    int arcNum = arc4random() % 1000000; // 随机数
    NSString *SECRET_KEY = @"TuBPQcjD3H3MNx8h6leD"; // 秘钥
    NSString *APP_ID = @"20180522000164033"; // APPID
    NSString *translateString = [NSString stringWithFormat:@"%@",[params objectForKey:@"content"]];
    NSString *language = @"en";
    
    // 翻译文本转UTF8 翻译文本需要小写传入
    NSString *translateWords = [translateString.lowercaseString stringByRemovingPercentEncoding];
    
    // appid+q+salt+密钥 的MD5值 sign签名
    NSString *signStr = [NSString stringWithFormat:@"%@%@%d%@",APP_ID,translateWords,arcNum,SECRET_KEY];
    signStr = [signStr stringByRemovingPercentEncoding];
    
    NSDictionary *transParams = @{@"q":[self encodeToPercentEscapeString:translateWords],
                             @"from":[self encodeToPercentEscapeString:@"auto"],
                             @"to":[self encodeToPercentEscapeString:language],
                             @"appid":[self encodeToPercentEscapeString:APP_ID],
                             @"salt":[self encodeToPercentEscapeString:[NSString stringWithFormat:@"%d",arcNum]],
                             @"sign":[self encodeToPercentEscapeString:[self md5:signStr]]};
    
     NSString *requestUrl = [NSString stringWithFormat:@"https://fanyi-api.baidu.com/api/trans/vip/translate?q=%@&from=%@&to=%@&appid=%@&salt=%@&sign=%@",[transParams objectForKey:@"q"],[transParams objectForKey:@"from"],[transParams objectForKey:@"to"],[transParams objectForKey:@"appid"],[transParams objectForKey:@"salt"],[transParams objectForKey:@"sign"]];
    
    [[TranslationDataModel sharedManager] requestDataWithPath:requestUrl WithParameters:@{} WithRequstStyle:@"GET" Progress:^(NSProgress *progress) {
        //
    } andBlock:^(id data, NSError *error) {
        if (!error) {
            if ([data objectForKey:@"trans_result"]) {
                NSArray *translateResultArray = [data objectForKey:@"trans_result"];
                NSString *tranlateString = @"";
                
                for (NSDictionary *dic in translateResultArray) {
                    tranlateString = [tranlateString stringByAppendingString:[dic objectForKey:@"dst"]];
                }
                //有翻译结果的返回
                block(tranlateString,nil);
            }
            else
            {
                //无翻译结果的返回
                block(nil,@"translation failed");
            }
        }
        else
        {
            //请求出错的返回
            block(nil,@"request failed");
        }
    }];
}

#pragma mark  MD5加密
+ (NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output lowercaseString];
}

#pragma mark url-encode编码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input{
    
    NSString *outputStr =
    
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL, /* allocator */
                                                                 
                                                                 (__bridge CFStringRef)input,
                                                                 
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]“",
                                                                 
                                                                 kCFStringEncodingUTF8);
    
    return [outputStr lowercaseString];
}

@end
