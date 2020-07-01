//
//  XZClient.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/17.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class XZClient: NSObject {
    static let sharedInstance = XZClient()
    
    var window : UIWindow? = nil
    
    var centerTabBarController : LDTabBarController? = nil
    
    // 当前程序中，最上层的 NavigationController
    var topNavigationController : UINavigationController {
        get{
            let rooVC = centerTabBarController?.viewControllers?[centerTabBarController?.selectedIndex ?? 0]
            return XZClient.getTopNavigationController(rooVC as! UINavigationController)
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
