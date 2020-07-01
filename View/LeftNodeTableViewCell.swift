//
//  LeftNodeTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/23/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class LeftNodeTableViewCell: UITableViewCell {
    
    var nodeImageView: UIImageView = UIImageView()
    var rightImageView: UIImageView = UIImageView()
    var nodeNameLabel: UILabel = {
        let label =  UILabel()
        label.font = v2Font(16)
        return label
    }()
    var summeryLabel: UILabel = {
        let label =  UILabel()
        label.font = v2Font(16)
        return label
    }()
    var panel = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()->Void{
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(panel)
        panel.addSubview(self.nodeImageView)
        panel.addSubview(self.nodeNameLabel)
        panel.addSubview(self.rightImageView)
        panel.addSubview(self.summeryLabel)
        
        panel.snp.makeConstraints{ (make) -> Void in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(55)
        }
        self.nodeImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(panel)
            make.left.equalTo(panel).offset(15)
            make.width.height.equalTo(22)
        }
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.nodeImageView.snp.right).offset(15)
            make.centerY.equalTo(self.nodeImageView)
        }
        self.rightImageView.image = UIImage(named: "ic_rightArrow")
        self.rightImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(panel)
            make.right.equalTo(panel).offset(-15)
            make.width.height.equalTo(15)
        }
        self.summeryLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.rightImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.nodeImageView)
        }
        
        self.summeryLabel.isHidden = true
        
        self.configureColor()
    }
    func configureColor(){
        self.panel.backgroundColor = XZSwiftColor.white
        self.nodeImageView.tintColor =  XZSwiftColor.leftNodeTintColor
        self.nodeNameLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.summeryLabel.textColor = XZSwiftColor.leftNodeTintColor
    }
    
    func isHiddenRightImage(hidden:Bool){
        if hidden {
            self.rightImageView.snp.makeConstraints{ (make) -> Void in
                make.centerY.equalTo(panel)
                make.right.equalTo(panel).offset(-10)
                make.width.height.equalTo(0)
            }
        }else{
            self.rightImageView.snp.makeConstraints{ (make) -> Void in
                make.centerY.equalTo(panel)
                make.right.equalTo(panel).offset(-15)
                make.width.height.equalTo(25)
            }
        }
    }
}


class LeftNotifictionCell : LeftNodeTableViewCell{
    var notifictionCountLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(10)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.backgroundColor = XZSwiftColor.noticePointColor
        return label
    }()
    
    override func setup() {
        super.setup()
        self.nodeNameLabel.text = "消息提醒"
        
        self.contentView.addSubview(self.notifictionCountLabel)
        self.notifictionCountLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.nodeNameLabel)
            make.left.equalTo(self.nodeNameLabel.snp.right).offset(5)
            make.height.equalTo(14)
        }
        
        self.kvoController.observe(YuanCommunUser.sharedInstance, keyPath: "notificationCount", options: [.initial,.new]) {  [weak self](cell, clien, change) -> Void in
            if YuanCommunUser.sharedInstance.notificationCount > 0 {
                self?.notifictionCountLabel.text = "   \(YuanCommunUser.sharedInstance.notificationCount)   "
            }
            else{
                self?.notifictionCountLabel.text = ""
            }
        }
    }
    
}
