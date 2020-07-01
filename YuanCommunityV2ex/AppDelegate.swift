//
//  AppDelegate.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/6/30.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        URLProtocol.registerClass(XZWebViewImageProtocol.self)

        let tabBarController = LDTabBarController()
        
        let vc1 = MainViewController()
        let nav1 = LDNavigationController(rootViewController: vc1)
        
        nav1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "tabar_home"), selectedImage: UIImage(named: "tabar_home_sel")?.withRenderingMode(.alwaysOriginal))

        let vc2 = RightViewController()
        let nav2 = LDNavigationController(rootViewController: vc2)
        nav2.tabBarItem = UITabBarItem(title: "分类", image: UIImage(named: "tabar_class"), selectedImage: UIImage(named: "tabar_class_sel")?.withRenderingMode(.alwaysOriginal))
        
        let vc4 = UserViewController()
        let nav4 = LDNavigationController(rootViewController: vc4)
        nav4.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "tabar_me"), selectedImage: UIImage(named: "tabar_me_sel")?.withRenderingMode(.alwaysOriginal))
         tabBarController.viewControllers = [nav1,nav2,nav4]
        
        // 设置字体大小
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)], for: UIControl.State.normal)
        // 设置字体偏移
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 0.0)
        // 设置图标选中时颜色
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().isTranslucent = false

        
        self.window = UIWindow();
        V2Client.sharedInstance.window = self.window
        self.window?.frame=UIScreen.main.bounds
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabBarController
        
        V2Client.sharedInstance.centerTabBarController = tabBarController
        
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setContainerView(self.window!)
        return true
    }
}

