//
//  String+Avatar.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/23.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

extension String {
    var avatarString:String {
        if self.hasPrefix("http") {
            return self
        }
        else{
            //某些时期 V2ex 使用 //: 自适应scheme ，需要加上https
            return "https:" + self
        }
    }
}
