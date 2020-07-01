//
//  LeftUserHeadCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/28.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import KVOController
import Kingfisher

class LeftUserHeadCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_head")
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        label.textColor = XZSwiftColor.leftNodeTintColor
        return label
    }()
    var rightImageView: UIImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none

        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.rightImageView)
        
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.contentView).offset(20)
            make.centerY.equalTo(self.contentView).offset(-8)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(self.avatarImageView)
        }
        
        self.rightImageView.image = UIImage(named: "ic_rightArrow")
        self.rightImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-15)
            make.width.height.equalTo(15)
        }

        self.kvoController.observe(YuanCommunUser.sharedInstance, keyPath: "username", options: [.initial , .new]){
            [weak self] (observe, observer, change) -> Void in
            if let weakSelf = self {
                weakSelf.userNameLabel.text = YuanCommunUser.sharedInstance.username ?? "请先登录"
                if let avatar = YuanCommunUser.sharedInstance.user?.avatar_large?.avatarString {
                    weakSelf.avatarImageView.kf.setImage(with: URL(string: avatar)!, placeholder: nil, options: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                        //如果请求到图片时，客户端已经不是登录状态了，则将图片清除
                        if !YuanCommunUser.sharedInstance.isLogin {
                            weakSelf.avatarImageView.image = nil
                        }
                    })
                }
                else { //没有登录
                    weakSelf.avatarImageView.image = UIImage(named: "ic_head")
                }
            }
        }
    }
}
