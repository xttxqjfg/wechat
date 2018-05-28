//
//  BusinessCardRequestCell.m
//  YBWechat
//
//  Created by 易博 on 2018/5/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "BusinessCardRequestCell.h"

#import "BusinessCardRequestMessage.h"
#import "BusinessCardSendMessage.h"

#define CardRequest_Message_Font_Size 16.0

@interface BusinessCardRequestCell()

@property (nonatomic,strong) UIButton *agreeBtn;  //同意按钮

@end

@implementation BusinessCardRequestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.msgTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.msgTextLabel setFont:[UIFont systemFontOfSize:CardRequest_Message_Font_Size]];
    
    self.msgTextLabel.numberOfLines = 0;
    [self.msgTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.msgTextLabel setTextAlignment:NSTextAlignmentLeft];
    [self.msgTextLabel setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.msgTextLabel];
    
    self.agreeBtn = [[UIButton alloc]init];
    [self.agreeBtn setTitle:@"同意" forState:(UIControlStateNormal)];
    self.agreeBtn.backgroundColor = [UIColor greenColor];
    [self.agreeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    self.agreeBtn.tag = 6000;
    [self.bubbleBackgroundView addSubview:self.agreeBtn];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    BusinessCardRequestMessage *transMessage = (BusinessCardRequestMessage *)self.model.content;
    if (transMessage) {
        if (MessageDirection_SEND == self.messageDirection) {
            transMessage.content = @"您发起了名片请求,请等待对方的处理。";
            self.msgTextLabel.text = transMessage.content;
        }
        else
        {
            transMessage.content = @"对方向您发起了名片请求,是否同意发送名片?同意后您的联系方式将会发送给对方";
            self.msgTextLabel.text = transMessage.content;
        }
    }
    
    MsgOperateModel *model = [[RCDBManager shareInstance] getOperateModelById:self.model.messageUId];
    if (model && [model.operateValue isEqualToString:@"1"]) {
        self.agreeBtn.backgroundColor = [UIColor lightGrayColor];
        self.agreeBtn.enabled = NO;
        self.agreeBtn.userInteractionEnabled = NO;
    }
    
    CGSize textLabelSize = [[self class] getTextLabelSize:transMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.msgTextLabel.frame =
        CGRectMake(20, 7, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        //此处补上按钮的高度
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height + 45.0);
        
        self.agreeBtn.hidden = NO;
        
        CGFloat btnY = CGRectGetMaxY(self.bubbleBackgroundView.frame) - 40;
        CGFloat btnW = (bubbleBackgroundViewSize.width - 7);
        CGFloat btnH = 40.0;
        self.agreeBtn.frame = CGRectMake(7, btnY, btnW, btnH);
        UIBezierPath *maskAgreeBtnPath = [UIBezierPath bezierPathWithRoundedRect:self.agreeBtn.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskAgreeBtnLayer = [CAShapeLayer layer];
        maskAgreeBtnLayer.frame = self.agreeBtn.bounds;
        maskAgreeBtnLayer.path = maskAgreeBtnPath.CGPath;
        self.agreeBtn.layer.mask = maskAgreeBtnLayer;
        
        //        UIImage *image = [UIImage imageNamed:@"chat_from_bg"];
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.8,image.size.height * 0.2,image.size.width * 0.2)];
    } else {
        self.agreeBtn.hidden = YES;
        
        self.msgTextLabel.frame =
        CGRectMake(12, 7, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        //        UIImage *image = [UIImage imageNamed:@"chat_to_bg"];
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.2,image.size.height * 0.2,image.size.width * 0.8)];
    }
}

-(void)btnClicked:(UIButton *)sender
{
    NSLog(@"点击了同意按钮...");
    self.agreeBtn.backgroundColor = [UIColor lightGrayColor];
    self.agreeBtn.enabled = NO;
    self.agreeBtn.userInteractionEnabled = NO;
    
    //记录操作
    MsgOperateModel *model = [[MsgOperateModel alloc]init];
    model.msgId = self.model.messageUId;
    model.operateType = @"1";
    model.operateValue = @"1";
    [[RCDBManager shareInstance] insertOperateToDB:model];
    
    //发送名片
    YBUserInfo *user = [[YBUserInfo alloc]init];
    user.userId = @"yibo3513";
    user.name = @"/yb相知、相惜/mg";
    user.portraitUri = @"https://xttxqjfg.cn/img/avatar-hux.jpg";
    
    BusinessCardSendMessage *cardSendMsg = [BusinessCardSendMessage messageWithContent:[user yy_modelToJSONString]];
    
    //发送提示消息
    [[RCIM sharedRCIM] sendMessage:self.model.conversationType targetId:self.model.targetId content:cardSendMsg pushContent:nil pushData:nil success:^(long messageId) {
        NSLog(@"个人名片发送成功...");
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"个人名片发送失败...");
    }];
}

+ (CGSize)getTextLabelSize:(BusinessCardRequestMessage *)message {
    
    if ([message.content length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width - (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect = [message.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:CardRequest_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    
    if (bubbleSize.width + 12 + 20 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 20;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }
    
    return bubbleSize;
}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight
{
    BusinessCardRequestMessage *message = (BusinessCardRequestMessage *)model.content;
    CGSize size = [BusinessCardRequestCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    
    if(MessageDirection_RECEIVE == model.messageDirection)
    {
        //此处补上按钮的高度和多余文本的高度
        __messagecontentview_height = __messagecontentview_height + 45.0 + 35;
    }
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

+ (CGSize)getBubbleBackgroundViewSize:(BusinessCardRequestMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}

@end
