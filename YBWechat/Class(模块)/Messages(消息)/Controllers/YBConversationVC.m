//
//  YBConversationVC.m
//  YBWechat
//
//  Created by 易博 on 2018/3/30.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBConversationVC.h"

@interface YBConversationVC ()

@property (nonatomic,strong) RCMessageModel *msgModel;

- (NSIndexPath *)findDataIndexFromMessageList:(RCMessageModel *)model;

- (CGFloat)referenceExtraHeight:(Class)cellClass messageModel:(RCMessageModel *)model;

@end

@implementation YBConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.chatSessionInputBarControl.hidden = YES;
    
    
//    [self checkConversationStatus];
}

-(NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model
{
    NSMutableArray<UIMenuItem *> *menuList =
    [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    
    if([model.content isKindOfClass:[RCTextMessage class]]){
        self.msgModel = model;
        //增加翻译按钮
        UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(onTranslateBtnTap:)];
        [menuList addObject:translateItem];
    }
    
    return menuList;
}

-(void)onTranslateBtnTap:(UIMenuItem *)sender
{
    RCTextMessage *textMsgContent = (RCTextMessage *)self.msgModel.content;
    NSString *textMsgStr = [NSString stringWithFormat:@"原文:%@\n-----------------\n译文:%@",textMsgContent.content,@"djfasdfbjsdbfnasdkjfhiu2  er237yrfsBDKJLADFOASJ012RHEFB"];
//    model.content = testMsgStr;
    textMsgContent.content = textMsgStr;
    
    CGFloat extraHeight = [self referenceExtraHeight:[RCTextMessageCell class] messageModel:self.msgModel];
    
//    CGFloat extraHeight = 45.0;
    
    self.msgModel.cellSize = [RCTextMessageCell sizeForMessageModel:self.msgModel withCollectionViewWidth:self.conversationMessageCollectionView.frame.size.width referenceExtraHeight:extraHeight];
    
    NSUInteger row = [self.conversationDataRepository indexOfObject:self.msgModel];
//    NSIndexPath *indexpath = [self findDataIndexFromMessageList:self.msgModel];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexpath]];
    
    if ([[self.conversationDataRepository lastObject] isEqual:self.msgModel]) {
        
        [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexpath]];
        
        [self scrollToBottomAnimated:YES];
        
    }
    
//    NSUInteger row = [self.conversationDataRepository indexOfObject:self.msgModel];
//    [self.conversationDataRepository replaceObjectAtIndex:row withObject:self.msgModel];
//    
//    [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
    
    
    
//    [ZTool shareMsgToWechat:[NSString stringWithFormat:@"%@",textMsgContent.content]];
    
    /*
    RCMessage *insertMessage;
    RCInformationNotificationMessage *warningMessage = [RCInformationNotificationMessage notificationWithMessage:@"提醒消息" extra:nil];
//    if (YES) {
        // 如果保存到本地数据库，需要调用insertMessage生成消息实体并插入数据库。
        insertMessage = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:self.conversationType
                                                                    targetId:self.targetId
                                                                  sentStatus:SentStatus_SENT
                                                                     content:warningMessage];
//    } else {
//        // 如果不保存到本地数据库，需要初始化消息实体并将messageId要设置为－1。
//        insertMessage =[[RCMessage alloc] initWithType:self.conversationType
//                                              targetId:self.targetId
//                                             direction:MessageDirection_SEND
//                                             messageId:-1
//                                               content:warningMessage];
//    }
    
    // 在当前聊天界面插入该消息
    [self appendAndDisplayMessage:insertMessage];
     */
}

//检查对话是否能继续
-(void)checkConversationStatus
{
//    NSInteger *messageCount
    for (RCMessageModel *model in self.conversationDataRepository) {
        NSLog(@"####################:%@",model.senderUserId);
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
