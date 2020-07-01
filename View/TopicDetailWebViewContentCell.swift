//
//  TopicDetailWebViewContentCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/03.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import KVOController
import JavaScriptCore
import Kingfisher
import WebKit

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

            let style = "<style>" + XZStyle.sharedInstance.CSS + "</style></head>"
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
