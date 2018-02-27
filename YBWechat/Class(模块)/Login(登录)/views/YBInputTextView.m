//
//  YBInputTextView.m
//  YBWechat
//
//  Created by 易博 on 2018/1/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBInputTextView.h"

@interface YBInputTextView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@end

@implementation YBInputTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YBInputTextView" owner:nil options:nil][0];
        self.frame = frame;
        
        self.rightTextField.delegate = self;
    }
    return self;
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.leftLabel.text = [dataDict objectForKey:@"name"] ? [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"name"]] : @"";
    self.rightTextField.placeholder = [dataDict objectForKey:@"placeholder"] ? [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"placeholder"]] : @"";
    
}

-(void)setIsSecure:(BOOL)isSecure
{
    _isSecure = isSecure;
    
    if (isSecure) {
        self.rightTextField.secureTextEntry = YES;
        self.rightTextField.clearsOnBeginEditing = YES;
    }
    else
    {
        self.rightTextField.secureTextEntry = NO;
        self.rightTextField.clearsOnBeginEditing = NO;
    }
}

-(NSString *)getInputTextStr
{
    return [self.rightTextField.text length] > 0 ? self.rightTextField.text : @"";
}

@end
