//
//  UITableView+Extension.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 20/05/27.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

extension String {
    public var Lenght:Int {
        get{
            return self.count;
        }
    }
}


/**
 向tableView 注册 UITableViewCell
 
 - parameter tableView: tableView
 - parameter cell:      要注册的类名
 */
func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个
 
 - parameter tableView: tableView
 - parameter cell:      要返回的Cell类型
 - parameter indexPath: 位置
 
 - returns: 传入Cell类型的 实例对象
 */
func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}

extension UITableView {
    func v2_scrollToBottom() {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = IndexPath(row: row, section: section)
        self.scrollToRow(at: path, at: .top, animated: false)
    }
    func v2_scrollToTop() {
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
}
