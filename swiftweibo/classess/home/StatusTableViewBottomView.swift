//
//  StatusTableViewBottomView.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/5.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class StatusTableViewBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpUI(){
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        weak var weakSelf = self
        // 2.布局子控件
        
        commonBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(screen_width/3)
        }
        
        unlikeBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(commonBtn.snp.right)
            make.width.equalTo(screen_width/3)
        }
        
        retweetBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(unlikeBtn.snp.right)
            
        }
        
    }
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = {
        let btn = createButtonByCustom(normalImage: "timeline_icon_retweet", normalTitle: "转发", titleFont: 10, backgroundImage: "timeline_card_bottom_background", normalTitleColor: UIColor.colorWith(hexStr: "#999999"))
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    // 赞
    private lazy var unlikeBtn: UIButton = {
        let btn = createButtonByCustom(normalImage: "timeline_icon_unlike", normalTitle: "赞", titleFont: 10, backgroundImage: "timeline_card_bottom_background", normalTitleColor: UIColor.colorWith(hexStr: "#5652FB"))
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    // 评论
    private lazy var commonBtn: UIButton = {
        let btn = createButtonByCustom(normalImage: "timeline_icon_comment", normalTitle: "评论" , titleFont: 10, backgroundImage: "timeline_card_bottom_background" , normalTitleColor: UIColor.colorWith(hexStr: "#999999"))
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
}
