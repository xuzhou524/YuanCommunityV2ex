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
            return UIColor.init(lightColorStr: "EBEBEB", darkColor: "191919")
        }
    }
    
    static var sepColor : UIColor{
        get{
            return UIColor.init(lightColorStr: "DCDCDC", darkColor: "DCDCDC")
        }
    }
    
    static var linksColor : UIColor {
        get {
            return UIColor.init(lightColorStr: "778087", darkColor: "778087")
        }
    }
    
    static var noticePointColor : UIColor {
        get {
            return UIColor.init(lightColorStr: "CF4647", darkColor: "CF4647")
        }
    }
    
    static var buttonBackgroundColor : UIColor {
        get {
            return UIColor.init(lightColorStr: "55ACEE", darkColor: "55ACEE")
        }
    }
    
    static var leftNodeTintColor : UIColor {
        get {
            return UIColor.init(lightColorStr: "333333", darkColor: "EBEBEB")
        }
    }

    static var topicListDateColor : UIColor{
        get{
            return UIColor.init(lightColorStr: "ADADAD", darkColor: "ADADAD")
        }
    }

}
