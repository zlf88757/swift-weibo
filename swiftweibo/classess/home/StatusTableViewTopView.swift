//
//  StatusTableViewTopView.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/5.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class StatusTableViewTopView: UIView {
    
    
    var status:Status?{
        didSet{
            nameLabel.text = status?.user?.name
            
            //            设置头像
            iconView.sd_setImage(with: status?.user?.iconImageUrl, completed: nil)
            verifiedView.image = status?.user?.verifiedImage
            vipView.image = status?.user?.mbrankImage
            sourceLabel.text = status?.source
            timeLabel.text = status?.created_at
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        verifiedView.snp.makeConstraints { (make) in
            make.right.equalTo(iconView.snp.right)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(10)
        }
        
        vipView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(3)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(3)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
        
    }
    lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    lazy var verifiedView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
        return iv
    }()
    lazy var nameLabel:UILabel = {
        let lll = UILabel()
        lll.textColor = UIColor.darkGray
        lll.text = "名字标题"
        lll.preferredMaxLayoutWidth = 100
        lll.font = UIFont.boldSystemFont(ofSize: 14)
        return lll
    }()
    lazy var vipView : UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    lazy var timeLabel : UILabel = {
        let lll = UILabel()
        lll.textColor = UIColor.darkGray
        lll.text = "1 hour ago"
        lll.font = UIFont.boldSystemFont(ofSize: 14)
        return lll
    }()
    
    /// 来源
    private lazy var sourceLabel: UILabel =
    {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "from somewhere"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

}
