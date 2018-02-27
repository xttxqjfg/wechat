//
//  DefaultPortraitView.h
//  YBWechat
//
//  Created by 易博 on 2018/2/9.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultPortraitView : UIView

@property (nonatomic, strong) NSString *firstCharacter;

-(void)setColorAndLabel:(NSString *)userId Nickname:(NSString *)nickname;

- (UIImage *)imageFromView;

@end
