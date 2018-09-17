//
//  YBAlbumTextMediaCell.h
//  YBWechat
//
//  Created by 易博 on 2018/6/15.
//  Copyright © 2018年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumCellModel.h"

//展示文本+图片、文本+视频、仅图片、仅视频的朋友圈内容
@interface YBAlbumTextMediaCell : UITableViewCell

@property (nonatomic,strong) AlbumCellModel *model;

@end
