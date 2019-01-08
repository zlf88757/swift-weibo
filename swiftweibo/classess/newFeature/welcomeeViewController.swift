//
//  welcomeeViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/8/20.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import SDWebImage

class welcomeeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.添加子控件
        view.addSubview(bgimageView)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        view.addSubview(enterInButton)
//        iconView.mas_makeConstraints { (make:MASConstraintMaker!) in
//            make.top.equalTo()(
//        }
        
        // 3.设置用户头像
        if let iconUrl = userAccToken.loadAccountMess()?.avatar_large
        {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImage(with: url as URL)
        }
    }

    
    lazy var bgimageView : UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    lazy var iconView:UIImageView = {
       let iii = UIImageView(image: UIImage(named: "avatar_default_big"))
        iii.layer.cornerRadius = 50
        iii.clipsToBounds = true
        return iii
    }()
    lazy var messageLabel : UILabel = {
       let lll = UILabel()
        lll.text = "welcome to back"
        lll.sizeToFit()
        lll.alpha = 0.0
        return lll
    }()
    lazy var enterInButton :UIButton = {
        let bbb = UIButton.init(type: .custom)
        
        bbb.frame = CGRect.init(x: 50, y: 300, width: 100, height: 30)
        bbb.backgroundColor = UIColor.red
        bbb.addTarget(self, action: #selector(welcomEnterIn(bbb:)), for: UIControlEvents.touchUpInside)
        return bbb
    }()
    @objc func welcomEnterIn(bbb:UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZLFSwitchRootViewControllerKey), object: true)
    }
    
}
