//
//  NodeTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 2/2/16.
//  Copyright © 2016 Fin. All rights reserved.
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
