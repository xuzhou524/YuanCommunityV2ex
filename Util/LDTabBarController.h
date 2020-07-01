//
//  LDTabBarController.h
//  LDTaBar
//
//  Created by gozap on 2017/9/7.
//  Copyright © 2017年 com.longdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDNavigationController.h"
#import "LDTabBar.h"
#import "LDColor.h"

@interface LDTabBarController : UITabBarController
@property (nonatomic, strong) UITabBarItem *lastItem;
@property (nonatomic, strong) NSDate *lastSelectedDate;

@end
