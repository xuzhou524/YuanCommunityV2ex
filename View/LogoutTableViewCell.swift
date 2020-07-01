//
//  LogoutTableViewCell.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/05/28.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup()->Void{
        

        self.textLabel!.text = "退出当前账号"
        self.textLabel!.textAlignment = .center
        
        let separator = UIImageView()
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.contentView)
            make.right.bottom.equalTo(self.contentView)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        self.backgroundColor = XZSwiftColor.white
        self.textLabel!.textColor = XZSwiftColor.noticePointColor
        separator.image = createImageWithColor(XZSwiftColor.backgroudColor)
        
    }
}
