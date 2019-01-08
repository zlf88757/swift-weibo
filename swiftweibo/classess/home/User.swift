//
//  User.swift
//  swiftweibo
//
//  Created by zhao on 2018/8/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

@objcMembers class User: NSObject {
    
    var id : Int = 0
    
    var name : String?
//    头像地址，50*50
    var profile_image_url : String?{
        didSet{
            if profile_image_url != nil{
                iconImageUrl = URL.init(string: profile_image_url!)
            }
        }
    }

    //    是否认证，true 已认证  false 未认证
    var verified:Bool = false

    //    -1没有认证  0  认证用户 2，3，5 企业认证  220达人
    var verified_type : Int = -1{
        didSet{
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
                
            default:
                verifiedImage = nil
            }
        }
    }
    
    var mbrank:Int = 0{
        didSet{
            if mbrank > 0 && mbrank < 7{
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    
    
    
//    自定义头像URL，内部赋值
    var iconImageUrl : URL?
   //    自定义认证头像image，内部赋值
    var verifiedImage : UIImage?
    
    var mbrankImage : UIImage?
    
    
    
    
    
    init(dic:[String:AnyObject]){
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
//    override func value(forUndefinedKey key: String) -> Any? {
//        return nil
//    }
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String{
        let dic = dictionaryWithValues(forKeys: properties)
        return "\(dic)"
    }
    
    

}
