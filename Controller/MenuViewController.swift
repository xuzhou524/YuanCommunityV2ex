//
//  MenuViewController.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/06.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

struct menuNodeModel {
    var nodeName:String?
    var nodeTab:String?
}

let MenuViewControllerNodes = [
    menuNodeModel(nodeName: "技术", nodeTab: "tech"),
    menuNodeModel(nodeName: "创意", nodeTab: "creative"),
    menuNodeModel(nodeName: "好玩", nodeTab: "play"),
    menuNodeModel(nodeName: "Apple", nodeTab: "apple"),
    menuNodeModel(nodeName: "酷工作", nodeTab: "jobs"),
    menuNodeModel(nodeName: "交易", nodeTab: "deals"),
    menuNodeModel(nodeName: "城市", nodeTab: "city"),
    menuNodeModel(nodeName: "问与答", nodeTab: "qna"),
    menuNodeModel(nodeName: "最热", nodeTab: "hot"),
    menuNodeModel(nodeName: "全部", nodeTab: "all"),
    menuNodeModel(nodeName: "R2", nodeTab: "r2"),
    menuNodeModel(nodeName: "节点", nodeTab: "nodes"),
    menuNodeModel(nodeName: "关注", nodeTab: "members"),
]
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let menuNodes = MenuViewControllerNodes
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = XZSwiftColor.backgroudColor
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        regClass(tableView, cell: MenuNodeTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分类"
        self.view.backgroundColor = XZSwiftColor.backgroudColor
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNodes.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: MenuNodeTableViewCell.self, indexPath: indexPath);
        cell.nodeNameLabel.text = self.menuNodes[indexPath.row].nodeName
        return cell ;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.menuNodes[indexPath.row];
        let mainVC = MainViewController()
        mainVC.tab = node.nodeTab
        mainVC.titleTab = node.nodeName
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}
