//
//  RSATool.h
//  YBWechat
//
//  Created by 易博 on 2018/2/7.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSATool : NSObject

// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

// return hex string
+ (NSString *)encryptStringToHex:(NSString *)str publicKey:(NSString *)pubKey;

// return raw datax
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

@end
