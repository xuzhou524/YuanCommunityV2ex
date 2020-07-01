//
//  LDTabBarController.m
//  LDTaBar
//
//  Created by gozap on 2017/9/7.
//  Copyright © 2017年 com.longdai. All rights reserved.
//

#import "LDTabBarController.h"

@interface LDTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValue:[LDTabBar new] forKey:@"tabBar"];
    
    self.delegate = self;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 判断本次点击的UITabBarItem是否和上次的一样
    if (self.selectedIndex == 0) {
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
        if (item == self.lastItem && timeInterval < 0.2) { // 一样就发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LDTabBarDidClickNotification" object:nil userInfo:nil];
        }
        // 将这次点击的UITabBarItem赋值给属性
        self.lastSelectedDate = [NSDate date];
        self.lastItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
