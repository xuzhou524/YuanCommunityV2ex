//
//  HomeTopicListTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/8/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import Kingfisher
import YYText

class HomeTopicListTableViewCell: UITableViewCell {
    
    /// 节点信息label的圆角背景图
    fileprivate static var nodeBackgroundImage_Default =
        createImageWithColor(XZSwiftColor.backgroudColor,size: CGSize(width: 10, height: 20))
            .roundedCornerImageWithCornerRadius(2)
            .stretchableImage(withLeftCapWidth: 3, topCapHeight: 3)
    fileprivate static var nodeBackgroundImage_Dark =
        createImageWithColor(XZSwiftColor.backgroudColor,size: CGSize(width: 10, height: 20))
            .roundedCornerImageWithCornerRadius(2)
            .stretchableImage(withLeftCapWidth: 3, topCapHeight: 3)
    
    /// 头像
    var avatarImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode=UIView.ContentMode.scaleAspectFit
        return imageview
    }()
    
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(14)
        return label;
    }()
    /// 日期 和 最后发送人
    var dateAndLastPostUserLabel: UILabel = {
        let label = UILabel()
        label.font=v2Font(13)
        return label
    }()
    /// 评论数量
    var replyCountLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        return label
    }()
    var replyCountIconImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "reply_n"))
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    /// 节点
    var nodeNameLabel: UILabel = {
        let label = UILabel();
        label.font = v2Font(13)
        return label
    }()
    var nodeBackgroundImageView:UIImageView = UIImageView()
    /// 帖子标题
    var topicTitleLabel: YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = .top
        label.font=v2Font(16)
        label.displaysAsynchronously = true
        label.numberOfLines=0
        return label
    }()
    
    /// 装上面定义的那些元素的容器
    var contentPanel:UIView = UIView()
    
    var itemModel:TopicListModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    
    func setup()->Void{
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView .addSubview(self.contentPanel);
        self.contentPanel.addSubview(self.avatarImageView);
        self.contentPanel.addSubview(self.userNameLabel);
        self.contentPanel.addSubview(self.dateAndLastPostUserLabel);
        self.contentPanel.addSubview(self.replyCountLabel);
        self.contentPanel.addSubview(self.replyCountIconImageView);
        self.contentPanel.addSubview(self.nodeBackgroundImageView)
        self.contentPanel.addSubview(self.nodeNameLabel)
        self.contentPanel.addSubview(self.topicTitleLabel);
        
        self.setupLayout()
        
        self.nodeBackgroundImageView.image = HomeTopicListTableViewCell.nodeBackgroundImage_Default
        self.backgroundColor=XZSwiftColor.backgroudColor
        self.selectedBackgroundView!.backgroundColor = XZSwiftColor.backgroudColor
        self.contentPanel.backgroundColor = XZSwiftColor.white
        self.userNameLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.dateAndLastPostUserLabel.textColor=XZSwiftColor.topicListDateColor
        self.replyCountLabel.textColor = XZSwiftColor.topicListDateColor
        self.nodeNameLabel.textColor = XZSwiftColor.topicListDateColor
        self.topicTitleLabel.textColor=XZSwiftColor.leftNodeTintColor
        
        self.avatarImageView.backgroundColor = self.contentPanel.backgroundColor
        self.userNameLabel.backgroundColor = self.contentPanel.backgroundColor
        self.dateAndLastPostUserLabel.backgroundColor = self.contentPanel.backgroundColor
        self.replyCountLabel.backgroundColor = self.contentPanel.backgroundColor
        self.replyCountIconImageView.backgroundColor = self.contentPanel.backgroundColor
        self.topicTitleLabel.backgroundColor = self.contentPanel.backgroundColor

        //点击用户头像，跳转到用户主页
        self.avatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self.avatarImageView.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self.userNameLabel.addGestureRecognizer(userNameTap)
        
    }
    
    fileprivate func setupLayout(){
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalTo(self.contentView);
        }
        self.avatarImageView.layer.cornerRadius = 18
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(36);
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10);
            make.centerY.equalTo(self.avatarImageView);
        }
        
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.userNameLabel);
            make.right.equalTo(self.contentPanel).offset(-20);
        }
        self.nodeBackgroundImageView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.equalTo(self.nodeNameLabel)
            make.left.equalTo(self.nodeNameLabel).offset(-5)
            make.right.equalTo(self.nodeNameLabel).offset(5)
        }
        
        self.topicTitleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }
        
        self.dateAndLastPostUserLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.topicTitleLabel.snp.bottom).offset(12);
            make.left.equalTo(self.avatarImageView);
        }

        self.replyCountLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.dateAndLastPostUserLabel);
            make.right.equalTo(self.contentPanel).offset(-15);
        }
        self.replyCountIconImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.replyCountLabel);
            make.width.height.equalTo(20);
            make.right.equalTo(self.replyCountLabel.snp.left).offset(-2);
            make.bottom.equalTo(self.contentPanel).offset(-12)
        }
        
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10);
        }
    }
    
    @objc func userNameTap(_ sender:UITapGestureRecognizer) {
        if let _ = self.itemModel , let username = itemModel?.userName {
            let memberViewController = MemberViewController()
            memberViewController.username = username
            V2Client.sharedInstance.topNavigationController.pushViewController(memberViewController, animated: true)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func superBind(_ model:TopicListModel){
        self.userNameLabel.text = model.userName;
        if let layout = model.topicTitleLayout {
            //如果新旧model标题相同,则不需要赋值
            //不然layout需要重新绘制，会造成刷新闪烁
            if layout.text.string == self.itemModel?.topicTitleLayout?.text.string {
                return
            }
            else{
                self.topicTitleLabel.textLayout = layout
            }
        }
        if let avatar = model.avata?.avatarString {
            self.avatarImageView.fin_setImageWithUrl(URL(string: avatar)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification() )
        }
        self.replyCountLabel.text = model.replies;
        
        self.itemModel = model
    }
    
    func bind(_ model:TopicListModel){
        self.superBind(model)
        self.dateAndLastPostUserLabel.text = model.date
        self.nodeNameLabel.text = model.nodeName
    }
    
    func bindNodeModel(_ model:TopicListModel){
        self.superBind(model)
        self.dateAndLastPostUserLabel.text = model.hits
        self.nodeBackgroundImageView.isHidden = true
    }
}
