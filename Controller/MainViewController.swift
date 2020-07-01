//
//  MainViewController.swift
//  YuanCommunityV2ex
//
//  Created by gozap on 2020/7/1.
//  Copyright © 2020 com.xuzhou. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SnapKit
import Ji
import MJRefresh
import AlamofireObjectMapper

class MainViewController: UIViewController {

    var tab:String? = "all"
    var currentPage = 0
    var topicList:Array<TopicListModel>?
    
    fileprivate lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.cancelEstimatedHeight()
        tableView.separatorStyle = .none
        
        regClass(tableView, cell: HomeTopicListTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        if (tab != nil) && (tab != "all"){
            self.title = NSLocalizedString(tab ?? "all")
        }
 
        //监听程序即将进入前台运行、进入后台休眠 事件
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        self.tableView.mj_header = V2RefreshHeader(refreshingBlock: {[weak self] () -> Void in
            self?.refresh()
        })
        self.tableView.mj_header.beginRefreshing();
        
        let footer = V2RefreshFooter(refreshingBlock: {[weak self] () -> Void in
            self?.getNextPage()
        })
        footer?.centerOffset = -4
        self.tableView.mj_footer = footer
        
        self.tableView.backgroundColor = XZSwiftColor.backgroudColor
    }
    
    func refresh(){
        
        //如果有上拉加载更多 正在执行，则取消它
        if self.tableView.mj_footer.isRefreshing {
            self.tableView.mj_footer.endRefreshing()
        }
        
        //根据 tab name 获取帖子列表
        _ = TopicListApi.provider
            .requestAPI(.topicList(tab: tab, page: 0))
            .mapResponseToJiArray(TopicListModel.self)
            .subscribe(onNext: { (response) in
                self.topicList = response
                self.tableView.reloadData()
                
                //判断标签是否能加载下一页, 不能就提示下
                let refreshFooter = self.tableView.mj_footer as! V2RefreshFooter
                if self.tab == nil || self.tab == "all" {
                    refreshFooter.noMoreDataStateString = nil
                    refreshFooter.resetNoMoreData()
                }
                else{
                    refreshFooter.noMoreDataStateString = "没更多帖子了,只有【\(NSLocalizedString("all"))】标签能翻页"
                    refreshFooter.endRefreshingWithNoMoreData()
                }
                
                //重置page
                self.currentPage = 0
                self.tableView.mj_header.endRefreshing()
                
            }, onError: { (error) in
                if let err = error as? ApiError {
                    switch err {
                    case .needs2FA:
                        self.navigationController?.present(TwoFAViewController(), animated: true, completion: nil);
                    default:
                        SVProgressHUD.showError(withStatus: err.rawString())
                    }
                }
                else {
                    SVProgressHUD.showError(withStatus: error.rawString())
                }
                self.tableView.mj_header.endRefreshing()
            })
    }
    
    func getNextPage(){
        if let count = self.topicList?.count , count <= 0{
            self.tableView.mj_footer.endRefreshing()
            return;
        }
        
        //根据 tab name 获取帖子列表
        self.currentPage += 1
        _ = TopicListApi.provider
            .requestAPI(.topicList(tab: tab, page: self.currentPage))
            .mapResponseToJiArray(TopicListModel.self)
            .subscribe(onNext: { (response) in
                if response.count > 0 {
                    self.topicList? += response
                    self.tableView.reloadData()
                }
                self.tableView.mj_footer.endRefreshing()
            }, onError: { (error) in
                self.currentPage -= 1
                SVProgressHUD.showError(withStatus: error.rawString())
                self.tableView.mj_footer.endRefreshing()
            })
    }
    
    static var lastLeaveTime = Date()
    @objc func applicationWillEnterForeground(){
        //计算上次离开的时间与当前时间差
        //如果超过2分钟，则自动刷新本页面。
        let interval = -1 * MainViewController.lastLeaveTime.timeIntervalSinceNow
        if interval > 120 {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    @objc func applicationDidEnterBackground(){
        MainViewController.lastLeaveTime = Date()
    }
}

//MARK: - TableViewDataSource
extension MainViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.topicList {
            return list.count;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.topicList![indexPath.row]
        let titleHeight = item.topicTitleLayout?.textBoundingRect.size.height ?? 0
        //          上间隔   头像高度  头像下间隔   标题高度      标题下间隔 评论数高度  cell间隔
        let height = 12    +  36   +  12  + titleHeight  + 12     + 20   + 12  + 10

        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: HomeTopicListTableViewCell.self, indexPath: indexPath);
        cell.bind(self.topicList![indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.topicList![indexPath.row]
        
        if let id = item.topicId {
            let topicDetailController = TopicDetailViewController();
            topicDetailController.topicId = id ;
            topicDetailController.ignoreTopicHandler = {[weak self] (topicId) in
                self?.perform(#selector(MainViewController.ignoreTopicHandler(_:)), with: topicId, afterDelay: 0.6)
            }
            self.navigationController?.pushViewController(topicDetailController, animated: true)
            tableView .deselectRow(at: indexPath, animated: true);
        }
    }
    
    @objc func ignoreTopicHandler(_ topicId:String) {
        let index = self.topicList?.firstIndex(where: {$0.topicId == topicId })
        if index == nil {
            return
        }
        
        //看当前忽略的cell 是否在可视列表里
        let indexPaths = self.tableView.indexPathsForVisibleRows
        let visibleIndex =  indexPaths?.firstIndex(where: {($0 as IndexPath).row == index})
        
        self.topicList?.remove(at: index!)
        //如果不在可视列表，则直接reloadData 就可以
        if visibleIndex == nil {
            self.tableView.reloadData()
            return
        }
        
        //如果在可视列表，则动画删除它
        self.tableView.beginUpdates()
        
        self.tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .fade)
        
        self.tableView.endUpdates()
        
    }
}
