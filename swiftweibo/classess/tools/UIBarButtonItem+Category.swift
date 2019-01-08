//
//  UIBarButtonItem+Category.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/24.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import Foundation

extension UIBarButtonItem{
    
//    如果在func前面加上class 相当于OC中+  类方法
    class func createBarButtonItem(imageName:String,target: AnyObject?,action:Selector?) -> UIBarButtonItem{
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        if action != nil {
            btn.addTarget(target, action: action!, for: UIControlEvents.touchUpInside)
        }
        
        return UIBarButtonItem(customView: btn)
    }
    
    
}


