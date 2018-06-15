//
//  AlbumCellModel.m
//  YBWechat
//
//  Created by 易博 on 2018/6/14.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "AlbumCellModel.h"

@implementation AlbumCellModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.momentsId = [dict objectForKey:@"momentsId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"momentsId"]] : @"";
        
        self.content = [dict objectForKey:@"content"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]] : @"";
        
        self.type = [dict objectForKey:@"type"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]] : @"0";
        
        self.month = [dict objectForKey:@"month"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"month"]] : @"1月";
        
        self.day = [dict objectForKey:@"day"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"day"]] : @"01";
        
        self.picArr = [dict objectForKey:@"picArr"] && [[dict objectForKey:@"picArr"] isKindOfClass:[NSArray class]] ? [[NSArray alloc]initWithArray:[dict objectForKey:@"picArr"]] : @[];
        
        self.cellHeight = 80.0;
    }
    return self;
}

@end
