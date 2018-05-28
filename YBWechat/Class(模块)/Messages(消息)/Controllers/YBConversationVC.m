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

#import "BusinessCardSendCell.h"
#import "BusinessCardSendMessage.h"
#import "BusinessCardRequestCell.h"
#import "BusinessCardRequestMessage.h"

#import "TranslationDataModel.h"

@interface YBConversationVC ()

@end

@implementation YBConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.chatSessionInputBarControl.hidden = YES;
    
    
//    [self checkConversationStatus];
    
    
    [self customMessageInit];
    [self setPluginBoardView];
}

//自定义消息类型注册
-(void)customMessageInit
{
    ///注册翻译消息Cell
    [self registerClass:[TranslationMsgCell class] forMessageClass:[TranslationMessage class]];
    
    ///注册名片请求消息Cell
    [self registerClass:[BusinessCardRequestCell class] forMessageClass:[BusinessCardRequestMessage class]];
    
    ///注册名片发送消息Cell
    [self registerClass:[BusinessCardSendCell class] forMessageClass:[BusinessCardSendMessage class]];
}

//设置输入栏加号里面的内容
-(void)setPluginBoardView
{
    //增加请求名片和发送名片
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"default_user_image"] title:@"请求名片" tag:2000];
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"default_user_image"] title:@"发送名片" tag:3000];
}

#pragma mark pluginBoardView点击处理
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    if (2000 == tag) {
        BusinessCardRequestMessage *cardRequestMsg = [BusinessCardRequestMessage messageWithContent:@"您发起了名片请求,请等待对方的处理。"];
        //发送提示消息
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:cardRequestMsg pushContent:nil pushData:nil success:^(long messageId) {
            NSLog(@"名片请求发送成功...");
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"名片请求发送失败...");
        }];
    }
    else if(3000 == tag)
    {
        YBUserInfo *user = [[YBUserInfo alloc]init];
        user.userId = @"yibo3513";
        user.name = @"/yb相知、相惜/mg";
        user.portraitUri = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527511078203&di=fd70ef609b71e2e019db2aa00d748ec9&imgtype=0&src=http%3A%2F%2Ftx.haiqq.com%2Fuploads%2Fallimg%2Fc161210%2F14Q2c392S330-1cL3.jpg";
        
        BusinessCardSendMessage *cardSendMsg = [BusinessCardSendMessage messageWithContent:[user yy_modelToJSONString]];
        //发送提示消息
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:cardSendMsg pushContent:nil pushData:nil success:^(long messageId) {
            NSLog(@"个人名片发送成功...");
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"个人名片发送失败...");
        }];
    }
    else
    {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

-(void)didTapMessageCell:(RCMessageModel *)model
{
    if ([model.content isKindOfClass:[BusinessCardSendMessage class]])
    {
        BusinessCardSendMessage *msgContent = (BusinessCardSendMessage *)model.content;
        NSLog(@"个人名片消息:%@",msgContent.content);
    }
    else
    {
        [super didTapMessageCell:model];
    }
}

#pragma mark 拦截消息发送
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
