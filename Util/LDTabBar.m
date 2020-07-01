//
//  LDTabBar.m
//  LDTaBar
//
//  Created by gozap on 2017/9/7.
//  Copyright © 2017年 com.longdai. All rights reserved.
//

#import "LDTabBar.h"
#import "LDColor.h"

@implementation LDTabBar

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (UITabBarItem * item in self.items) {
        //item.imageInsets = UIEdgeInsetsMake(-2.0, 0, 2.0, 0);
        item.titlePositionAdjustment = UIOffsetMake(0,-3);
    }
    
    for (UIControl * tabBarButton in self.subviews) {
        //设置上边的阴影效果
        if ([tabBarButton isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            for (UIView * view in tabBarButton.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UIImageView")]) {
                    view.layer.shadowOffset = CGSizeMake(2, 2);            //偏移距离
                    view.layer.shadowOpacity = 0.5;                        //不透明度
                    view.layer.shadowRadius = 3.0;                         //半径
                    view.layer.shadowColor = [LDColor grayColor].CGColor; //阴影颜色
                    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)].CGPath;
                }
                view.backgroundColor = [LDColor whiteColor];
            }
        }
        //设置每次点击的动画
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    for (UIView * view in tabBarButton.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")] || [view isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
            //需要实现的桢动画，这里根据需求自定义
            CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.05,@0.98,@1.0];
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去
            [view.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void) safeAreaInsetsDidChange{
    [super safeAreaInsetsDidChange];
    if(self.oldSafeAreaInsets.left != self.safeAreaInsets.left ||
       self.oldSafeAreaInsets.right != self.safeAreaInsets.right ||
       self.oldSafeAreaInsets.top != self.safeAreaInsets.top ||
       self.oldSafeAreaInsets.bottom != self.safeAreaInsets.bottom){
        self.oldSafeAreaInsets = self.safeAreaInsets;
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutSubviews];
    }
}

- (CGSize) sizeThatFits:(CGSize) size{
    CGSize s = [super sizeThatFits:size];
    if(@available(iOS 11.0, *)){
        CGFloat bottomInset = self.safeAreaInsets.bottom;
        if( bottomInset > 0 && s.height < 50) {
            s.height += bottomInset;
        }
    }
    return s;
}
@end
