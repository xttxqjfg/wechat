//
//  YBMomentsHeaderView.m
//  YBWechat
//
//  Created by 易博 on 2018/5/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMomentsHeaderView.h"

@interface YBMomentsHeaderView()
//用户名
@property (strong, nonatomic) UILabel *userNameLabel;
//用户头像
@property (strong, nonatomic) UIImageView *userPicImageView;
//朋友圈文字内容
@property (strong, nonatomic) YYLabel *mulContentLabel;
//时间戳和来源标识
@property (strong, nonatomic) UILabel *timeAndSourceLabel;
//点赞按钮
@property (strong, nonatomic) UIImageView *operateMoreImageView;
//图片数组
@property (strong, nonatomic) NSMutableArray *picImageViewArr;
//存放图片的view
@property (strong, nonatomic) UIView *picImagesBackGroundView;
@end

@implementation YBMomentsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.userNameLabel.textColor = [UIColor colorWithRed:84.0/255.0 green:100.0/255.0 blue:145.0/255.0 alpha:1.0];
    self.userNameLabel.userInteractionEnabled = YES;
    [self addSubview:self.userNameLabel];
    UITapGestureRecognizer *userNameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDetailTapped:)];
    [self.userNameLabel addGestureRecognizer:userNameTap];
    
    self.userPicImageView = [[UIImageView alloc]init];
    self.userPicImageView.userInteractionEnabled = YES;
    [self addSubview:self.userPicImageView];
    UITapGestureRecognizer *userPicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDetailTapped:)];
    [self.userPicImageView addGestureRecognizer:userPicTap];
    
    self.mulContentLabel = [[YYLabel alloc]init];
    self.mulContentLabel.numberOfLines = 0;
    self.mulContentLabel.textAlignment = NSTextAlignmentLeft;
//    self.mulContentLabel.font = [UIFont systemFontOfSize:16.0];
    self.mulContentLabel.displaysAsynchronously = YES;
    [self addSubview:self.mulContentLabel];
    
    self.picImagesBackGroundView = [[UIView alloc]init];
    self.picImagesBackGroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.picImagesBackGroundView];
    
    self.timeAndSourceLabel = [[UILabel alloc]init];
    self.timeAndSourceLabel.font = [UIFont systemFontOfSize:13.0];
    self.timeAndSourceLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0];
    self.timeAndSourceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeAndSourceLabel];
    
    self.operateMoreImageView = [[UIImageView alloc]init];
    self.operateMoreImageView.image = [UIImage imageNamed:@"moment_operate_more"];
    self.operateMoreImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *operateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(operateMore:)];
    [self.operateMoreImageView addGestureRecognizer:operateTap];
    [self addSubview:self.operateMoreImageView];
    
    self.picImageViewArr = [[NSMutableArray alloc]init];
}

-(void)setHeaderViewData:(MomentsDataModel *)headerViewData
{
    _headerViewData = headerViewData;
    
    for (int i = 0;i < self.headerViewData.picArr.count;i++) {
        UIImageView *picImageView = [[UIImageView alloc]init];
        //tag值用于浏览图片时跳转
        picImageView.tag = 2000 + i;
        [picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerViewData.picArr[i]]] placeholderImage:[UIImage imageNamed:@"mine_album"]];
        [self.picImageViewArr addObject:picImageView];
    }
    
    [self setAutoLayout];
}

-(void)setAutoLayout
{
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:self.headerViewData.content];
    contentText.yy_font = [UIFont systemFontOfSize:16];
    contentText.yy_lineSpacing = 5;
    self.mulContentLabel.attributedText = contentText;
    
    self.userPicImageView.frame = CGRectMake(20, 15, 45, 45);
    self.userNameLabel.frame = CGRectMake(80, 15, YB_SCREEN_WIDTH - 80 - 20, 30);
    CGSize contentSize = [self getContentLabelSize];
    self.mulContentLabel.frame = CGRectMake(80, CGRectGetMaxY(self.userNameLabel.frame), contentSize.width, contentSize.height);
    
    self.picImagesBackGroundView.frame = CGRectMake(80, CGRectGetMaxY(self.mulContentLabel.frame) + 5, YB_SCREEN_WIDTH - 80 - 80, self.headerViewData.picViewHeight);
    
    //图片布局
    CGFloat imagesSumWidth = YB_SCREEN_WIDTH - 80 - 80;
    CGFloat picGap = 5;
    CGFloat singlePicHeight = (imagesSumWidth - 2 * picGap) / 3;
    if (1 == self.headerViewData.picArr.count) {
        UIImageView *imageView = (UIImageView *)self.picImageViewArr[0];
        imageView.frame = CGRectMake(0, 0, self.headerViewData.picViewHeight, self.headerViewData.picViewHeight);
        [self.picImagesBackGroundView addSubview:imageView];
    }
    else
    {
        CGFloat imageW = singlePicHeight;
        CGFloat imageH = imageW;
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        
        for (int m = 1;m <= self.headerViewData.picArr.count;m++) {
            
            if (m <= 3 ) {
                imageX = (m - 1) * imageW + (m - 1) * picGap;
            }
            else if(m > 3 && m <= 6)
            {
                imageX = (m - 4) * imageW + (m - 4) * picGap;
                imageY = imageH + picGap;
            }
            else
            {
                imageX = (m - 7) * imageW + (m - 7) * picGap;
                imageY = 2 * imageH + 2 * picGap;
            }
            
            UIImageView *imageView = (UIImageView *)self.picImageViewArr[m-1];
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [self.picImagesBackGroundView addSubview:imageView];
        }
    }
    
    self.timeAndSourceLabel.frame = CGRectMake(80, self.bounds.size.height - 30, YB_SCREEN_WIDTH - 80 - 80, 25);
    self.operateMoreImageView.frame = CGRectMake(YB_SCREEN_WIDTH - 30 - 20, self.bounds.size.height - 30, 25, 25);
    
    self.userNameLabel.text = self.headerViewData.userName;
    [self.userPicImageView sd_setImageWithURL:[NSURL URLWithString:self.headerViewData.userPic] placeholderImage:[UIImage imageNamed:@"default_user_image"]];
//    self.mulContentLabel.text = self.headerViewData.content;
    self.timeAndSourceLabel.text = self.headerViewData.time;
}

- (CGSize)getContentLabelSize {
    if ([self.headerViewData.content length] > 0) {
        float maxWidth = YB_SCREEN_WIDTH - 80 - 20;
        /*
        CGRect textRect = [self.headerViewData.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}
                           context:nil];
         textRect.size.height = ceilf(textRect.size.height);
         textRect.size.width = ceilf(textRect.size.width);
         */
        CGSize contentSize = CGSizeMake(maxWidth, 8000);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:contentSize text:self.mulContentLabel.attributedText];
        self.mulContentLabel.textLayout = layout;
        CGFloat introHeight = layout.textBoundingSize.height;
         return CGSizeMake(maxWidth + 5, introHeight + 5);
    } else {
        return CGSizeZero;
    }
}

//点赞和评论按钮的点击事件
-(void)operateMore:(UITapGestureRecognizer *)sender
{
    NSLog(@"-(void)operateMore:(UITapGestureRecognizer *)sender");
}

//用户图片的点击事件、用户名称的点击事件
-(void)userDetailTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"-(void)userDetailTapped:(UITapGestureRecognizer *)sender");
    if ([self.delegate respondsToSelector:@selector(jumpToUserDetailOnHeaderView:)]) {
        [self.delegate jumpToUserDetailOnHeaderView:self.headerViewData.userId];
    }
}

@end
