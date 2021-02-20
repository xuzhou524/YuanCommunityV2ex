//
//  V2ex+Define.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/12.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import DeviceKit

//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
//屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
//NavagationBar高度
let NavigationBarHeight:CGFloat = {
    if UIDevice.current.isIphoneX {
        return 88
    }
    return 64
}()
//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Mobile/15E148 Safari/604.1"
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]


//站点地址,客户端只有https,禁用http
let V2EXURL = "https://www.v2ex.com/"

let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale

func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

func v2Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

func v2ScaleFont(_ fontSize: CGFloat) -> UIFont{
    return v2Font(fontSize * CGFloat(XZStyle.sharedInstance.fontScale))
}


extension UIDevice {
    var isIphoneX: Bool {
        get {
            return Device.current.isOneOf(Device.allXSeriesDevices + Device.allSimulatorXSeriesDevices)
        }
    }
}

extension UITableView {
    func cancelEstimatedHeight(){
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }
}

