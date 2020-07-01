//
//  NotificationButton.swift
//  V2ex-Swift
//
//  Created by huangfeng on 2/1/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class NotificationMenuButton: UIButton {
    var aPointImageView:UIImageView?
    required init(){
        super.init(frame: CGRect.zero)
        self.contentMode = .center
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        self.setImage(UIImage.imageUsedTemplateMode("ic_menu_36pt")!, for: .normal)
        
        self.aPointImageView = UIImageView()
        self.aPointImageView!.backgroundColor = XZSwiftColor.noticePointColor
        self.aPointImageView!.layer.cornerRadius = 4
        self.aPointImageView!.layer.masksToBounds = true
        self.addSubview(self.aPointImageView!)
        self.aPointImageView!.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(8)
            make.top.equalTo(self).offset(3)
            make.right.equalTo(self).offset(-6)
        }
        
        self.kvoController.observe(YuanCommunUser.sharedInstance, keyPath: "notificationCount", options: [.initial,.new]) {  [weak self](cell, clien, change) -> Void in
            if YuanCommunUser.sharedInstance.notificationCount > 0 {
                self?.aPointImageView!.isHidden = false
            }
            else{
                self?.aPointImageView!.isHidden = true
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
