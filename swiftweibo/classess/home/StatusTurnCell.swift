//
//  StatusTurnCell.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/6.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class StatusTurnCell: StatusCellHome {
//    重写父类属性，didSet不会覆盖父类操作
//    如果是父类是didSet，那么子类只能是didSet
    
    override var status:Status?{
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
//            forwordLabel.text = name + ":" + text
            forwordLabel.attributedText = emotionIconPackage.emotionIconStr(str: "@" + name + ":" + text)
        }
    }
    
    override func setUpUI() {
        super.setUpUI()

        contentView.insertSubview(forwordButton, belowSubview: pictureView)
        contentView.insertSubview(forwordLabel, aboveSubview: forwordButton)
  
        
        forwordButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.bottom.equalTo(footerView.snp.top)
        }
        forwordLabel.text = "...."
        forwordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(forwordButton.snp.top).offset(10)
        }
        pictureView.snp.makeConstraints { (make) in
            self.pictureTopConstraint = make.top.equalTo(forwordLabel.snp.bottom).offset(10).constraint
            make.width.equalTo(290)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(290)
        }
        
        
    }

    //    MARK:-懒加载
    /// 转发微博
    private lazy var forwordLabel: UILabel =
    {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        
        label.font = UIFont.systemFont(ofSize: 15)
        //        限制label的最大宽度
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    /// 转发按钮
    private lazy var forwordButton: UIButton =
    {
        let bbb = UIButton()
        bbb.backgroundColor = UIColor.lightGray
        return bbb
    }()
    
    
    
}
