//
//  TopicDetailWebViewContentCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/19/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import KVOController
import JavaScriptCore
import Kingfisher
import WebKit
/**
 * 由于这里的逻辑比较分散，但又缺一不可，所以在这里说明一下
 * 1. 将V站帖子的HTML和此APP内置的CSS等拼接起来，然后用 UIWebView 加载。以实现富文本功能
 * 2. UIWebView 图片请求会被 WebViewImageProtocol 拦截，然后被 Kingfisher 缓存
 * 3. 点击UIWebView 图片时 ，会被内置的 tapGesture 捕获到（这个手势只在 UIWebView 所在的 UITableView 的pan手势 失效时触发
 *    也就是 在没滚动的时候才能点图片（交互优化）
 * 4. 然后通过 JSTools.js内置的 js方法，取得 图片 src,通过内置图片浏览器打开
 */

public typealias TopicDetailWebViewContentHeightChanged = (CGFloat) -> Void

let HTMLHEADER  = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"

class TopicDetailWebViewContentCell: UITableViewCell {
    
    fileprivate var model:TopicDetailModel?
    
    var contentHeight : CGFloat = 0
    var contentWebView:WKWebView?
    var contentHeightChanged : TopicDetailWebViewContentHeightChanged?
    
    var tapGesture:UITapGestureRecognizer?
    weak var parentScrollView:UIScrollView?{
        didSet{
            //滑动的时候，点击不生效
           tapGesture?.require(toFail: self.parentScrollView!.panGestureRecognizer)
        }
    }
    var tapImageInfo:TapImageInfo?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.clipsToBounds = true
        
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript.init(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let jsCode = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "JSTools", ofType: "js")!))
        let wkJsCode = WKUserScript.init(source: jsCode, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        
        let wkUController = WKUserContentController()
          wkUController.addUserScript(wkUScript)
         wkUController.addUserScript(wkJsCode)
        
        let wkWebConfig = WKWebViewConfiguration()
          wkWebConfig.userContentController = wkUController
          
          self.contentWebView = WKWebView.init(frame: CGRect(x: 0 , y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 50), configuration: wkWebConfig)
    
//        self.contentWebView.delegate = self

        self.contentView.addSubview(self.contentWebView!);
        self.contentWebView?.snp.makeConstraints{ (make) -> Void in
            make.left.top.right.bottom.equalTo(self.contentView)
        }
        for view in self.contentWebView?.scrollView.subviews ?? [] {
            view.backgroundColor = XZSwiftColor.white
        }
        self.kvoController.observe(self.contentWebView?.scrollView, keyPath: "contentSize", options: [.new]) {
            [weak self] (observe, observer, change) -> Void in
            if let weakSelf = self {
                let size = change["new"] as! NSValue
                weakSelf.contentHeight = size.cgSizeValue.height;
                weakSelf.contentHeightChanged?(weakSelf.contentHeight)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func load(_ model:TopicDetailModel){
        if self.model == model{
            return;
        }
        self.model = model
        
        if var html = model.topicContent {

            let style = "<style>" + V2Style.sharedInstance.CSS + "</style></head>"
            html =  HTMLHEADER + style  + html + "</html>"
            
            self.contentWebView?.loadHTMLString(html, baseURL: URL(string: "https://www.v2ex.com"))
        }
    }
}

extension TopicDetailWebViewContentCell {
    //让点击图片手势 和webView的手势能共存
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

struct TapImageInfo {
    let url:String
    let width:Int
    let height:Int
    let left:Int
    let top:Int
}
