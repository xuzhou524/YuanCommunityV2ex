//
//  V2Client.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/15/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class V2Client: NSObject {
    static let sharedInstance = V2Client()
    
    var window : UIWindow? = nil
    
    var centerTabBarController : LDTabBarController? = nil
    
    // 当前程序中，最上层的 NavigationController
    var topNavigationController : UINavigationController {
        get{
            let rooVC = centerTabBarController?.viewControllers?[centerTabBarController?.selectedIndex ?? 0]
            return V2Client.getTopNavigationController(rooVC as! UINavigationController)
        }
    }
    
    fileprivate class func getTopNavigationController(_ currentNavigationController:UINavigationController) -> UINavigationController {
        if let topNav = currentNavigationController.visibleViewController?.navigationController{
            if topNav != currentNavigationController && topNav.isKind(of: UINavigationController.self){
                return getTopNavigationController(topNav)
            }
        }
        return currentNavigationController
    }
}
