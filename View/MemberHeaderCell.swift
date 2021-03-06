//
//  MemberHeaderCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/28.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class MemberHeaderCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 38
        return avatarImageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = XZSwiftColor.leftNodeTintColor
        userNameLabel.font = v2Font(16)
        userNameLabel.text = "Hello"
        return userNameLabel
    }()
    /// 签名
    var introduceLabel: UILabel = {
        let introduceLabel = UILabel()
        introduceLabel.textColor = XZSwiftColor.leftNodeTintColor
        introduceLabel.font = v2Font(16)
        introduceLabel.numberOfLines = 2
        introduceLabel.textAlignment = .center
        return introduceLabel
    }()
    var sepView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.introduceLabel)
        self.contentView.addSubview(self.sepView)

        self.setupLayout()
    }
    
    func setupLayout(){
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(20)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.avatarImageView)
        }
        self.introduceLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(self.avatarImageView)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        self.sepView.backgroundColor = XZSwiftColor.backgroudColor
        self.sepView.snp.makeConstraints{ (make) -> Void in
            make.left.bottom.right.equalTo(self.contentView)
            make.height.equalTo(10)
        }
    }
    
    func bind(_ model:MemberModel?){
        if let model = model {
            if let avata = model.avata?.avatarString {
                self.avatarImageView.kf.setImage(with: URL(string: avata)!)
            }
            self.userNameLabel.text = model.userName;
            self.introduceLabel.text = model.introduce;
        }
    }
}
