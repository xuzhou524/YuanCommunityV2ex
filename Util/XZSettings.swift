//
//  XZSettings.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/18.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

let keyPrefix =  "me.Aaron_xu.XZSettings."

class XZSettings: NSObject {
    static let sharedInstance = XZSettings()
    fileprivate override init(){
        super.init()
    }
    
    subscript<T : Codable>(key:String) -> T? {
        get {
            return UserDefaults.standard.object(forKey: keyPrefix + key) as? T
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyPrefix + key )
        }
    }
}

let Settings = XZSettings.sharedInstance
