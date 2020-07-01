//
//  NodeTableViewCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/28.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class NodeTableViewCell: UICollectionViewCell {
    var textLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(textLabel)
        
        textLabel.snp.remakeConstraints({ (make) -> Void in
            make.center.equalTo(self.contentView)
        })

        self.backgroundColor = XZSwiftColor.white
        self.textLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.textLabel.backgroundColor = XZSwiftColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
