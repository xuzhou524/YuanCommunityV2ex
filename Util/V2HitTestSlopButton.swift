//
//  V2HitTestSlopButton.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/18.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

class V2HitTestSlopButton: UIButton {
    var hitTestSlop:UIEdgeInsets = UIEdgeInsets.zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitTestSlop == .zero {
            return super.point(inside: point, with:event)
        }
        else{
            return bounds.inset(by: hitTestSlop).contains(point)
        }
    }
}
