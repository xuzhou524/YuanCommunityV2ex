//
//  XZResponse.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/7/1.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit

enum ErrorCode:Int {
    case none = 0
    case twoFA ;
}

class XZResponse: NSObject {
    var success:Bool = false
    var message:String = "No message"
    init(success:Bool,message:String?) {
        super.init()
        self.success = success
        if let message = message{
            self.message = message
        }
    }
    init(success:Bool) {
        super.init()
        self.success = success
    }
}

class XZValueResponse<T>: XZResponse {
    var value:T?
    var code:ErrorCode = .none
    
    override init(success: Bool) {
        super.init(success: success)
    }
    
    override init(success:Bool,message:String?) {
        super.init(success:success)
        if let message = message {
            self.message = message
        }
    }
    convenience init(value:T,success:Bool) {
        self.init(success: success)
        self.value = value
    }
    convenience init(value:T,success:Bool,message:String? = nil, code:ErrorCode = .none) {
        self.init(value:value,success:success)
        if let message = message {
            self.message = message
        }
        self.code = code
    }
}
