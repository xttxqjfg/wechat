//
//  YBNetRequestManager.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBNetRequestManager.h"

@implementation YBNetRequestManager

static YBNetRequestManager *_sharedManager;

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[YBNetRequestManager manager] initWithBaseURL:[NSURL URLWithString:SNet_BaseURL]];
    });
    
    return _sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 15.0f;
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/xml", nil];
    
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    self.securityPolicy.allowInvalidCertificates = YES;
    [self.securityPolicy setValidatesDomainName:NO];
    
    return self;
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

- (void)postRequestDataWithPath:(NSString *)path
                 WithParameters:(NSDictionary *)parameters
      constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                       Progress:(nullable void (^)(NSProgress *progress))Progress
                       andBlock:(nullable void (^)(id data, NSError *error))resultBlock{
    // 请求地址打印
    NSString *baseURLStr = self.baseURL.absoluteString;
    NSString *requstURLStr = [NSString stringWithFormat:@"%@",path];
    NSLog(@"\n=========== request ===========\n%@%@%@",baseURLStr,requstURLStr,parameters);
    
    [self POST:requstURLStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        resultBlock(responseObject, nil);
        NSLog(@"\n===========POST CONSTRUCT request success ===========\n");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultBlock(nil,error);
        NSLog(@"\n===========POST CONSTRUCT request fail ===========\n");
        
    }];
}

@end
