//
//  MyCenterViewController.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/10.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class MyCenterViewController: MemberViewController {
    var settingsButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.settingsButton!.contentMode = .center
        self.settingsButton!.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        self.settingsButton!.setImage(UIImage(named: "ic_supervisor_account"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.settingsButton!)
        self.settingsButton!.addTarget(self, action: #selector(MyCenterViewController.accountManagerClick), for: .touchUpInside)
    }
    
    @objc func accountManagerClick(){
        self.navigationController?.pushViewController(AccountsManagerViewController(), animated: true)
    }
}
