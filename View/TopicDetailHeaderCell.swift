//
//  TopicDetailHeaderCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/03.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class TopicDetailHeaderCell: UITableViewCell {
    /// 头像
   var avatarImageView: UIImageView = {
        let imageview = UIImageView();
        imageview.contentMode=UIView.ContentMode.scaleAspectFit;
        imageview.layer.cornerRadius = 18;
        imageview.layer.masksToBounds = true;
        return imageview
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel();
        label.font=v2Font(14);
        return label
    }()
    /// 日期 和 最后发送人
    var dateAndLastPostUserLabel: UILabel = {
        let label = UILabel();
        label.font=v2Font(12);
        return label
    }()

    /// 节点
    var nodeNameLabel: UILabel = {
        let label = UILabel();
        label.font = v2Font(11)
        label.layer.cornerRadius=2;
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    /// 帖子标题
    var topicTitleLabel: UILabel = {
        let label = V2SpacingLabel();
        label.font = v2Font(17);
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = SCREEN_WIDTH-24;
        return label
    }()
    
    /// 装上面定义的那些元素的容器
    var contentPanel:UIView = {
        let view = UIView()
        return view
    }()
    
    weak var itemModel:TopicDetailModel?
    var nodeClickHandler:(() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.selectionStyle = .none
        self.backgroundColor = XZSwiftColor.backgroudColor
        
        self.contentView.addSubview(self.contentPanel);
        self.contentPanel.addSubview(self.avatarImageView);
        self.contentPanel.addSubview(self.userNameLabel);
        self.contentPanel.addSubview(self.dateAndLastPostUserLabel);
        self.contentPanel.addSubview(self.nodeNameLabel)
        self.contentPanel.addSubview(self.topicTitleLabel);

        self.setupLayout()
    
        //点击用户头像，跳转到用户主页
        self.avatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailHeaderCell.userNameTap(_:)))
        self.avatarImageView.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailHeaderCell.userNameTap(_:)))
        self.userNameLabel.addGestureRecognizer(userNameTap)
        self.nodeNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nodeClick)))
 
        self.userNameLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.dateAndLastPostUserLabel.textColor=XZSwiftColor.topicListDateColor
        self.nodeNameLabel.textColor = XZSwiftColor.topicListDateColor
        self.nodeNameLabel.backgroundColor = XZSwiftColor.backgroudColor
        self.topicTitleLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.contentPanel.backgroundColor = XZSwiftColor.white
    }
    
    fileprivate func setupLayout(){
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.top.equalTo(self.contentPanel).offset(12);
            make.width.height.equalTo(36);
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10);
            make.top.equalTo(self.avatarImageView);
        }
        self.dateAndLastPostUserLabel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.avatarImageView);
            make.left.equalTo(self.userNameLabel);
        }
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.userNameLabel);
            make.right.equalTo(self.contentPanel.snp.right).offset(-10)
            make.bottom.equalTo(self.userNameLabel).offset(1);
            make.top.equalTo(self.userNameLabel).offset(-1);
        }
        self.topicTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12);
            make.left.equalTo(self.avatarImageView);
            make.right.equalTo(self.contentPanel).offset(-12);
        }
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.topicTitleLabel.snp.bottom).offset(12);
            make.bottom.equalTo(self.contentView).offset(SEPARATOR_HEIGHT * -1);
        }
    }
    @objc func nodeClick() {
        nodeClickHandler?()
    }
    @objc func userNameTap(_ sender:UITapGestureRecognizer) {
        if let _ = self.itemModel , let username = itemModel?.userName {
            let memberViewController = MemberViewController()
            memberViewController.username = username
            XZClient.sharedInstance.topNavigationController.pushViewController(memberViewController, animated: true)
        }
    }
    
    func bind(_ model:TopicDetailModel){
        
        self.itemModel = model
        
        self.userNameLabel.text = model.userName;
        self.dateAndLastPostUserLabel.text = model.date
        self.topicTitleLabel.text = model.topicTitle;
        
        if let avata = model.avata?.avatarString {
            self.avatarImageView.fin_setImageWithUrl(URL(string: avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification())
        }
        
        if let node = model.nodeName{
            self.nodeNameLabel.text = "  " + node + "  "
        }
    }
}
