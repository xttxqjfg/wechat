//
//  NSFileManager+YB.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (YB)

/**
 *  创建目录
 *
 *  @param dir 目录名称
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDir:(NSString*)dir;

/**
 *  删除指定路径的文件
 *
 *  @param filePath 路径
 */
+ (void)deleteFile:(NSString*)filePath;

/**
 *  获取文件的MIME类型
 *
 *  @param filePath 文件的完整路径
 *
 *  @return mimeType
 */
+ (NSString*)mimeType:(NSString*)filePath;


/**
 *  将对象归档到指定的文件中
 *
 *  @param object   归档对象
 *  @param key      归档键
 *  @param filePath 归档文件
 */
+ (void)archiver:(id)object
          forKey:(NSString*)key
          toFile:(NSString*)filePath;

/**
 *  从指定的文件中解档对象
 *
 *  @param filePath 解档文件
 *  @param key      解档键
 *
 *  @return 解档对象
 */
+ (id)unArchiverFromFile:(NSString*)filePath
                 withKey:(NSString*)key;

/**
 *  检查指定路径文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return YES:存在  NO:不存在
 */
+ (BOOL)fileExistsForPath:(NSString*)filePath;

/**
 *  获取指定路径下的所有文件名
 *
 *  @param filePath 指定路径
 *
 *  @return 所有文件信息
 */
+ (NSArray*)filesArrForPath:(NSString*)filePath;

/**
 *  获取指定路径文件的属性信息
 *
 *  @param filePath 文件路径
 *
 *  @return 属性字典
 */
+ (NSDictionary*)fileAttributeForPath:(NSString*)filePath;


@end
