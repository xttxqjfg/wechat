//
//  MomentsDataModel.m
//  YBWechat
//
//  Created by 易博 on 2018/5/29.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "MomentsDataModel.h"

#import "YBPraiseModel.h"
#import "YBCommendModel.h"

@implementation MomentsDataModel

-(instancetype)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.momentsId = [dict objectForKey:@"momentsId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"momentsId"]] : @"";
        
        self.userId = [dict objectForKey:@"userId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]] : @"";
        
        self.userName = [dict objectForKey:@"userName"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"userName"]] : @"匿名";
        
        self.userPic = [dict objectForKey:@"userPic"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"userPic"]] : @"";
        
        self.content = [dict objectForKey:@"momentsMulContent"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"momentsMulContent"]] : @"";
        
        self.time = [dict objectForKey:@"timeMark"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"timeMark"]] : @"";
        
        self.picArr = [dict objectForKey:@"picArr"] && [[dict objectForKey:@"picArr"] isKindOfClass:[NSArray class]] ? [[NSArray alloc]initWithArray:[dict objectForKey:@"picArr"]] : @[];
        
        //点赞用户数组
        if ([dict objectForKey:@"praiseArr"] && [[dict objectForKey:@"praiseArr"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dict objectForKey:@"praiseArr"]) {
                YBPraiseModel *praise = [[YBPraiseModel alloc]init];
                praise.userId = [dic objectForKey:@"userid"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"userid"]] : @"";
                praise.userName = [dic objectForKey:@"username"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]] : @"";
                [self.praiseArr addObject:praise];
            }
        }
        else
        {
            self.praiseArr = [[NSMutableArray alloc]initWithArray:@[]];
        }
        
        //评论数组
        if ([dict objectForKey:@"commendArr"] && [[dict objectForKey:@"commendArr"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dict objectForKey:@"commendArr"]) {
                YBCommendModel *commend = [[YBCommendModel alloc]init];
                commend.firstUserId = [dic objectForKey:@"firstUserId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"firstUserId"]] : @"";
                commend.firstUserName = [dic objectForKey:@"firstUserName"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"firstUserName"]] : @"";
                commend.secondUserId = [dic objectForKey:@"secondUserId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"secondUserId"]] : @"";
                commend.secondUserName = [dic objectForKey:@"secondUserName"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"secondUserName"]] : @"";
                commend.content = [dic objectForKey:@"commendMulStr"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"commendMulStr"]] : @"";
                [self.commendArr addObject:commend];
            }
        }
        else
        {
            self.commendArr = [[NSMutableArray alloc]initWithArray:@[]];
        }
        
        //设置组高度和cell高度
        self.cellHeight = 30.0;
        self.cellHeaderHeight = 15 + 30 + 10 + 30 + [self getContentLabelSize].height;
        
        //根据图片数组调整headview高度
        CGFloat imagesSumWidth = YB_SCREEN_WIDTH - 80 - 80;
        CGFloat picGap = 5;
        CGFloat singlePicHeight = (imagesSumWidth - 2 * picGap) / 3;
        if (self.picArr.count > 0) {
            //3排
            if (self.picArr.count > 6) {
                self.picViewHeight = singlePicHeight * 3 + picGap * 2;
            }
            //2排
            else if (self.picArr.count > 3)
            {
                self.picViewHeight = singlePicHeight * 2 + picGap;
            }
            //1张图片，长宽都占总宽的一半
            else if (1 == self.picArr.count) {
                self.picViewHeight = imagesSumWidth / 2;
            }
            //2张或者3张图片，一排
            else {
                self.picViewHeight = singlePicHeight;
            }
        }
        else
        {
            self.picViewHeight = 0;
        }
        self.cellHeaderHeight = self.cellHeaderHeight + self.picViewHeight;
    }
    return self;
}

- (CGSize)getContentLabelSize {
    if ([self.content length] > 0) {
        
        float maxWidth = YB_SCREEN_WIDTH - 80 - 20;
        CGSize contentSize = CGSizeMake(maxWidth, 8000);
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:self.content];
        contentText.yy_font = [UIFont systemFontOfSize:16];
        contentText.yy_lineSpacing = 5;
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:contentSize text:contentText];
        CGFloat introHeight = layout.textBoundingSize.height;
        return CGSizeMake(maxWidth + 5, introHeight + 5);
    } else {
        return CGSizeZero;
    }
}

@end
