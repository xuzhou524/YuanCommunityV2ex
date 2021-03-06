//
//  SVProgressHUD+Extension.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/23.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import SVProgressHUD
extension SVProgressHUD {
    /**
     替换 SVProgressHUD 控件中弹框停留时间的计算方法，让汉字比字符停留更久的时间
     不然 abcde 和 我是大帅哥 停留的时间一样,  就感觉隐藏的太快了
     */
    func displayDurationForString(_ string:String) -> TimeInterval {
        return min(Double(string.utf8.count) * 0.06 + 0.5, 5.0)
    }
}
