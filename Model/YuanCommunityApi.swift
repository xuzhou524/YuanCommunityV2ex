//
//  YuanCommunityApi.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/27.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import Moya

enum YuanCommunityApi {
    //获取首页列表
    case topicList(tab: String?, page: Int)
    //获取我的收藏帖子列表
    case favoriteList(page: Int)
    //获取节点主题列表
    case nodeTopicList(nodeName: String, page:Int)
    
    case getUserInfo(username:String)
    case thankReply(replyId:String, once:String)
    case thankTopic(topicId:String, once:String)
}

extension YuanCommunityApi: XZTargetType {

    var method: Moya.Method {
        switch self {
        case .thankReply: return .post
        case .thankTopic: return .post
        default:
            return .get
        }
                
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .topicList(tab, page):
            if tab == "all" && page > 0 {
                //只有全部分类能翻页
                return ["p": page]
            }
            return ["tab": tab ?? "all"]
        case let .favoriteList(page):
            return ["p": page]
        case let .nodeTopicList(_, page):
            return ["p": page]
        case let .getUserInfo(username):
            return ["username": username]
        case let .thankReply( _ , once):
            return ["once": once]
        case let .thankTopic( _ , once):
            return ["once": once]
        }
        
    }
    
    var path: String {
        switch self {
        case let .topicList(tab, page):
            if tab == "all" && page > 0 {
                return "/recent"
            }
            return "/"
        case .favoriteList:
            return "/my/topics"
        case let .nodeTopicList(nodeName, _):
            return "/go/\(nodeName)"
        case .getUserInfo:
            return "/api/members/show.json"
        case let .thankReply(replyId, _):
            return "/thank/reply/\(replyId)"
        case let .thankTopic(replyId, _):
            return "/thank/topic/\(replyId)"
        }
    }
    
    
}
