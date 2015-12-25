//
//  FCSlideScrollViewController.h
//  YBExample
//
//  Created by wangzhaomin on 15/12/24.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCSlideScrollViewController;

@protocol FCSlideScrollViewDelegate <NSObject>

@required
- (NSMutableArray *)feedbackDataSourceArray;

@optional
//返回scrollview的宽和高
- (CGSize)feedbackDataSourceWidthAndHeight;
@end

@interface FCSlideScrollViewController : UIViewController

@property (nonatomic, assign) id<FCSlideScrollViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPageControl;

//返回当前点的是哪张图片
- (NSInteger)feedbackCurrentClickPicture;

@end
