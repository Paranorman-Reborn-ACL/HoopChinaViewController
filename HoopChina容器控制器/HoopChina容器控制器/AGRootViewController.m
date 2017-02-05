//
//  AGRootViewController.m
//  HoopChina容器控制器
//
//  Created by Paranorman on 2017/2/5.
//  Copyright © 2017年 Paranorman. All rights reserved.
//

#import "AGRootViewController.h"
#import "AGChildViewController.h"

static const CGFloat titleHeight =40; //标题导航栏的高度
static const CGFloat contentY = 20;   //标题导航栏的起始OriginY

@interface AGRootViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *titleScrollView; //设置title的scrollView
@property(nonatomic, strong) UIScrollView *contentScrollView; //设置子视图的ScrollView

@end

@implementation AGRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@  %@--- %s", self.view,self.view.backgroundColor,__func__);

    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;

    //设置标题导航栏
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentY, viewWidth, titleHeight)];
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_titleScrollView];
    
    CGFloat buttonWidth = 100;
    for (int i = 0 ; i < 8; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, _titleScrollView.frame.size.height)];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"NBA-%d", i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:button];
    }
    [_titleScrollView setContentSize:CGSizeMake(_titleScrollView.subviews.count * buttonWidth, 0)];
    
    
    //设置内容ScrollView
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScrollView.frame), viewWidth, viewHeight - titleHeight)];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
    
    for (int i = 0; i < 8; i++) {
        AGChildViewController *childVC = [[AGChildViewController alloc] init];
        [self addChildViewController:childVC];
    }
    _contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * viewWidth, 0);
     [self scrollViewDidEndScrollingAnimation:_contentScrollView];
    [self scrollViewDidScroll:_contentScrollView];
}

//titleScroll按钮点击
- (void)buttonClick:(UIButton *)button {
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat offsetX = button.tag * viewWidth;
    [_contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x / self.view.frame.size.width;
    NSInteger index = contentOffsetX;
    CGFloat leftScale = contentOffsetX - index; //越来越大
    CGFloat rightScale = 1 - leftScale;
    if (index < _titleScrollView.subviews.count - 1) {
        UIButton *leftButton = _titleScrollView.subviews[index];
        UIButton *rightButton = _titleScrollView.subviews[index+1];
        NSLog(@" %f %f", leftScale, rightScale);
        UIColor *leltTintColor = [UIColor colorWithRed:1*(1-leftScale) green:0 blue:1*leftScale alpha:1];
        [leftButton setTitleColor:leltTintColor forState:UIControlStateNormal];
        
        UIColor *rightTintColor = [UIColor colorWithRed:1*(1-rightScale) green:0 blue:1*rightScale alpha:1];
        [rightButton setTitleColor:rightTintColor forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@" %s", __func__);
    
    CGFloat width = self.view.frame.size.width;
    NSInteger index = scrollView.contentOffset.x/width;
    AGChildViewController *showViewController = self.childViewControllers[index];
    if (![showViewController isViewLoaded]) {
        //viewDidLoad
        [showViewController.view setFrame:CGRectMake(index *width, 0, width, _contentScrollView.frame.size.height)];
        showViewController.label.text = [NSString stringWithFormat:@" %zd", index];
        [self.contentScrollView addSubview:showViewController.view];
    }
    
    //设置titleScorllView的居中滚动
    UIButton *button = _titleScrollView.subviews[index];
    CGFloat distanceX = button.center.x - width/2;
    CGPoint contentOffset = CGPointMake(distanceX, 0);
    //超出左边边界
    if (distanceX < 0) contentOffset = CGPointMake(0, 0);
    //左划最大距离
    CGFloat maxDistance = self.titleScrollView.contentSize.width - width;
    //超出右边边界
    if (distanceX > maxDistance) contentOffset = CGPointMake(maxDistance, 0);
    
    [self.titleScrollView setContentOffset:contentOffset animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
