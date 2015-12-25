//
//  FCSlideScrollViewController.m
//  YBExample
//
//  Created by wangzhaomin on 15/12/24.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "FCSlideScrollViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FCSlideScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *leftImageView, *rightImageView, *midImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  展示的图片
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

/**
 *  scrollview的宽和高
 */
@property (nonatomic, assign) NSInteger scrollViewWidth, scrollViewHeight;

@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation FCSlideScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollViewWidth = kScreenWidth;
    _scrollViewHeight = self.scrollViewWidth * 0.5625;
    
    if (_delegate && [_delegate respondsToSelector:@selector(feedbackDataSourceArray)]) {
        if (_delegate && [_delegate respondsToSelector:@selector(feedbackDataSourceWidthAndHeight)]) {
            CGSize sizeX = [_delegate feedbackDataSourceWidthAndHeight];
            self.scrollViewWidth = sizeX.width;
            self.scrollViewHeight = sizeX.height;
        }
        self.dataSourceArray = [NSMutableArray arrayWithArray:[_delegate feedbackDataSourceArray]];
        [self configureScrollView];
        [self configureImageView];
        if (self.isPageControl) {
            [self configurePageControll];
        }
    }
}


- (void)configureScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight))];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.scrollViewWidth, self.scrollViewHeight);
    _scrollView.contentOffset = CGPointMake(self.scrollViewWidth, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
}

- (void)configureImageView {
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight)];
    self.midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollViewWidth * 2, 0, self.scrollViewWidth, self.scrollViewHeight)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (self.dataSourceArray.count != 0) {
        self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray.lastObject];
        self.midImageView.image = [UIImage imageNamed:self.dataSourceArray.firstObject];
        self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[1]];
    }
    [self.scrollView addSubview:_leftImageView];
    [self.scrollView addSubview:_midImageView];
    [self.scrollView addSubview:_rightImageView];
}

- (void)scrolViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (self.dataSourceArray.count != 0) {
        if (offset >= 2 * self.scrollViewWidth) {
            scrollView.contentOffset = CGPointMake(self.scrollViewWidth, 0);
            self.currentIndex++;
            if (self.currentIndex == self.dataSourceArray.count - 1) {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex - 1]];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray.firstObject];
                self.pageControl.currentPage = self.currentIndex;
                self.currentIndex = -1;
            } else if (self.currentIndex == self.dataSourceArray.count) {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray.lastObject];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray.firstObject];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[1]];
                self.pageControl.currentPage = 0;
                self.currentIndex = 0;
            } else if (self.currentIndex == 0) {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray.lastObject];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex + 1]];
                self.pageControl.currentPage = self.currentIndex;
            } else {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex - 1]];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex + 1]];
                self.pageControl.currentPage = self.currentIndex;
            }
        }
        
        if (offset <= 0) {
            scrollView.contentOffset = CGPointMake(self.scrollViewWidth, 0);
            self.currentIndex--;
            if (self.currentIndex == -2) {
                self.currentIndex = self.currentIndex - 2;
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray[self.dataSourceArray.count - 1]];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray.lastObject];
                self.pageControl.currentPage = self.currentIndex;
            } else if (self.currentIndex == -1) {
                self.currentIndex = self.dataSourceArray.count - 1;
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex - 1]];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray.firstObject];
                self.pageControl.currentPage = self.currentIndex;
            } else if (self.currentIndex == 0) {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray.lastObject];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex - 1]];
                self.pageControl.currentPage = self.currentIndex;
            } else {
                self.leftImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex - 1]];
                self.midImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex]];
                self.rightImageView.image = [UIImage imageNamed:self.dataSourceArray[self.currentIndex + 1]];
                self.pageControl.currentPage = self.currentIndex;
            }
        }
    }
}

- (void)configurePageControll {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollViewHeight - 20, _scrollViewWidth, 20)];
    _pageControl.numberOfPages = self.dataSourceArray.count;
    _pageControl.currentPageIndicatorTintColor  = [UIColor redColor];
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
}

- (NSInteger)feedbackCurrentClickPicture {
    return self.pageControl.currentPage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
