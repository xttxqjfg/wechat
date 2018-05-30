//
//  BusinessCardSendCell.m
//  YBWechat
//
//  Created by 易博 on 2018/5/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "BusinessCardSendCell.h"

#import "BusinessCardSendMessage.h"

#define CardSend_Message_Font_Size 16.0

@interface BusinessCardSendCell()

//用户头像
@property (nonatomic,strong) UIImageView *userPortraitImageView;
//用户姓名
@property (nonatomic,strong) UILabel *userNameLabel;
//分割线
@property (nonatomic,strong) UILabel *separateLabel;
//title
@property (nonatomic,strong) UILabel *titleNameLabel;

@end

@implementation BusinessCardSendCell

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

    self.userPortraitImageView = [[UIImageView alloc]init];
    [self.bubbleBackgroundView addSubview:self.userPortraitImageView];
    
    self.userNameLabel = [[UILabel alloc]init];
    [self.userNameLabel setTextAlignment:NSTextAlignmentLeft];
    self.userNameLabel.font = [UIFont systemFontOfSize:CardSend_Message_Font_Size];
    [self.bubbleBackgroundView addSubview:self.userNameLabel];
    
    self.separateLabel = [[UILabel alloc]init];
    self.separateLabel.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.bubbleBackgroundView addSubview:self.separateLabel];
    
    self.titleNameLabel = [[UILabel alloc]init];
    self.titleNameLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0];
    self.titleNameLabel.text = @"个人名片";
    [self.titleNameLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleNameLabel.font = [UIFont systemFontOfSize:12.0];
    [self.bubbleBackgroundView addSubview:self.titleNameLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:textMessageTap];
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

- (void)setAutoLayout {
    BusinessCardSendMessage *cardSendMessage = (BusinessCardSendMessage *)self.model.content;
    if (cardSendMessage) {
        //名片赋值
        YBUserInfo *cardUserInfo = [YBUserInfo yy_modelWithJSON:cardSendMessage.content];
        if (cardUserInfo) {
            self.userNameLabel.text = cardUserInfo.name;
            if([cardUserInfo.portraitUri hasPrefix:@"http"])
            {
                [self.userPortraitImageView sd_setImageWithURL:[NSURL URLWithString:cardUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
            }
            else
            {
                self.userPortraitImageView.image = [UIImage imageNamed:@"default_user_image"];
            }
        }
        else
        {
            self.userPortraitImageView.image = [UIImage imageNamed:@"default_user_image"];
            self.userNameLabel.text = @"";
        }
    }
    
    CGSize textLabelSize = [[self class] getTextLabelSize:cardSendMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.userPortraitImageView.frame = CGRectMake(17, 10, 45, 45);
        //整个背景的宽度，减去左右各10、中间间距10、图标宽度
        self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userPortraitImageView.frame) + 10, 10, bubbleBackgroundViewSize.width - 17 - 10 - 10 - 45, 45);
        self.separateLabel.frame = CGRectMake(7, CGRectGetMaxY(self.userPortraitImageView.frame) + 10, bubbleBackgroundViewSize.width - 7, 1);
        self.titleNameLabel.frame = CGRectMake(15, CGRectGetMaxY(self.separateLabel.frame) + 5, bubbleBackgroundViewSize.width - 40, 15);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        //        UIImage *image = [UIImage imageNamed:@"chat_from_bg"];
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.8,image.size.height * 0.2,image.size.width * 0.2)];
    } else {
        self.userPortraitImageView.frame = CGRectMake(10, 10, 45, 45);
        //整个背景的宽度，减去左右各10、中间间距10、图标宽度
        self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userPortraitImageView.frame) + 10, 10, bubbleBackgroundViewSize.width - 10 - 10 - 10 - 45, 45);
        self.separateLabel.frame = CGRectMake(0, CGRectGetMaxY(self.userPortraitImageView.frame) + 10, bubbleBackgroundViewSize.width - 7, 1);
        self.titleNameLabel.frame = CGRectMake(8, CGRectGetMaxY(self.separateLabel.frame) + 5, bubbleBackgroundViewSize.width - 40, 15);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x = self.baseContentView.bounds.size.width -(messageContentViewRect.size.width + HeadAndContentSpacing + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [UIImage imageNamed:@"card_chat_to_bg"];
//        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.2,image.size.height * 0.2,image.size.width * 0.8)];
    }
}

+ (CGSize)getTextLabelSize:(BusinessCardSendMessage *)message {
    if ([message.content length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width - (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        /*
        CGRect textRect = [message.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:CardSend_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
//        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
         */
        //个人名片固定高度
        return CGSizeMake(maxWidth - 30, 75.0);
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
    BusinessCardSendMessage *message = (BusinessCardSendMessage *)model.content;
    CGSize size = [BusinessCardSendCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

+ (CGSize)getBubbleBackgroundViewSize:(BusinessCardSendMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}

@end
