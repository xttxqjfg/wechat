//
//  TranslationMsgCell.m
//  YBWechat
//
//  Created by 易博 on 2018/5/18.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "TranslationMsgCell.h"

#import "TranslationMessage.h"

#define Translation_Message_Font_Size 16.0

@implementation TranslationMsgCell

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
    [self.msgTextLabel setFont:[UIFont systemFontOfSize:Translation_Message_Font_Size]];
    
    self.msgTextLabel.numberOfLines = 0;
    [self.msgTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.msgTextLabel setTextAlignment:NSTextAlignmentLeft];
    [self.msgTextLabel setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.msgTextLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.msgTextLabel addGestureRecognizer:textMessageTap];
    self.msgTextLabel.userInteractionEnabled = YES;
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)setAutoLayout {
    TranslationMessage *transMessage = (TranslationMessage *)self.model.content;
    if (transMessage) {
        self.msgTextLabel.text = transMessage.content;
    }
    
    CGSize textLabelSize = [[self class] getTextLabelSize:transMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
//    messageContentViewRect.origin.x = 20 + [RCIM sharedRCIM].globalMessagePortraitSize.width;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.msgTextLabel.frame =
        CGRectMake(20, 7, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
//        UIImage *image = [UIImage imageNamed:@"chat_from_bg"];
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.8,image.size.height * 0.2,image.size.width * 0.2)];
    } else {
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

+ (CGSize)getTextLabelSize:(TranslationMessage *)message {
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
                                            [UIFont systemFontOfSize:Translation_Message_Font_Size]
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
    TranslationMessage *message = (TranslationMessage *)model.content;
    CGSize size = [TranslationMsgCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

+ (CGSize)getBubbleBackgroundViewSize:(TranslationMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}

@end
