//
//  RelevantCommentsViewController.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/3/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
//import FXBlurView
import Shimmer
import FDFullscreenPopGesture

class RelevantCommentsNav:LDNavigationController , UIViewControllerTransitioningDelegate {
    override init(nibName : String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "", bundle: nil)
    }
    init(comments:[TopicCommentModel]) {
        let viewController = RelevantCommentsViewController()
        viewController.commentsArray = comments
        super.init(rootViewController: viewController)
        self.transitioningDelegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RelevantCommentsViewControllerTransionPresent()
    }
}

class RelevantCommentsViewControllerTransionPresent:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! RelevantCommentsNav
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            
            toVC.view.alpha = 1
            
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}



class RelevantCommentsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var commentsArray:[TopicCommentModel] = []
    fileprivate var dismissing = false
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.cancelEstimatedHeight()
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        regClass(tableView, cell: TopicDetailCommentCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
//    var frostedView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = XZSwiftColor.backgroudColor
        self.fd_prefersNavigationBarHidden = true

        let shimmeringView = FBShimmeringView()
        shimmeringView.isShimmering = true
        shimmeringView.shimmeringOpacity = 0.5
        shimmeringView.shimmeringSpeed = 45
        shimmeringView.shimmeringHighlightLength = 0.6
        self.view.addSubview(shimmeringView)
        let label = UILabel(frame: shimmeringView.frame)
        label.text = "下拉关闭查看"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        shimmeringView.contentView = label
        var y:CGFloat = 15
        if UIDevice.current.isIphoneX {
            y = 24
        }
        shimmeringView.frame = CGRect( x: (SCREEN_WIDTH-80) / 2 , y: y, width: 80, height: 44)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.remakeConstraints{ (make) -> Void in
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.view)
            make.top.equalTo(self.view.snp.bottom)
        }
        
        self.tableView.v2_scrollToBottom()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.snp.remakeConstraints{ (make) -> Void in
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let layout = self.commentsArray[indexPath.row].textLayout!
        return layout.textBoundingRect.size.height + 12 + 35 + 12 + 12 + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: TopicDetailCommentCell.self, indexPath: indexPath)
        cell.bind(self.commentsArray[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //下拉关闭
        if scrollView.contentOffset.y <= -100 {
            //让scrollView 不弹跳回来
            scrollView.contentInset = UIEdgeInsets(top: -1 * scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            scrollView.isScrollEnabled = false
            self.navigationController!.dismiss(animated: true, completion: nil)
            self.dismissing = true
        }
    }
}
