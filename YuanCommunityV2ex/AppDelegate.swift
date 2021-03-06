//
//  AppDelegate.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/6/30.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit
import SVProgressHUD

import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GADFullScreenContentDelegate {

    var window: UIWindow?
    var appOpenAd: GADAppOpenAd?
    
    var adWindow: UIWindow?
    var adViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        URLProtocol.registerClass(XZWebViewImageProtocol.self)

        let tabBarController = LDTabBarController()
        
        let vc1 = HomeViewController()
        let nav1 = LDNavigationController(rootViewController: vc1)
        
        nav1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "tabar_home"), selectedImage: UIImage(named: "tabar_home_sel")?.withRenderingMode(.alwaysOriginal))

//        let vc2 = MenuViewController()
//        let nav2 = LDNavigationController(rootViewController: vc2)
//        nav2.tabBarItem = UITabBarItem(title: "分类", image: UIImage(named: "tabar_class"), selectedImage: UIImage(named: "tabar_class_sel")?.withRenderingMode(.alwaysOriginal))
        
        let vc2 = BranchViewController()
        let nav2 = LDNavigationController(rootViewController: vc2)
        nav2.tabBarItem = UITabBarItem(title: "节点", image: UIImage(named: "tabar_class"), selectedImage: UIImage(named: "tabar_class_sel")?.withRenderingMode(.alwaysOriginal))
        
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
        self.window?.frame=UIScreen.main.bounds
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabBarController
        XZClient.sharedInstance.window = self.window
        XZClient.sharedInstance.centerTabBarController = tabBarController
        
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setContainerView(self.window!)

        #if DEBUG
        #else
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let key:String = (UserDefaults.standard.object(forKey: "com.xuzhou.advertising") ?? "0") as! String
        if Int(key) == 0 {
            self.tryToPresentAd()
        }
        #endif
        
        return true
    }
    
    func requestAppOpenAd() {
        self.appOpenAd = nil
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-9353975206269682/6262169139", request: GADRequest(), orientation: .portrait) { (appOpenAd, error) in
            if (error == nil) {
                self.appOpenAd = appOpenAd
                self.appOpenAd?.fullScreenContentDelegate = self
                self.tryToPresentAd()
            }else{
                print(error ?? "")
                return;
            }
        }
    }
    
    func tryToPresentAd() {
        if (self.appOpenAd != nil) {
            adViewController = UIViewController()
            
            adWindow = UIWindow.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            adWindow?.rootViewController = adViewController
            adWindow?.rootViewController?.view.backgroundColor = UIColor.clear;
            adWindow?.rootViewController?.view.isUserInteractionEnabled = false;
            adWindow?.isHidden = false
            adWindow?.alpha = 1
            
            self.appOpenAd?.present(fromRootViewController: (adWindow?.rootViewController)!)

        }else{
            self.requestAppOpenAd()
        }
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timered), userInfo: nil, repeats: true)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.hide()
    }

    @objc func timered() {
        self.hide()
    }
    
    func hide() {
        adViewController?.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.adWindow?.alpha = 0;
        } completion: { (e) in
            self.adWindow?.isHidden = true
        }
    }
}
