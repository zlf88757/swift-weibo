//
//  AppDelegate.swift
//  swift-weibo
//
//  Created by zhaolingfei on 2018/7/15.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

// 切换控制器通知
let ZLFSwitchRootViewControllerKey = "ZLFSwitchRootViewControllerKey"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SQLiteQueueManager.shareManagerQueue().openDB(name: "status.sqlite")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootViewControllerrr(notify:)), name: NSNotification.Name(rawValue: ZLFSwitchRootViewControllerKey), object: nil)
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func switchRootViewControllerrr(notify:Notification)  {
//        print("change rootviewcontroller %s",notify.object!)
        
        if notify.object as! Bool {
            window?.rootViewController = mainTabbarController()
        }else{
            window?.rootViewController = welcomeeViewController()
        }
        
    }
    
    private func defaultController()->UIViewController{
        if userAccToken.isUserLogin() {
            return isNewUpdate() ? newFeatureCollectionViewController() : welcomeeViewController()
        }
        return mainTabbarController()
    }
    
    private func isNewUpdate()->Bool{
//        1获取当前版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        2获取一起版本
        let sandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""
//        print("\(currentVersion) sandbox = \(sandboxVersion)")
//        3比较版本
        if currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending {
            //        3.1有新版本 2.0.0    1.0.0  descend下降
            
            //        3。1.1存储当前最新的版本
            UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }

//        3.2没有新版本
        return false
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        清空过期数据
        statusDAO.cleanStatuses()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

