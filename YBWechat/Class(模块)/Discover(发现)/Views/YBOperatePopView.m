//
//  YBOperatePopView.m
//  YBWechat
//
//  Created by 易博 on 2018/6/1.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBOperatePopView.h"

@interface YBOperatePopView()
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation YBOperatePopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBOperatePopView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor colorWithRed:79.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1.0];
        
        [self.praiseBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:79.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1.0]] forState:(UIControlStateNormal)];
        [self.praiseBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:60.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
        
        [self.commentBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:79.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1.0]] forState:(UIControlStateNormal)];
        [self.commentBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:60.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    }
    return self;
}

- (IBAction)operateBtnClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(operateBtnClickedOnPopView:info:)])
    {
        NSString *type = 30001 == sender.tag ? @"0" : @"1";
        NSDictionary *dict = @{};
        [self.delegate operateBtnClickedOnPopView:type info:dict];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
