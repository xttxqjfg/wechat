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
        self.praiseArr = [[NSMutableArray alloc]initWithArray:@[]];
        if ([dict objectForKey:@"praiseArr"] && [[dict objectForKey:@"praiseArr"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dict objectForKey:@"praiseArr"]) {
                YBPraiseModel *praise = [[YBPraiseModel alloc]init];
                praise.userId = [dic objectForKey:@"userid"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"]] : @"";
                praise.userName = [dic objectForKey:@"username"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]] : @"";
                [self.praiseArr addObject:praise];
            }
        }
        
        //评论数组
        self.commendArr = [[NSMutableArray alloc]initWithArray:@[]];
        if ([dict objectForKey:@"commendArr"] && [[dict objectForKey:@"commendArr"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in [dict objectForKey:@"commendArr"]) {
                YBCommendModel *commend = [[YBCommendModel alloc]init];
                commend.firstUserId = [dic objectForKey:@"firstUserId"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstUserId"]] : @"";
                commend.firstUserName = [dic objectForKey:@"firstUserName"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstUserName"]] : @"";
                commend.secondUserId = [dic objectForKey:@"secondUserId"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondUserId"]] : @"";
                commend.secondUserName = [dic objectForKey:@"secondUserName"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondUserName"]] : @"";
                commend.content = [dic objectForKey:@"commendMulStr"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"commendMulStr"]] : @"";
                commend.cellHeight = [self getCommendLabelSize:commend].height;
                [self.commendArr addObject:commend];
            }
        }
        
        //顶部间距+名称高度+时间标识高度+间距
        self.cellHeaderHeight = 15 + 30 + 30 + [self getContentLabelSize:self.content].height;
        
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
        
        //计算点赞区高度
        if (self.praiseArr.count > 0) {
            NSString *nameStr = @"";
            for (YBPraiseModel *model in self.praiseArr) {
                nameStr = [NSString stringWithFormat:@"%@, %@",nameStr,model.userName];
            }
            //去掉最前面的逗号和空格
            nameStr = [nameStr substringFromIndex:2];
            
            //15为冗余空间，包括点赞区箭头占用部分
            self.praiseViewHeight = [self getPraiseLabelSize:nameStr].height + 15;
        }
        else
        {
            //保留高度是为了显示箭头
            self.praiseViewHeight = 10.0;
        }
        
        self.cellHeaderHeight = self.cellHeaderHeight + self.praiseViewHeight;
    }
    return self;
}

- (CGSize)getContentLabelSize:(NSString *)contentStr {
    if ([contentStr length] > 0) {
        
        float maxWidth = YB_SCREEN_WIDTH - 80 - 20;
        CGSize contentSize = CGSizeMake(maxWidth, 8000);
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:contentStr];
        contentText.yy_font = [UIFont systemFontOfSize:16];
        contentText.yy_lineSpacing = 5;
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:contentSize text:contentText];
        CGFloat introHeight = layout.textBoundingSize.height;
        return CGSizeMake(maxWidth + 5, introHeight + 5);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)getPraiseLabelSize:(NSString *)contentStr {
    if ([contentStr length] > 0) {
        
        float maxWidth = YB_SCREEN_WIDTH - 80 - 20 - 20;
        CGSize contentSize = CGSizeMake(maxWidth, 8000);
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:contentStr];
        contentText.yy_font = [UIFont boldSystemFontOfSize:15];
        contentText.yy_lineSpacing = 5;
        
        NSMutableAttributedString *attachImage = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:[UIImage imageNamed:@"moment_praise_HL"] fontSize:15];
        [attachImage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        //插入到开头
        [contentText insertAttributedString:attachImage atIndex:0];
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:contentSize text:contentText];
        CGFloat introHeight = layout.textBoundingSize.height;
        return CGSizeMake(maxWidth + 5, introHeight + 5);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)getCommendLabelSize:(YBCommendModel *)model {
    if ([model.content length] > 0) {
        
        float maxWidth = YB_SCREEN_WIDTH - 80 - 20;
        CGSize contentSize = CGSizeMake(maxWidth, 8000);
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:model.content];
        contentText.yy_font = [UIFont systemFontOfSize:15];
        contentText.yy_lineSpacing = 5;
        
        if ([model.secondUserId length] > 0) {
            //说明回复格式
            NSMutableAttributedString *huifu = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@:",model.firstUserName,model.secondUserName]];
            huifu.yy_font = [UIFont systemFontOfSize:15];
            huifu.yy_lineSpacing = 5;
            
            //插入最前面
            [contentText insertAttributedString:huifu atIndex:0];
            
        }
        else
        {
            //否则是评论格式
            NSMutableAttributedString *pinglun = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",model.firstUserName]];
            pinglun.yy_font = [UIFont systemFontOfSize:15];
            pinglun.yy_lineSpacing = 5;
            
            //插入最前面
            [contentText insertAttributedString:pinglun atIndex:0];
        }
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:contentSize text:contentText];
        CGFloat introHeight = layout.textBoundingSize.height;
        return CGSizeMake(maxWidth + 5, introHeight + 5);
    } else {
        return CGSizeZero;
    }
}

@end
