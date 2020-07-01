//
//  XZSwiftColor.swift
//  Convenient-Swift-Swift
//
//  Created by gozap on 16/3/2.
//  Copyright © 2016年 xuzhou. All rights reserved.
//

import UIKit

func colorWith255RGB(_ r:CGFloat , g:CGFloat, b:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255)
}
func colorWith255RGBA(_ r:CGFloat , g:CGFloat, b:CGFloat,a:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255)
}

func createImageWithColor(_ color:UIColor) -> UIImage{
    return createImageWithColor(color, size: CGSize(width: 1, height: 1))
}
func createImageWithColor(_ color:UIColor,size:CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    context?.setFillColor(color.cgColor);
    context?.fill(rect);
    
    let theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage!;
}

class XZSwiftColor: UIColor{
    
    static var backgroudColor : UIColor{
        get{
            return colorWith255RGB(242, g: 243, b: 245);
        }
    }
    
    static var sepColor : UIColor{
        get{
            return colorWith255RGB(220, g: 220, b: 220);
        }
    }
    
    static var linksColor : UIColor {
        get {
            return colorWith255RGB(119, g: 128, b: 135)
        }
    }
    
    static var noticePointColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
    
    static var buttonBackgroundColor : UIColor {
        get {
            return colorWith255RGB(85, g: 172, b: 238)
        }
    }
    
    static var leftNodeTintColor : UIColor {
        get {
            return colorWith255RGB(51, g: 51, b: 51)
        }
    }

    static var topicListDateColor : UIColor{
        get{
            return colorWith255RGB(173, g: 173, b: 173);
        }
    }

}
