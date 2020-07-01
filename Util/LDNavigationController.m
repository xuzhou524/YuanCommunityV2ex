//
//  LDNavigationController.m
//  LDTaBar
//
//  Created by gozap on 2017/9/7.
//  Copyright © 2017年 com.longdai. All rights reserved.
//

#import "LDNavigationController.h"
#import "LDColor.h"

#define LDFont2(x) [UIFont fontWithName:@"Helvetica" size:(x)]

@interface LDNavigationController ()

@end

@implementation LDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigationBar 背景颜色（或者可以用图片
    [self.navigationBar setBackgroundImage:[LDColor createImageWithColor:[LDColor whiteColor]]
                             forBarMetrics:UIBarMetricsDefault];
    //navigationBar Title 样式
    [self.navigationBar setTitleTextAttributes:@{
                                                  NSFontAttributeName : LDFont2(18),
                                                  NSForegroundColorAttributeName : [LDColor ldgray69]
                                                  }];
        
    [self.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark 返回按钮
-(void)popself {
    [self popViewControllerAnimated:YES];
}

#pragma mark 创建返回按钮
-(UIBarButtonItem *)createBackButton {
    UIButton *liftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [liftBtn setImage:[UIImage imageNamed:@"ic_return_left"] forState:UIControlStateNormal];
    liftBtn.imageEdgeInsets = UIEdgeInsetsMake( 2, 0, 2, 5);
    [liftBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * liftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftBtn];
    return liftButtonItem;
}

#pragma mark 重写方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断子控制器的数量
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
    // 修改tabBra的frame  适配iPhone X Push过程中TabBar位置上移
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    // 判断子控制器的数量
    if (viewControllers.count > 1) {
        UIViewController * lastViewController = viewControllers.lastObject;
        lastViewController.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
    for (UIViewController * viewController in viewControllers) {
        if (viewController.navigationItem.leftBarButtonItem == nil) {
            viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
