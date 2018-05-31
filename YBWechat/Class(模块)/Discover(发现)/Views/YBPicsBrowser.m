//
//  YBPicsBrowser.m
//  YBWechat
//
//  Created by 易博 on 2018/5/31.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBPicsBrowser.h"

//浏览图片时，图片之间的间距
#define PicsGap 10.0

@interface YBPicsBrowser()<UIScrollViewDelegate>
//
@property (nonatomic,strong) UIScrollView *picScrollView;
//存放imageview的数组
@property (nonatomic,strong) NSMutableArray *picImageViewArr;
//页控制器
@property (nonatomic,strong) UIPageControl *picPageControl;
@end

@implementation YBPicsBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.picScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-PicsGap, 0, YB_SCREEN_WIDTH + 2 * PicsGap, YB_SCREEN_HEIGHT)];
    self.picScrollView.backgroundColor = [UIColor blackColor];
    self.picScrollView.pagingEnabled = YES;
    self.picScrollView.delegate = self;
    [self addSubview:self.picScrollView];
    
    self.picPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(YB_SCREEN_WIDTH / 3, YB_SCREEN_HEIGHT - 40, YB_SCREEN_WIDTH / 3, 30)];
    self.picPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.picPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.picPageControl.userInteractionEnabled = NO;
    [self addSubview:self.picPageControl];
    
    self.picImageViewArr = [[NSMutableArray alloc]init];
}

-(void)setPicArr:(NSArray *)picArr
{
    _picArr = picArr;
    
    //清空原有图片数组
    [self.picImageViewArr removeAllObjects];
    for (UIView *subImageView in self.picScrollView.subviews) {
        if (9999 == subImageView.tag) {
            [subImageView removeFromSuperview];
        }
    }
    
    self.picPageControl.currentPage = 0;
    self.picPageControl.numberOfPages = self.picArr.count;
    
    //仅有一张图片时，隐藏分页控制器
    if (self.picArr.count < 2) {
        self.picPageControl.hidden = YES;
    }
    else
    {
        self.picPageControl.hidden = NO;
    }
    
    //picScrollView的可滚动范围
//    CGFloat contentWidth = self.picArr.count < 2 ? YB_SCREEN_WIDTH : YB_SCREEN_WIDTH * self.picArr.count + PicsGap * (self.picArr.count - 1);
    CGFloat contentWidth = (YB_SCREEN_WIDTH + 2 * PicsGap) * self.picArr.count;
    self.picScrollView.contentSize = CGSizeMake(contentWidth, 0);
    
    for (int i = 0;i < self.picArr.count;i++) {
        UIImageView *picImageView = [[UIImageView alloc]init];
        picImageView.userInteractionEnabled = YES;
        [picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.picArr[i]]] placeholderImage:[UIImage imageNamed:@"mine_album"]];
        [self.picImageViewArr addObject:picImageView];
        
        //添加点击事件
        UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [picImageView addGestureRecognizer:picTap];
    }
    
    [self setAutoLayout];
}

-(void)setAutoLayout
{
    CGFloat imageW = YB_SCREEN_WIDTH;
    CGFloat imageH = 0;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageItemW = YB_SCREEN_WIDTH + 2 * PicsGap;
    
    for (int i = 0;i < self.picImageViewArr.count;i++) {
        imageX = imageItemW * i;
        UIImageView *picImageView = (UIImageView *)[self.picImageViewArr objectAtIndex:i];
        if ((picImageView.image.size.height / picImageView.image.size.width) >= YB_SCREEN_RATIO) {
            //图片实际的高宽比大于或者等于屏幕的高宽比，填充整个屏幕，上下无黑边
            imageH = YB_SCREEN_HEIGHT;
        }
        else
        {
            //图片实际的高宽比小于屏幕的高宽比，屏幕上下有黑边
            imageH = (picImageView.image.size.height / picImageView.image.size.width) * imageW;
            imageY = (YB_SCREEN_HEIGHT - imageH) / 2;
        }

        picImageView.frame = CGRectInset(CGRectMake(imageX, imageY, imageItemW, imageH), PicsGap, 0);
        //此tag是清空子视图时使用
        picImageView.tag = 9999;
        [self.picScrollView addSubview:picImageView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据contentOffset计算页数
    NSLog(@"scrollViewDidEndDecelerating");
    
    NSInteger page = scrollView.contentOffset.x / YB_SCREEN_WIDTH;
    self.picPageControl.currentPage = page;
}

-(void)hide
{
    [self removeFromSuperview];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)showAtPage:(NSInteger)page
{
    self.picPageControl.currentPage = page;
    [self.picScrollView setContentOffset:CGPointMake(page * (YB_SCREEN_WIDTH + 2 * PicsGap), 0) animated:NO];
    [self show];
}

@end
