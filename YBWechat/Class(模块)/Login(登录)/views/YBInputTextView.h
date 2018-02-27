//
//  YBInputTextView.h
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBInputTextView : UIView

@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,assign) BOOL isSecure;

-(NSString *)getInputTextStr;

@end
