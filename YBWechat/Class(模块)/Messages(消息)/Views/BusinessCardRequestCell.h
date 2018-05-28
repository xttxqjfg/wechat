//
//  BusinessCardRequestCell.h
//  YBWechat
//
//  Created by 易博 on 2018/5/25.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#import "BusinessCardRequestMessage.h"

@interface BusinessCardRequestCell : RCMessageCell

/*!
 请求名片显示文字的Label
 */
@property(strong, nonatomic) UILabel *msgTextLabel;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/*!
 自定义消息 Cell 的 Size
 
 @param model               要显示的消息model
 @param collectionViewWidth cell所在的collectionView的宽度
 @param extraHeight         cell内容区域之外的高度
 
 @return 自定义消息Cell的Size
 
 @discussion 当应用自定义消息时，必须实现该方法来返回cell的Size。
 其中，extraHeight是Cell根据界面上下文，需要额外显示的高度（比如时间、用户名的高度等）。
 一般而言，Cell的高度应该是内容显示的高度再加上extraHeight的高度。
 */
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight;


/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(BusinessCardRequestMessage *)message;

@end
