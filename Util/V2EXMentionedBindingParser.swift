//
//  V2EXMentionedBindingParser.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/12.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

import YYText

class V2EXMentionedBindingParser: NSObject ,YYTextParser{
    var regex:NSRegularExpression
    override init() {
        self.regex = try! NSRegularExpression(pattern: "@(\\S+)\\s", options: [.caseInsensitive])
        super.init()
    }
    
    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        guard let text = text else {
            return false;
        }
        self.regex.enumerateMatches(in: text.string, options: [.withoutAnchoringBounds], range: text.yy_rangeOfAll()) { (result, flags, stop) -> Void in
            if let result = result {
                let range = result.range
                if range.location == NSNotFound || range.length < 1 {
                    return ;
                }
                
                if  text.attribute(NSAttributedString.Key(rawValue: YYTextBindingAttributeName), at: range.location, effectiveRange: nil) != nil  {
                    return ;
                }
                
                let bindlingRange = NSMakeRange(range.location, range.length-1)
                let binding = YYTextBinding()
                binding.deleteConfirm = true ;
                text.yy_setTextBinding(binding, range: bindlingRange)
                text.yy_setColor(colorWith255RGB(0, g: 132, b: 255), range: bindlingRange)
            }
        }
        return false;
    }
    
}
