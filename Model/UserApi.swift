//
//  UserApi.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/27.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

enum UserApi {
    case getUserInfo(username:String)
}

extension UserApi: V2EXTargetType {
    var path: String {
        switch self {
        case .getUserInfo:
            return "/api/members/show.json"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .getUserInfo(username):
            return ["username": username]
        }
    }
}
