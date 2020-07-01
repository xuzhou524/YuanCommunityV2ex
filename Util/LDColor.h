//
//  LDColor.h
//  LongDai
//
//  Created by gozap on 2017/11/17.
//  Copyright © 2017年 Gozap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDColor : UIColor
+ (UIColor *)colorWithR255:(NSInteger)red G255:(NSInteger)green B255:(NSInteger)blue A255:(NSInteger)alpha;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size;


+ (UIColor *)backgroudColor;
+ (UIColor *)separatorColor;

+ (UIColor *)ldgray69;

@end
