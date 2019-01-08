//
//  customPopoverPresentVC.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/26.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class customPopoverPresentVC: UIPresentationController {
    
    var presentedVFrame  = CGRect.zero
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        print("-------prevc--",presentedViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        if presentedVFrame == CGRect.zero {
            presentedView?.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        }else{
            presentedView?.frame = presentedVFrame
        }
        
        containerView?.insertSubview(coverViewC, at: 0)
    }
    
    lazy var coverViewC : UIView = {
        let vvv = UIView()
        vvv.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
        vvv.frame = UIScreen.main.bounds
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTo))
        vvv.addGestureRecognizer(tap)
        
        return vvv
        
    }()
    
   @objc func backTo()  {
        
        presentedViewController.dismiss(animated: true, completion: nil)
        
    }

}
