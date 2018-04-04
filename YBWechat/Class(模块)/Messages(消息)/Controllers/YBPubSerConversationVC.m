//
//  YBPubSerConversationVC.m
//  YBWechat
//
//  Created by 易博 on 2018/4/4.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBPubSerConversationVC.h"

#import "YBContactsModel.h"

@interface YBPubSerConversationVC ()

@end

@implementation YBPubSerConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (ConversationType_APPSERVICE == self.conversationType) {
        [self getMenuList];
    }
}

-(void)getMenuList
{
    YBWeakSelf(self);
    
    NSDictionary *params = @{@"userid":Golble_User_Id,@"serverid":self.targetId};
    
    [YBContactsModel pubSerMenuListRequest:params Block:^(NSArray *result, NSString *message) {
        
        if (!message) {
            [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlPubType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];
            
            CGRect containFrame = self.chatSessionInputBarControl.menuContainerView.bounds;
            CGFloat btnW = containFrame.size.width / result.count;
            CGFloat btnH = containFrame.size.height;
            
            for (NSInteger i = 0; i < result.count; i++) {
                NSDictionary *menuDic = [[NSDictionary alloc]initWithDictionary:[result objectAtIndex:i]];
                UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnW * i, 0, btnW, btnH)];
                [menuBtn setTitle:[menuDic objectForKey:@"menuName"] ? [NSString stringWithFormat:@"%@",[menuDic objectForKey:@"menuName"]] : @"" forState:(UIControlStateNormal)];
                menuBtn.tag = [menuDic objectForKey:@"menuId"] ? [[menuDic objectForKey:@"menuId"] integerValue] : 9999;
                [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [menuBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [weakself.chatSessionInputBarControl.menuContainerView addSubview:menuBtn];
            }
        }
    }];
}

-(void)menuBtnClicked:(UIButton *)sender
{
    NSLog(@"点击按钮的tag值：%ld",sender.tag);
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
