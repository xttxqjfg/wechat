//
//  YBConversationVC.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBConversationVC.h"

@interface YBConversationVC ()

@end

@implementation YBConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (ConversationType_APPSERVICE == self.conversationType) {
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlPubType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];
        
        CGRect containFrame = self.chatSessionInputBarControl.menuContainerView.bounds;
        CGFloat btnW = containFrame.size.width / 3;
        CGFloat btnH = containFrame.size.height;
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
        [btn1 setTitle:@"时事新闻" forState:(UIControlStateNormal)];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.chatSessionInputBarControl.menuContainerView addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(btnW, 0, btnW, btnH)];
        [btn2 setTitle:@"政策资讯" forState:(UIControlStateNormal)];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.chatSessionInputBarControl.menuContainerView addSubview:btn2];
        
        UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(btnW*2, 0, btnW, btnH)];
        [btn3 setTitle:@"关于我们" forState:(UIControlStateNormal)];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.chatSessionInputBarControl.menuContainerView addSubview:btn3];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
