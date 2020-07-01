//
//  PodCellTableViewCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/03.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class PodCellTableViewCell: BaseDetailTableViewCell {
    
    var descriptionLabel:UILabel = {
        let label =  V2SpacingLabel()
        label.font = v2Font(13)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = SCREEN_WIDTH - 42
        label.textColor = XZSwiftColor.leftNodeTintColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = XZSwiftColor.backgroudColor
        self.contentView.addSubview(self.descriptionLabel)
        self.setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        self.titleLabel.snp.remakeConstraints{ (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(12)
        }
        self.descriptionLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(self.contentView).offset(-30)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.equalTo(self.contentView).offset(-8);
        }
    }
}
