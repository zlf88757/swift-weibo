//
//  userAccToken.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/29.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

@objcMembers class userAccToken: NSObject ,NSCoding {
    
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber?{
        didSet{
            expires_date = Date.init(timeIntervalSinceNow: expires_in!.doubleValue)
            print("-----token-过期时间-----",expires_date)
        }
    }
    
    var expires_date:Date?
    
    /// 当前授权用户的UID。
    var uid:String?
//    用户头像地址，180*180
    var avatar_large : String?
//    用户昵称
    var screen_name : String?
    
    

    
    init(dict: [String: AnyObject])
    {
        super.init()// 注意：kvc和直接用等号赋值的区别是didSet方法是否调用
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("undefinedKey---------",key)
    }
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    override var description: String{
        return "access_token:\(access_token)  expires_in:\(expires_in)  uid:\(uid) expires_date:\(expires_date) avatar_large:\(avatar_large) screen_name:\(screen_name)"
    }
    /**--保存在内存，不用每次都从文件读取 static 能在类方法使用*/
    static var accountMess : userAccToken?
    static let filePath = "account.plist".cacheDir()
    
    /**--返回用户是否登录*/
    class func isUserLogin() -> Bool  {
        
        return userAccToken.loadAccountMess() != nil
    }
    
    //  MARK:-请求用户信息-
    func loadUserInfo(finished:@escaping (_ userAccount:userAccToken?,_ err:NSError?)->())  {
        let path = "2/users/show.json"
        if access_token == nil || uid == nil {
            return
        }
        let params = ["access_token":access_token!,"uid":uid!]
        
        httpSessionMTool.shareNetWorkTool().get(path, parameters: params, progress: { (_) in
            
        }, success: { (task, responseObj) in
            print("---用户信息userinfo---",responseObj)
            if let dic = responseObj as? [String:AnyObject]{
               self.avatar_large = dic["avatar_large"] as? String
                self.screen_name = dic["screen_name"] as? String
                finished(self,nil)
                return
            }
            finished(nil,nil)
            
        }) { (task, error) in
            print("--错误--",error,#function)
            finished(nil,error as NSError)
        }
        
    }
    
    
    
    //  MARK:--归档和提取-
    func saveAccountMess() {
        if NSKeyedArchiver.archiveRootObject(self, toFile: userAccToken.filePath) {
            print("--archiver--保存成功----")
        }
    }
    class func loadAccountMess() -> userAccToken? {
//        优化返回useracctoken
        if accountMess != nil{
            return accountMess!
        }
        accountMess = NSKeyedUnarchiver.unarchiveObject(withFile:filePath) as? userAccToken
        if accountMess == nil {
            return nil
        }
        if accountMess?.expires_date?.compare(Date()) == ComparisonResult.orderedAscending {
            return nil
        }
        print(accountMess!.access_token)
        return accountMess
        
    }
    
    func encode(with aCoder: NSCoder) {
//        aCoder.encode(, forKey: )
//        aCoder.encodeConditionalObject(, forKey: )
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
}

