//
//  NodeCollectionReusableView.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/28.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class NodeCollectionReusableView: UICollectionReusableView {
    var label : UILabel = {
        let _label = UILabel()
        _label.font = v2Font(16)
        return _label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label);
        
        label.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        
        self.backgroundColor = XZSwiftColor.backgroudColor
        self.label.textColor = XZSwiftColor.leftNodeTintColor
        self.label.backgroundColor = XZSwiftColor.backgroudColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
