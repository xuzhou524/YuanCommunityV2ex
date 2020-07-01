//
//  UIButton+Extension.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/05.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

extension UIButton {
    class func roundedButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        btn.backgroundColor  = XZSwiftColor.buttonBackgroundColor
        btn.titleLabel!.font = v2Font(14)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }
}
