//
//  V2EXSettings.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/18.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

let keyPrefix =  "me.Aaron_xu.V2EXSettings."

class V2EXSettings: NSObject {
    static let sharedInstance = V2EXSettings()
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

let Settings = V2EXSettings.sharedInstance
