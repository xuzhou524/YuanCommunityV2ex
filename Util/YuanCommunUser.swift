//
//  YuanCommunUser.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/7/1.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit
import Alamofire
import Ji

let kUserName = "me.Aaron_xu.username"

class YuanCommunUser: NSObject {
    static let sharedInstance = YuanCommunUser()
    fileprivate var _user:UserModel?
    var user:UserModel? {
        get {
            return self._user
        }
        set {
            dispatch_sync_safely_main_queue {
                self._user = newValue
                self.username = newValue?.username
            }
        }
    }

    @objc dynamic var username:String?

    fileprivate var _once:String?
    var once:String?  {
        get {
            let onceStr = _once
            _once = nil
            return onceStr;
        }
        set{
            _once = newValue
        }
    }
    var hasOnce:Bool {
        get {
            return _once != nil && _once!.Lenght > 0
        }
    }
    @objc dynamic var notificationCount:Int = 0



    fileprivate override init() {
        super.init()
        dispatch_sync_safely_main_queue {
            self.setup()
            if self.isLogin {
                self.verifyLoginStatus()
            }
        }
    }
    func setup(){
        self.username = XZSettings.sharedInstance[kUserName]
    }


    /// 是否登录
    var isLogin:Bool {
        get {
            if let len = self.username?.Lenght , len > 0 {
                return true
            }
            else {
                return false
            }
        }
    }

    func ensureLoginWithHandler(_ handler:()->()) {
        guard isLogin else {
            V2Inform("请先登录")
            return;
        }
        handler()
    }
    /**
     退出登录
     */
    func loginOut() {
        removeAllCookies()
        self.user = nil
        self.username = nil
        self.once = nil
        self.notificationCount = 0
        XZSettings.sharedInstance[kUserName] = self.username
    }

    /**
     删除客户端所有cookies
     */
    func removeAllCookies() {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
    }
    /**
     打印客户端cookies
     */
    func printAllCookies(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                NSLog("name:%@ , value:%@ \n", cookie.name,cookie.value)
            }
        }
    }

    /**
     获取once

     - parameter url:               有once存在的url
     */
    func getOnce(_ url:String = V2EXURL+"signin" , completionHandler: @escaping (V2Response) -> Void) {
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml {
            (response) -> Void in
            if let jiHtml = response .result.value{
                if let once = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]{
                    self.once = once
                    completionHandler(V2Response(success: true))
                    return;
                }
            }
            completionHandler(V2Response(success: false))
        }
    }

    /**
     获取并更新通知数量
     - parameter rootNode: 有Notifications 的节点
     */
    func getNotificationsCount(_ rootNode: JiNode) {
        let notification = rootNode.xPath("//head/title").first?.content
        if let notification = notification {

            self.notificationCount = 0;

            let regex = try! NSRegularExpression(pattern: "V2EX \\([0-9]+\\)", options: [.caseInsensitive])
            regex.enumerateMatches(in: notification, options: [.withoutAnchoringBounds], range: NSMakeRange(0, notification.Lenght), using: { (result, flags, stop) -> Void in
                if let result = result {
                    let startIndex = notification.index(notification.startIndex, offsetBy: result.range.location + 6)
                    let endIndex = notification.index(notification.startIndex, offsetBy: result.range.location + result.range.length - 1)
                    let count = notification[startIndex..<endIndex]
                    if let acount = Int(count) {
                        self.notificationCount = acount
                    }
                }
            })
        }
    }

    /**
     验证客户端登录状态
     */
    func verifyLoginStatus() {
        Alamofire.request(V2EXURL + "new",  headers: MOBILE_CLIENT_HEADERS).responseString(encoding: nil) { (response) -> Void in
            if response.response?.url?.path == "/signin"{
                //没有登录 ,注销客户端
                dispatch_sync_safely_main_queue({ () -> () in
                    self.loginOut()
                })
            }
        }
    }
}
