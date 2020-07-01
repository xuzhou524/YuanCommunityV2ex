//
//  RightViewController.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/14/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

let RightViewControllerRightNodes = [
    rightNodeModel(nodeName: NSLocalizedString("tech" ), nodeTab: "tech"),
    rightNodeModel(nodeName: NSLocalizedString("creative" ), nodeTab: "creative"),
    rightNodeModel(nodeName: NSLocalizedString("play" ), nodeTab: "play"),
    rightNodeModel(nodeName: NSLocalizedString("apple" ), nodeTab: "apple"),
    rightNodeModel(nodeName: NSLocalizedString("jobs" ), nodeTab: "jobs"),
    rightNodeModel(nodeName: NSLocalizedString("deals" ), nodeTab: "deals"),
    rightNodeModel(nodeName: NSLocalizedString("city" ), nodeTab: "city"),
    rightNodeModel(nodeName: NSLocalizedString("qna" ), nodeTab: "qna"),
    rightNodeModel(nodeName: NSLocalizedString("hot"), nodeTab: "hot"),
    rightNodeModel(nodeName: NSLocalizedString("all"), nodeTab: "all"),
    rightNodeModel(nodeName: NSLocalizedString("r2" ), nodeTab: "r2"),
    rightNodeModel(nodeName: NSLocalizedString("nodes" ), nodeTab: "nodes"),
    rightNodeModel(nodeName: NSLocalizedString("members" ), nodeTab: "members"),
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
        let homeVC = MainViewController()
        homeVC.tab = node.nodeTab

        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

struct rightNodeModel {
    var nodeName:String?
    var nodeTab:String?
}
