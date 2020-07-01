//
//  UIView+Extension.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/18.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

extension UIView {
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage;
    }
}
