//
//  BaseViewController.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/05.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    fileprivate weak var _loadView:V2LoadingView?
    
    func showLoadingView (){
        
        self.hideLoadingView()
        
        let aloadView = V2LoadingView()
        aloadView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(aloadView)
        aloadView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view)
        }
        self._loadView = aloadView
    }
    
    func hideLoadingView() {
        self._loadView?.removeFromSuperview()
    }

}
