//
//  RightViewController.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/06.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

let RightViewControllerRightNodes = [
    rightNodeModel(nodeName: "技术", nodeTab: "tech"),
    rightNodeModel(nodeName: "创意", nodeTab: "creative"),
    rightNodeModel(nodeName: "好玩", nodeTab: "play"),
    rightNodeModel(nodeName: "Apple", nodeTab: "apple"),
    rightNodeModel(nodeName: "酷工作", nodeTab: "jobs"),
    rightNodeModel(nodeName: "交易", nodeTab: "deals"),
    rightNodeModel(nodeName: "城市", nodeTab: "city"),
    rightNodeModel(nodeName: "问与答", nodeTab: "qna"),
    rightNodeModel(nodeName: "最热", nodeTab: "hot"),
    rightNodeModel(nodeName: "全部", nodeTab: "all"),
    rightNodeModel(nodeName: "R2", nodeTab: "r2"),
    rightNodeModel(nodeName: "节点", nodeTab: "nodes"),
    rightNodeModel(nodeName: "关注", nodeTab: "members"),
]
class RightViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let rightNodes = RightViewControllerRightNodes
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = XZSwiftColor.backgroudColor
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        regClass(tableView, cell: RightNodeTableViewCell.self)
        
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
        return rightNodes.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: RightNodeTableViewCell.self, indexPath: indexPath);
        cell.nodeNameLabel.text = self.rightNodes[indexPath.row].nodeName
        return cell ;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.rightNodes[indexPath.row];
        let mainVC = MainViewController()
        mainVC.tab = node.nodeTab
        mainVC.titleTab = node.nodeName
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}

struct rightNodeModel {
    var nodeName:String?
    var nodeTab:String?
}
