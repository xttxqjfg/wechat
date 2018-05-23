//
//  YBConversationVC.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBConversationVC.h"

#import "TranslationMsgCell.h"
#import "TranslationMessage.h"

#import "TranslationDataModel.h"

@interface YBConversationVC ()

@end

@implementation YBConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.chatSessionInputBarControl.hidden = YES;
    
    
//    [self checkConversationStatus];
    
    ///注册自定义测试消息Cell
    [self registerClass:[TranslationMsgCell class]
        forMessageClass:[TranslationMessage class]];
}

- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent
{
    if ([messageContent isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsgContent = (RCTextMessage *)messageContent;
        
        [TranslationDataModel baiduTextTranslationRequest:@{@"content":textMsgContent.content} Block:^(NSString *result, NSString *message) {
            if(result)
            {
                //翻译成功，修改消息内容后发送
                TranslationMessage *translationMessage = [TranslationMessage messageWithContent:[NSString stringWithFormat:@"原文:%@\n译文:%@",textMsgContent.content,result]];
                [super sendMessage:translationMessage pushContent:pushContent];
            }
            else
            {
                //翻译失败，直接发送原文消息
                [super sendMessage:messageContent pushContent:pushContent];
            }
        }];
    }
    else
    {
        [super sendMessage:messageContent pushContent:pushContent];
    }
}

//-(NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model
//{
//    NSMutableArray<UIMenuItem *> *menuList =
//    [[super getLongTouchMessageCellMenuList:model] mutableCopy];
//
//    if([model.content isKindOfClass:[RCTextMessage class]]){
//        self.msgModel = model;
//        //增加翻译按钮
//        UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(onTranslateBtnTap:)];
//        [menuList addObject:translateItem];
//    }
//
//    return menuList;
//}

//检查对话是否能继续
-(void)checkConversationStatus
{
//    NSInteger *messageCount
    for (RCMessageModel *model in self.conversationDataRepository) {
        NSLog(@"####################:%@,%lld",model.messageUId,model.sentTime);
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
