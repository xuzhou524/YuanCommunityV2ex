//
//  HomeViewController.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/7/2.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "V2EX"
        // 创建PageStyle，设置样式
        let style = PageStyle()
        style.isTitleViewScrollEnabled = true
        style.titleMargin = 10
        style.titleInset = 12
        style.titleFont = v2Font(16)
        
        style.isShowCoverView = true
        style.coverViewBackgroundColor = XZSwiftColor.linksColor
        
        style.titleColor = XZSwiftColor.leftNodeTintColor
        style.titleSelectedColor = XZSwiftColor.white

        // 设置标题内容
        let titles = NSMutableArray()
        for item in MenuNodes {
            titles.add(item.nodeName as Any)
        }
        // 创建每一页对应的controller
        for i in 0..<titles.count {
            let controller = MainViewController()
            controller.index = i
            addChild(controller)
        }

        // 创建对应的DNSPageView，并设置它的frame
        let pageView = PageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 44 - UIApplication.shared.statusBarFrame.size.height), style: style, titles: titles as! [String], childViewControllers: children)
        view.addSubview(pageView)
    }
}
