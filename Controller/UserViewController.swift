//
//  UserViewController.swift
//  V2ex-Swift
//
//  Created by gozap on 2020/6/8.
//  Copyright © 2020 Fin. All rights reserved.
//

import UIKit
import StoreKit

class UserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView = {
        let tableView = UITableView();
        tableView.backgroundColor = XZSwiftColor.backgroudColor
        tableView.separatorStyle = .none
        
        regClass(tableView, cell: LeftUserHeadCell.self)
        regClass(tableView, cell: LeftNodeTableViewCell.self)
        regClass(tableView, cell: LeftNotifictionCell.self)
        
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        self.view.backgroundColor = XZSwiftColor.backgroudColor
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        
        if YuanCommunUser.sharedInstance.isLogin {
            self.getUserInfo(YuanCommunUser.sharedInstance.username!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,2,3][section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 2){
            return 55 + 15
        }
        return [130, 55+SEPARATOR_HEIGHT, 55+SEPARATOR_HEIGHT][indexPath.section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = XZSwiftColor.backgroudColor
        return bgView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if  indexPath.row == 0 {
                let cell = getCell(tableView, cell: LeftUserHeadCell.self, indexPath: indexPath);
                return cell ;
            }else {
                return UITableViewCell()
            }
        }else if (indexPath.section == 1) {
            if indexPath.row == 0 {
                let cell = getCell(tableView, cell: LeftNotifictionCell.self, indexPath: indexPath)
                cell.nodeImageView.image = UIImage(named: "ic_notifications_none")
                return cell
            }else {
                let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
                cell.summeryLabel.isHidden = true
                cell.isHiddenRightImage(hidden: false)
                cell.nodeNameLabel.text = "我的收藏"
                cell.nodeImageView.image = UIImage(named: "ic_turned_in_not")
                return cell
            }
        }else {
            let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
            cell.nodeNameLabel.text = ["节点","给个赞","版本号"][indexPath.row]
            let names = ["ic_navigation","ic_givePraise","ic_settings_input_svideo"]
            cell.nodeImageView.image = UIImage(named: names[indexPath.row])
            if indexPath.row == 2 {
                cell.isHiddenRightImage(hidden: true)
                let infoDict = Bundle.main.infoDictionary
                if let info = infoDict {
                   // app版本
                   let appVersion = info["CFBundleShortVersionString"] as! String?
                   cell.summeryLabel.text = "v" + appVersion!
                   cell.summeryLabel.isHidden = false
                }
            }else{
                cell.isHiddenRightImage(hidden: false)
                cell.summeryLabel.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if !YuanCommunUser.sharedInstance.isLogin {
                    let loginViewController = LoginViewController()
                    self.navigationController?.present(loginViewController, animated: true, completion: nil);
                }else{
                    let memberViewController = MyCenterViewController()
                    memberViewController.username = YuanCommunUser.sharedInstance.username
                    self.navigationController?.pushViewController(memberViewController, animated: true)
                }
            }
        }else if indexPath.section == 1 {
            if !YuanCommunUser.sharedInstance.isLogin {
                let loginViewController = LoginViewController()
                self.navigationController?.present(loginViewController, animated: true, completion: nil);
                return
            }
            if indexPath.row == 0 {
                let notificationsViewController = NotificationsViewController()
                self.navigationController?.pushViewController(notificationsViewController, animated: true)
            }else if indexPath.row == 1 {
                let favoritesViewController = FavoritesViewController()
                self.navigationController?.pushViewController(favoritesViewController, animated: true)
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let nodesViewController = NodesViewController()
                self.navigationController?.pushViewController(nodesViewController, animated: true)
            }else if indexPath.row == 1 {
                #if DEBUG
                #else
                    SKStoreReviewController.requestReview()
                #endif
            }
        }
    }
        
    // MARK: 获取用户信息
    func getUserInfo(_ userName:String){
        UserModel.getUserInfoByUsername(userName) {(response:V2ValueResponse<UserModel>) -> Void in
            if response.success {
//                self?.tableView.reloadData()
                NSLog("获取用户信息成功")
            }else{
                NSLog("获取用户信息失败")
            }
        }
    }
}
