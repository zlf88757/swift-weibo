//
//  hexStringColor.swift
//  swiftweibo
//
//  Created by zhao on 2018/8/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import Foundation
import UIKit

let default_void_color = UIColor.init(red: 49/255, green: 186/255, blue: 138/255, alpha: 1)

extension UIColor{
    
    class func colorWith(hexStr:String)->UIColor{
      return  colorWith(hexString: hexStr, alpha: 1.0)
    }
    
    class func colorWith(hexString:String,alpha:CGFloat)->UIColor{
        var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.count < 6 {
            return default_void_color
        }
        let strCount = cString.count
        if cString.hasPrefix("0X") {
            cString = cString[2 ..< strCount+1]
        }
        if cString.hasPrefix("#") {
            cString = cString[1 ..< strCount+1]
        }
        if cString.count != 6 {
            return default_void_color
        }
        let rString = cString[0..<2]
//        var rStr = cString.substring(toIndex: 2)
        
        let gString = cString[2..<4]
//        var gStr = cString.substring(fromIndex: 2).substring(toIndex: 2)
        
        let bString = cString[4..<6]
        //        var bStr = cString.substring(fromIndex: 4).substring(toIndex: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    
}




