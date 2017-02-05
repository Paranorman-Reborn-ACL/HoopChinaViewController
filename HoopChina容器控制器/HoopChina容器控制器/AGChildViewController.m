//
//  AGChildViewController.m
//  HoopChina容器控制器
//
//  Created by Paranorman on 2017/2/5.
//  Copyright © 2017年 Paranorman. All rights reserved.
//

#import "AGChildViewController.h"

@interface AGChildViewController ()

@end

@implementation AGChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@  %@--- %s", self.view,self.view.backgroundColor,__func__);
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    [_label setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_label];
}

@end
