//
//  StatusCellHome.swift
//  swiftweibo
//
//  Created by zhao on 2018/8/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import KILabel

let ZLFPictureViewCellReuseIdentifier = "picReuseIdentifier"

enum statusCellIdentifier : String {
    case normalCell = "normalcell"
    case turnCell = "turncell"
//    枚举中static 修饰方法，相当于类方法
    
    static func cellID(status:Status)->String{
        return status.retweeted_status != nil ? turnCell.rawValue : normalCell.rawValue
    }
}


class StatusCellHome: UITableViewCell {

    var pictureViewSize : CGSize?
    var pictureTopConstraint : Constraint?
    var footerViewTopConstraint : Constraint?
    
    
    var status:Status?{
        didSet{
            headerView.status = status
            
//            contentLabel.text = status?.text
            contentLabel.attributedText = emotionIconPackage.emotionIconStr(str: status?.text ?? "")
            
//            给配图的赋值
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
//            计算配图的size
            let total = pictureView.calculateImageSize()
            
            pictureView.snp.updateConstraints { (make) in
                make.width.equalTo(total.width)
                make.height.equalTo(total.height)
            }
            if total.height == 0 {
                
                self.pictureTopConstraint?.update(offset: 0)
            }else{
              
                self.pictureTopConstraint?.update(offset: 10)
            }

        }
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI()  {
        // 1.添加子控件
        contentView.addSubview(headerView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
//        pictureView.snp.makeConstraints { (make) in
//            self.pictureTopConstraint = make.top.equalTo(contentLabel.snp.bottom).offset(10).constraint
//            make.width.equalTo(290)
//            make.left.equalToSuperview().offset(10)
//            make.height.equalTo(290)
//        }
//        WARNING
        footerView.snp.makeConstraints { (make) in
            self.footerViewTopConstraint = make.top.equalTo(pictureView.snp.bottom).offset(15).constraint
            make.left.right.equalToSuperview()
        }
//        注意：在cell底部控件对cell底部进行约束是有问题
//        预估高度的时候千万不能对底部直接约束

    }
    //    MARK: ---cell高度---
    func rowHeightForCell(status:Status)->CGFloat{
        self.status = status
        self.layoutIfNeeded()
        print("debug--->查出footermaxy",self.frame,"--||--",footerView.frame.maxY)
        return footerView.frame.maxY
    }

//    头部view
    private lazy var headerView: StatusTableViewTopView = StatusTableViewTopView()
    /// 正文
    lazy var contentLabel : KILabel =
    {
        let label = KILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
//        限制label的最大宽度
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    
    lazy var pictureView:pictureCollectionView = pictureCollectionView()
    
    /// 底部工具条
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
}

