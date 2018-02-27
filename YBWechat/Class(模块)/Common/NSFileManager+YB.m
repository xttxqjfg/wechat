//
//  NSFileManager+YB.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "NSFileManager+YB.h"

@implementation NSFileManager (YB)

// 创建目录
+ (BOOL)createDir:(NSString *)dir{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir) {
        NSLog(@"%@目录已存在",dir);
        return YES;
    }
    NSError *err;
    BOOL flag = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"目录创建失败:%@",[err localizedDescription]);
    }
    return flag;
}

// 删除指定路径的文件
+ (void)deleteFile:(NSString*)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    if([fm removeItemAtPath:filePath error:&err]){
        NSLog(@"文件%@删除成功",filePath);
    }else{
        NSLog(@"文件删除错误：%@",[err localizedDescription]);
    }
}


// 获取文件的MIME类型
+ (NSString*)mimeType:(NSString *)filePath{
    
    NSString *mimeType;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest * request = [NSURLRequest requestWithURL:fileUrl];
    
    NSURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error) {
        mimeType = response.MIMEType;
    }
    return mimeType;
}


// 将对象归档到指定的文件中
+ (void)archiver:(id)object
          forKey:(NSString *)key
          toFile:(NSString *)filePath{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

// 从指定的文件中解档对象
+ (id)unArchiverFromFile:(NSString *)filePath
                 withKey:(NSString *)key{
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id obj = [unArchiver decodeObjectForKey:key];
    [unArchiver finishDecoding];
    return obj;
}

// 检查指定文件是否存在
+ (BOOL)fileExistsForPath:(NSString*)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

// 获取指定路径下的所有文件名
+ (NSArray*) filesArrForPath:(NSString*)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSArray *filesArr = [fm contentsOfDirectoryAtPath:filePath error:&error];

    if (error) {
        return nil;
    }
    return filesArr;
}

// 获取指定路径文件的属性信息
+ (NSDictionary*)fileAttributeForPath:(NSString*)filePath{
    NSError *error;
    NSDictionary *fileAttr = [[self dm]attributesOfItemAtPath:filePath error:&error];
    if (error) {
        return nil;
    }
    return fileAttr;
}

/**
 *  获取文件管理器
 *
 *  @return 文件管理器
 */
+ (NSFileManager*)dm{
    return [NSFileManager defaultManager];
}

@end
