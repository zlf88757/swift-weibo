//
//  OauthViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/29.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
/**
 --resobj--- Optional({
 "access_token" = "2.00cxqdHG0rjnApe2a6e3e7abpfNPnB";
 "expires_in" = 157679999;
 isRealName = true;
 "remind_in" = 157679999;
 uid = 5609729720;
 })
 */


import UIKit
import SVProgressHUD

class OauthViewController: UIViewController {

    let wbv_appkey = "753784335"
    let wbv_secret = "749a444062374b5de6fa67b95282ec05"
    let wbv_uri = "http://www.zhaolingfei.com"
    override func loadView() {
        view = webview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "myswift"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close) )
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(wbv_appkey)&redirect_uri=\(wbv_uri)"
        let url  = URL(string: urlStr)
        let request = URLRequest(url: url!)
        webview.loadRequest(request)
    }


    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
   
    lazy var webview:UIWebView = {
        let wbv = UIWebView()
        wbv.delegate = self
        return wbv
    }()
    
}

extension OauthViewController : UIWebViewDelegate
{
    /*
     授权成功: http://www.520it.com/?code=91e779d15aa73698cbbb72bc7452f3b3
     
     取消授权: http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
     */
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url?.absoluteString)
        
        let urlStr = request.url!.absoluteString
        
        if !urlStr.hasPrefix(wbv_uri){
//            继续加载
            return true
        }
//        code=91e779d15aa73698cbbb72bc7452f3b3
        let codeSS = "code="
        if request.url!.query!.hasPrefix(codeSS)
        {
          
            let str = request.url!.query!
            let bef = str[codeSS.endIndex..<str.endIndex]
            print("--成功授权--授权code--",bef)
            loadAccessToken(code: String(bef))
            

            
        }else{
            print("取消授权")
            // 关闭界面
            close()
        }
        
        return false // 加载到需要的信息之后就不需要加载
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "正在加载...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    private func loadAccessToken(code:String) -> Void {
        // 1.定义路径
        let path = "oauth2/access_token"
        let params = ["client_id":wbv_appkey, "client_secret":wbv_secret, "grant_type":"authorization_code", "code":code, "redirect_uri":wbv_uri]
        
        httpSessionMTool.shareNetWorkTool().post(path, parameters: params, progress: { (_) in
            
        }, success: { (_, responseObj ) in
           
            if let res: NSDictionary = responseObj as? NSDictionary {
                let account = userAccToken(dict: res as! [String : AnyObject])
                print("-----account-----",account)
                
                account.loadUserInfo(finished: { (acc, err) in
                    if acc != nil{
                        acc!.saveAccountMess()
//                        补充，去欢迎界面
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZLFSwitchRootViewControllerKey), object: false)
                    }
                    SVProgressHUD.showInfo(withStatus: "网络不给力")
                })
            }

        }) { (_, error) in
            print(error)
        }
        
        
    }
    
}
