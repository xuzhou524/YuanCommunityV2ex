//
//  BaseDetailTableViewCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/25.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class BaseDetailTableViewCell: UITableViewCell {
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        return label
    }()
    
    var detailLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(13)
        return label
    }()
    
    var detailMarkImageView:UIImageView = {
        let imageview = UIImageView(image: UIImage.init(named: "ic_rightArrow"))
        imageview.contentMode = .center
        return imageview
    }()
    
    var separator:UIImageView = UIImageView()
    
    var detailMarkHidden:Bool {
        get{
            return self.detailMarkImageView.isHidden
        }
        
        set{
            if self.detailMarkImageView.isHidden == newValue{
                return ;
            }
            
            self.detailMarkImageView.isHidden = newValue
            if newValue {
                self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
                    make.width.height.equalTo(0)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            }
            else{
                self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
                    make.width.height.equalTo(15)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            }
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()->Void{
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailMarkImageView);
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.separator)
        
        
        self.titleLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.contentView).offset(12)
            make.centerY.equalTo(self.contentView)
        }
        self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
            make.height.equalTo(24)
            make.width.equalTo(14)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-12)
        }
        self.detailLabel.snp.makeConstraints{ (make) -> Void in
            make.right.equalTo(self.detailMarkImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.contentView)
        }
        self.separator.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        
        
        self.backgroundColor = XZSwiftColor.white
        self.selectedBackgroundView!.backgroundColor = XZSwiftColor.backgroudColor
        self.titleLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.detailMarkImageView.tintColor = self.titleLabel.textColor
        self.detailLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.separator.image = createImageWithColor(XZSwiftColor.backgroudColor)
    }
    
}
