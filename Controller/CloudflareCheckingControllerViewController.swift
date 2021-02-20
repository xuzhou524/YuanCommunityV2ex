//
//  CloudflareCheckingControllerViewController.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2021/2/20.
//  Copyright © 2021 com.xuzhou. All rights reserved.
//

import UIKit
import WebKit

class CloudflareCheckingController: UIViewController, WKNavigationDelegate {
    let webView:WKWebView = WKWebView()
    var completion: (() -> ())? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = XZSwiftColor.backgroudColor

        self.webView.customUserAgent = USER_AGENT
        self.webView.backgroundColor = self.view.backgroundColor
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(self.view)
        }
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never

        _ = self.webView.load(URLRequest(url: URL(string: V2EXURL)!))
    }


    // Cloudflare 检查后设置 cookies
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
            if cookies.count > 1 {
                self.dismiss(animated: true) {[weak self] in
                    self?.completion?()
                }
            }

        }

    }

}
