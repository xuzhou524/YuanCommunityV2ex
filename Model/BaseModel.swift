//
//  BaseModel.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/7/1.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit
import ObjectMapper
import Ji
import Moya

class BaseModel: NSObject {

}
class BaseJsonModel: Mappable {
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
}
protocol BaseHtmlModelProtocol {
    init(rootNode:JiNode)
}

/// 实现这个协议的类，可用于Moya自动解析出这个类的model的对象数组
protocol HtmlModelArrayProtocol {
    static func createModelArray(ji:Ji) -> [Any]
}

/// 实现这个协议的类，可用于Moya自动解析出这个类的model的对象
protocol HtmlModelProtocol {
    static func createModel(ji:Ji) -> Any
}

