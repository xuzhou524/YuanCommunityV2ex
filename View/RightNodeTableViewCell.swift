//
//  RightNodeTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/23/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class RightNodeTableViewCell: UITableViewCell {

    var rightImageView = UIImageView()
    var nodeNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        return label
    }()
    
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
        
        self.nodeNameLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.contentView.addSubview(self.nodeNameLabel)
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        self.contentView.addSubview(self.rightImageView)
        self.rightImageView.image = UIImage(named: "ic_rightArrow")
        self.rightImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-15)
            make.width.height.equalTo(15)
        }
    }
}
