//
//  homeTableViewController.swift
//  swift-weibo
//https://api.weibo.com/oauth2/authorize
//client_id = 753784335  redirect_uri = "http://www.zhaolingfei.com"
//  https://api.weibo.com/oauth2/authorize?client_id=753784335&redirect_uri=http://www.zhaolingfei.com
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//http://www.zhaolingfei.com/?code=1d5e59415678f04ae7b73b176cbcb86c

import UIKit
import SVProgressHUD


let cellIdentifier = "homecell"

class homeTableViewController: BaseTableViewController {
    
    var statusArr : [Status]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    var isPullUp : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
// 1、未登录设置未登录界面，即可终止
        if !userLogin{
            visitorV?.setupVisitorInfo(isHome: true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
//       导航栏设置页面设置
        setUpHomeView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitleBtnState), name: NSNotification.Name(popoverAniWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitleBtnState), name: NSNotification.Name(popoverAniWillDismiss), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(showPhotoBrowser(notify:)) , name: NSNotification.Name.init(rawValue: pictureBrowserNotifSelectName), object: nil)
        
//        分别注册不同cell
        tableView.register(StatusTurnCell.self, forCellReuseIdentifier: statusCellIdentifier.turnCell.rawValue)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: statusCellIdentifier.normalCell.rawValue)
        
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        navigationController?.navigationBar.insertSubview(noticeLabel, at: 0)
        
//        tableView.mj_header = customRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.refreshControl = commonRefreshControlll()
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        
        
        loadData()

    }
    @objc func showPhotoBrowser(notify:Notification){
        
        guard let indexpath = notify.userInfo![pictureBrowserNotifInfoKey] as? IndexPath else {
            print("没有indexpath")
            return
        }
        guard let urls = notify.userInfo![pictureBrowserNotifUrlKey] as? [URL] else {
            print("没有配图数组")
            return
        }
        let ppp = photoBrowserController(index: indexpath.item, urls: urls)
        present(ppp, animated: true, completion: nil)
        
    }
    //    MARK:---请求数据---
    @objc func loadData(){
        var since_id = statusArr?.first?.id ?? NSNumber(value: 0)//第一次是0，之后获取数据的值
        var max_id = NSNumber(value: 0)
        
        if isPullUp {
            since_id = NSNumber(value: 0)
            max_id = statusArr?.last?.id ?? NSNumber(value: 0)
        }
        
        Status.loadStatus(since_id:since_id,max_id: max_id) { (models, error) in
            
            self.refreshControl?.endRefreshing()
            if error != nil{
                return
            }
            if Int(truncating: since_id) > 0{
                self.statusArr = models! + self.statusArr!
                self.showMessageStatusCount(count: models?.count ?? 0)
            }else if Int(truncating: max_id) > 0{
                self.statusArr = self.statusArr! + models!
            }else{
                self.statusArr = models
            }
            
//            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func showMessageStatusCount(count:Int) {
        noticeLabel.isHidden = false
        noticeLabel.text = count == 0 ? "没有新的数据" : "刷新到\(count)条微博数据"
        UIView.animate(withDuration: 2, animations: {
            self.noticeLabel.transform = CGAffineTransform.init(translationX: 0, y: self.noticeLabel.frame.height)
        }) { (_) in
            UIView.animate(withDuration: 2, animations: {
                self.noticeLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.noticeLabel.isHidden = true
            })
        }
        
    }
    
    //    MARK:---通知处理---
    @objc func changeTitleBtnState() {
        let titlebtn = navigationItem.titleView as! titleButton
        titlebtn.isSelected = !titlebtn.isSelected
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(popoverAniWillShow), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(popoverAniWillDismiss), object: nil)
    }
    //    MARK:---处理子视图---
    private func setUpHomeView(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(letBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightBtnClick))
        
        // 2.初始化标题按钮
        let titleBtn = titleButton()
        titleBtn.setTitle("mySwift ", for: UIControlState.normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    //    MARK:---左右按钮点击---
    @objc func letBtnClick()
    {
        print(#function);
    }
    @objc func rightBtnClick()
    {
        print(#function);
        let sb = UIStoryboard(name: "QRcodeVC", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    //    MARK:---头部按钮点击---
    @objc func titleBtnClick(btn: titleButton){
        print(#function)
//        btn.isSelected = !btn.isSelected
        
//        弹出菜单的viewcontroller
        let sb = UIStoryboard(name: "popoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
//        设置转场代理
//(图层结构)默认情况下modal会移除以前的view，替换为当前弹出view
//        如果自定义转场，就不会移除以前控制器
//        原先的转场代理放在viewcontroller实现，现在移到了新建类，然后让delegate交给这个类去实现
        vc?.transitioningDelegate = custPopoverAni
        
        vc?.modalPresentationStyle = UIModalPresentationStyle.custom
        if let vcc = vc {
            present(vcc, animated: true, completion: nil)
        }

    }
//    一定要定义一个属性自定义转场对象
    lazy var custPopoverAni : customPopoverAnimate = {
       let cusAni = customPopoverAnimate()
        cusAni.presentedVFrame = CGRect(x: 100, y: 60, width: 200, height: 360)
        return cusAni
    }()
    
//    在刷新之后显示提示框
    lazy var noticeLabel : UILabel = {
       let ll = UILabel.createLabel(color: UIColor.white, fontSize: 14)
        ll.textAlignment = NSTextAlignment.center
        ll.backgroundColor = UIColor.orange
        ll.frame = CGRect(x: 0, y: 0, width: screen_width, height: 44)
        ll.isHidden = true
        return ll
    }()
    
//    缓存微博的行高，利用字典作为容器，key微博的id，值就是微博的cell高度
    var rowHeiCache : [Int:CGFloat] = [Int : CGFloat]()
    
    override func didReceiveMemoryWarning() {
        if rowHeiCache.count > 0{
            rowHeiCache.removeAll()
        }
    }
    
    
}

extension homeTableViewController 
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("--------",statusArr?.count)
        return statusArr?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status  = statusArr![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier:statusCellIdentifier.cellID(status: status), for: indexPath) as! StatusCellHome
        
        cell.status = status
        
        let count = statusArr?.count ?? 0
        if indexPath.row == count - 1{
            print("上拉加载更多")
            isPullUp=true
            loadData()
        }
        if indexPath.row == 0{
            print("diyizzzzzzzzzz")
           
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let status = statusArr![indexPath.row]

        let id : Int = Int(truncating: status.id!)

        if let height = rowHeiCache[id] {
            print("从已经缓存了的字典数组取出高度")
            return height
        }
//        如果没有缓存，进行缓存
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCellIdentifier.cellID(status: status)) as! StatusCellHome
        let rowHeight = cell.rowHeightForCell(status: status)

        rowHeiCache[id] = rowHeight
        print("新开始计算并缓存到内存")

        return rowHeight
    }
   
    
    
    
}
