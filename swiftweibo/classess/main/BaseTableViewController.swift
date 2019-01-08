
//
//  BaseTableViewController.swift
//  swiftweibo
//
//  Created by zhao on 2018/7/16.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController , visitorViewDelegate{

//    定义一个变量保存用户当前是否登录
    var userLogin = false
//    定义属性保存未登录界面
    var visitorV :visitorView?
    
    
    override func loadView() {
        
        userLogin = userAccToken.isUserLogin()
        userLogin ? super.loadView() : setUpV()
        
    }
    
    private func setUpV(){
        
//        let customView = UIView()
//        customView.backgroundColor = UIColor.red
//        view = customView
        visitorV = visitorView()
        visitorV?.delegate = self
        view = visitorV
        
//        navigationController?.navigationBar.tintColor = UIColor.red
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registerBtnWillClick(button:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loginBtnWillClick(button:)))
        
    }
    @objc func loginBtnWillClick(button:UIButton) {
       print("--loginWill--",#function)
        
        let authVC = OauthViewController()
        let navi = UINavigationController.init(rootViewController: authVC)
        present( navi , animated: true, completion: nil)
        
        
    }
    @objc func registerBtnWillClick(button:UIButton) {
       print("--registerWill--",#function)
        
    }
    

}
