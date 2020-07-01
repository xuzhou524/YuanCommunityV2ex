//
//  TopicApi.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/27.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import Moya

enum TopicApi {
    //感谢回复
    case thankReply(replyId:String, once:String)
    case thankTopic(topicId:String, once:String)
}

extension TopicApi: V2EXTargetType {
    var method: Moya.Method {
        switch self {
        case .thankReply: return .post
        case .thankTopic: return .post
        }
    }
    var parameters: [String : Any]?{
        switch self {
        case let .thankReply( _ , once):
            return ["once": once]
        case let .thankTopic( _ , once):
            return ["once": once]
        }
    }
    var path: String {
        switch self {
        case let .thankReply(replyId, _):
            return "/thank/reply/\(replyId)"
        case let .thankTopic(replyId, _):
            return "/thank/topic/\(replyId)"
        }
    }
}
