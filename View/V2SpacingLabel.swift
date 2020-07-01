//
//  V2SpacingLabel.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/05.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class V2SpacingLabel: UILabel {
    var spacing :CGFloat = 3.0
    override var text: String?{
        set{
            if let len = newValue?.Lenght, len > 0 {
                let attributedString = NSMutableAttributedString(string: newValue!);
                let paragraphStyle = NSMutableParagraphStyle();
                paragraphStyle.lineBreakMode=NSLineBreakMode.byTruncatingTail;
                paragraphStyle.lineSpacing=self.spacing;
                paragraphStyle.alignment=self.textAlignment;
                attributedString.addAttributes(
                    [
                        NSAttributedString.Key.paragraphStyle:paragraphStyle
                    ],
                    range: NSMakeRange(0, newValue!.Lenght));
                super.attributedText = attributedString;
            }
        }
        get{
            return super.text;
        }
    }
}
