//
//  V2LoadingView.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/05.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit

let noticeString = [
    "正在拼命加载",
    "乘风破浪的楼主",
    "年轻人,不要着急",
    "让子弹飞一会儿",
    "前方发现楼主",
    "大爷,您又来了?",
    "小朋友,您是不是有很多问号?",
    "楼主正在抓皮卡丘，等他一会儿吧",
    "爱我，就等我一万年",
    "未满18禁止入内",
    "客官别急，要做的不快的人哦!",
]

class V2LoadingView: UIView {
    var activityIndicatorView = UIActivityIndicatorView(style: .gray)
    init (){
        super.init(frame:CGRect.zero)
        self.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-32)
        }
        
        let noticeLabel = UILabel()
        //修复BUG。做个小笔记给阅读代码的兄弟们提个醒
        //(Int)(arc4random())
        //上面这种写法有问题，arc4random()会返回 一个Uint32的随机数值。
        //在32位机器上,如果随机的数大于Int.max ,转换就会crash。
        noticeLabel.text = noticeString[Int(arc4random() % UInt32(noticeString.count))]
        noticeLabel.font = v2Font(10)
        noticeLabel.textColor = XZSwiftColor.topicListDateColor
        self.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.activityIndicatorView.snp.bottom).offset(10)
            make.centerX.equalTo(self.activityIndicatorView)
        }
        
        self.activityIndicatorView.style = .gray
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        self.activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide(){
        self.superview?.bringSubviewToFront(self)

        UIView.animate(withDuration: 0.2,
            animations: { () -> Void in
            self.alpha = 0 ;
        }, completion: { (finished) -> Void in
            if finished {
                self.removeFromSuperview();
            }
        })
        
    }
}
