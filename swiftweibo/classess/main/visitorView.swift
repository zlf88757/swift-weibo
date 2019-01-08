//
//  visitorView.swift
//  swiftweibo
//
//  Created by zhao on 2018/7/16.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

// 一定要继承NSObjectProtocol不然定义属性报错
protocol visitorViewDelegate : NSObjectProtocol {
    func loginBtnWillClick(button:UIButton)
    func registerBtnWillClick(button:UIButton)
}

class visitorView: UIView {
//    加上weak避免循环引用
    weak var delegate  : visitorViewDelegate?
    
//    设置未登录页面
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String) {
        iconView.isHidden = !isHome
        homeIcon.image = UIImage(named: imageName)
        messageLabel.text = message
        if isHome {
          homestartAnimation()
        }
    }
    
///
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        添加子空间
        addSubview(iconView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
//        布局子空间
        weak var weakSelf = self
        iconView.mas_makeConstraints { (make : MASConstraintMaker!) in
            make.center.equalTo()(weakSelf!.center)
            
        }
        homeIcon.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.center.equalTo()(weakSelf!.center)
        }
        messageLabel.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.equalTo()(weakSelf!.iconView.mas_bottom)?.offset()(3)
            make.left.equalTo()(weakSelf?.mas_left)?.offset()(15)
            make.right.equalTo()(weakSelf?.mas_right)?.offset()(-15)
        }
        let buttonArr:NSArray = [registerButton,loginButton]
        buttonArr.mas_distributeViews(along: MASAxisType.horizontal, withFixedSpacing: 30, leadSpacing: 20, tailSpacing: 20)
        buttonArr.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.equalTo()(weakSelf?.messageLabel.mas_bottom)?.offset()(6)
            make.height.equalTo()(30)
        }
        
        
    }
    
//    swift推荐自定义一个控件，要么纯代码，要么xib、storyboard
    required init?(coder aDecoder: NSCoder) {
//        如果是xib、storyboard创建就会崩溃
        fatalError("init(coder:) has not been implemented")
        
        
    }
    //    MARK: - 内部方法执行动画
    private func homestartAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double.pi
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        iconView.layer.add(animation, forKey: nil)
        
    }
    @objc func registerButtonClickCustom(btn:UIButton){
        if delegate != nil {
            delegate?.registerBtnWillClick(button: btn)
            print("--register--",#function)
            
        }
        
        
    }
    @objc func loginButtonClickCustom(btn:UIButton){
        if delegate != nil {
        delegate?.loginBtnWillClick(button: btn)
        print("--login--",#function)
        }
    }
    //    MARK: - 懒加载
    //背景图
    private lazy var iconView: UIImageView = {
       let imgv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return imgv
    }()
//    背景图
    private lazy var homeIcon: UIImageView = {
        let imgv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return imgv
    }()
//    提示语文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜,关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
//    登录
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setBackgroundImage( UIImage(named: "common_button_white_disable") , for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(loginButtonClickCustom), for: UIControlEvents.touchUpInside)
        return btn
    }()
//    注册
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: UIControlState.normal)
        btn.setBackgroundImage( UIImage(named: "common_button_white_disable") , for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(registerButtonClickCustom), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
}
