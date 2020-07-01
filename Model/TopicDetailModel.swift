//
//  TopicDetailModel.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/25.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

import Alamofire
import Ji
import YYText
import Kingfisher
class TopicDetailModel:NSObject,BaseHtmlModelProtocol {
    var topicId:String?
    
    var avata: String?
    var nodeName: String?
    var node: String?
    
    var userName: String?
    
    var topicTitle: String?
    var topicContent: String?
    var date: String?
    var favorites: String?
    
    var topicCommentTotalCount: String?
    
    var token:String?

    var commentTotalPages:Int = 1
    
    override init() {
        
    }
    required init(rootNode: JiNode) {
        let node = rootNode.xPath("./div[1]/a[2]").first
        self.nodeName = node?.content
        
        let nodeUrl = node?["href"]
        let index = nodeUrl?.range(of: "/", options: .backwards, range: nil, locale: nil)
        if let temp = nodeUrl?[index!.upperBound...] {
            self.node = String(temp)
        }
        
        self.avata = rootNode.xPath("./div[1]/div[1]/a/img").first?["src"]
        
        self.userName = rootNode.xPath("./div[1]/small/a").first?.content
        
        self.topicTitle = rootNode.xPath("./div[1]/h1").first?.content
        
        self.topicContent = rootNode.xPath("./div[@class='cell']/div").first?.rawContent
        if self.topicContent == nil {
            self.topicContent = ""
        }
        // Append
        let appendNodes = rootNode.xPath("./div[@class='subtle']") ;
        
        for node in appendNodes {
            if let content =  node.rawContent {
                self.topicContent! += content
            }
        }
        
        
        self.date = rootNode.xPath("./div[1]/small/text()[2]").first?.content
        
        self.favorites = rootNode.xPath("./div[3]/div/span").first?.content
        
        let token = rootNode.xPath("div/div/a[@class='op'][1]").first?["href"]
        if let token = token {
            let array = token.components(separatedBy: "?t=")
            if array.count == 2 {
                self.token = array[1]
            }
        }
    }
}


//MARK: -  Request
extension TopicDetailModel {
    class func getTopicDetailById(
        _ topicId: String,
        completionHandler: @escaping (XZValueResponse<(TopicDetailModel?,[TopicCommentModel])>) -> Void
        )->Void{
        
        let url = V2EXURL + "t/" + topicId + "?p=1"
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
            if response.result.isFailure {
                completionHandler(XZValueResponse(success: false, message: response.result.error?.localizedFailureReason ?? "请求失败"))
                return
            }
            var topicModel: TopicDetailModel? = nil
            var topicCommentsArray : [TopicCommentModel] = []
            if  let jiHtml = response.result.value {
                //获取帖子内容
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]")?.first{
                    topicModel = TopicDetailModel(rootNode: aRootNode);
                    topicModel?.topicId = topicId
                }
                
                //获取评论
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[attribute::id]"){
                    for aNode in aRootNode {
                        topicCommentsArray.append(TopicCommentModel(rootNode: aNode))
                    }
                }
                
                //获取评论总数
                if let commentTotalCount = jiHtml.xPath("//*[@id='Wrapper']/div/div[3]/div[1]/span") {
                    topicModel?.topicCommentTotalCount = commentTotalCount.first?.content
                }
                
                //获取页数总数
                if let commentTotalPages = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[last()]/a[last()]")?.first?.content {
                    if let pages = Int(commentTotalPages) {
                        topicModel?.commentTotalPages = pages
                    }
                }
                
                //更新通知数量
                YuanCommunUser.sharedInstance.getNotificationsCount(jiHtml.rootNode!)
            }
            
            let t = XZValueResponse<(TopicDetailModel?,[TopicCommentModel])>(value:(topicModel,topicCommentsArray), success: response.result.isSuccess)
            
            completionHandler(t);
        }
    }
    
    class func getTopicCommentsById(
        _ topicId: String,
        page:Int,
        completionHandler: @escaping (XZValueResponse<[TopicCommentModel]>) -> Void
        ) {
        let url = V2EXURL + "t/" + topicId + "?p=\(page)"
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
            var topicCommentsArray : [TopicCommentModel] = []
            if  let jiHtml = response.result.value {
                //获取评论
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[attribute::id]"){
                    for aNode in aRootNode {
                        topicCommentsArray.append(TopicCommentModel(rootNode: aNode))
                    }
                }
                
            }
            let t = XZValueResponse(value: topicCommentsArray, success: response.result.isSuccess)
            completionHandler(t);
        }
    }
    
    /**
     感谢主题
     */
    class func topicThankWithTopicId(_ topicId:String , token:String ,completionHandler: @escaping (XZResponse) -> Void) {
        
        _ = YuanCommunityApi.provider.requestAPI(.thankTopic(topicId: topicId, once: token))
            .filterResponseError().subscribe(onNext: { (response) in
            if response["success"].boolValue {
                completionHandler(XZResponse(success: true))
            }
            else{
                completionHandler(XZResponse(success: false, message: response["message"].rawString() ?? ""))
            }
        }, onError: { (error) in
            completionHandler(XZResponse(success: false))
        })
        
    }
    
    /**
     收藏主题
     */
    class func favoriteTopicWithTopicId(_ topicId:String , token:String ,completionHandler: @escaping (XZResponse) -> Void) {
        let url  = V2EXURL + "favorite/topic/" + topicId + "?t=" + token
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
            if response.result.isSuccess {
                completionHandler(XZResponse(success: true))
            }
            else{
                completionHandler(XZResponse(success: false))
            }
        }
    }
    /**
     忽略主题
     */
    class func ignoreTopicWithTopicId(_ topicId:String ,completionHandler: @escaping (XZResponse) -> Void) {
        
        YuanCommunUser.sharedInstance.getOnce { (response) -> Void in
            if response.success ,let once = YuanCommunUser.sharedInstance.once {
                let url  = V2EXURL + "ignore/topic/" + topicId + "?once=" + once
                Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
                    if response.result.isSuccess {
                        completionHandler(XZResponse(success: true))
                        return
                    }
                    else{
                        completionHandler(XZResponse(success: false))
                    }
                }
            }
            else{
                completionHandler(XZResponse(success: false))
            }
        }
    }

}
