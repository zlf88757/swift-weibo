//
//  mainTabbarController.swift
//  swift-weibo
//
//  Created by zhaolingfei on 2018/7/15.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class mainTabbarController: UITabBarController {

    private lazy var composeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add") , for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(mainTabbarController.composeClick), for: UIControlEvents.touchUpInside)
        return btn
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("-----------",tabBar.subviews)
        tabBar.tintColor = UIColor.orange

//        1、获取json
//        let path = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
        
//        2、通过文件路径创建data
//        if let jsonPath = path {
        
//            let jsonData = NSData(contentsOfFile: jsonPath)
//
//            do{
//        3、序列化json->
//                let dicArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
////        4、遍历数组，动态创建控制器和设置数据
//                for dic in dicArr as! [String:String]{
//
// 由于addChildVC方法参数不能为nil, 但是字典中取出来的值可能是nil, 所以需要加上!
//        addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
//
//                }
//
//
//            }catch{
        
//        如果网络获取不成功，默认添加本地方法
        //        addChildViewController(childControllerName: "HomeTableViewController", title: "首页", imageName: "tabbar_home")
        //        addChildViewController(childControllerName: "MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        //        addChildViewController(childControllerName: "DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        //        addChildViewController(childControllerName: "ProfileTableViewController", title: "我", imageName: "tabbar_profile")
//
//            }
//
//
//
//
//        }
//
        

        
        
        
        
        
        addChildControllerCustom(childController: homeTableViewController(), title: "首页", imageStr: "tabbar_home")
        addChildControllerCustom(childController: messageTableViewController(), title: "消息", imageStr: "tabbar_message_center")
        addChildControllerCustom(childController: NullViewController(), title: "", imageStr: "")
        addChildControllerCustom(childController: discoverTableViewController(), title: "广场", imageStr: "tabbar_discover")
        addChildControllerCustom(childController: profileTableViewController(), title: "我", imageStr: "tabbar_profile")

        
        
        
        
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.index(of: item)
        if index == 2 {
            print("点击了第三个nullcontroller")
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("---viewwillappear----",tabBar.subviews)
        let itembu = tabBar.items![2] as UITabBarItem
        
        itembu.isEnabled = false
        setUpComposeBtn()
        
    }
    
    private func setUpComposeBtn(){
        
        tabBar.addSubview(composeBtn)
//        let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
//        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame.size = CGSize(width: 49, height: 44 )
        composeBtn.center = CGPoint(x: UIScreen.main.bounds.size.width / CGFloat(2), y: 24 )
        
        
    }
    @objc func composeClick() {
        print(#function)
        
        let compose = composeViewController()
        let nav = UINavigationController(rootViewController: compose)
        present(nav, animated: true) {
            
        }
        
    }
    
    ///   初始化子控制器
    ///   - childController: 需要初始化的子控制器
    ///   - title: 标题
    ///   - imageStr: 图片
//    private func addChildControllerCustom(childController:UIViewController,title:String,imageStr:String){
    
    private func addChildControllerCustom(childController:UIViewController,title:String,imageStr:String){
        
        
//        <swift_weibo.homeTableViewController: 0x7fc96ce0a890>
        print(childController)
        
//        1、设置首页tabbar对应数据
        childController.tabBarItem.image = UIImage(named: imageStr)
        childController.tabBarItem.selectedImage = UIImage(named: imageStr + "_highlighted")
        childController.title = title
        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5)
        childController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 8, vertical: -8)
        
        
        
//      2、给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        addChildViewController(nav)
        
    }
    
    func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        // 0.动态获取命名空间
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]  else{
            print("无法获取")
            return
        }
        print(namespace)
        
        // 告诉编译器暂时就是AnyClass
        let cls:AnyClass? = NSClassFromString((namespace as! String) + "." + childControllerName)
        print(cls)
        // 告诉编译器真实类型是UIViewController
        guard let vcCls = cls as? UITableViewController.Type else{
            print("无法传化")
            return
            
        }
        // 实例化控制器
        let vc = vcCls.init()
        
        // 从内像外设置, nav和tabbar都有
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        // 注意: Xocde7之前只有文字有效果, 还需要设置图片渲染模式
        tabBar.tintColor = UIColor.orange
        
        // 2.创建导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        // 3.添加控制器到tabbarVC
        addChildViewController(nav)
        
    }

   
    
}
