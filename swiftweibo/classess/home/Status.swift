//
//  Status.swift
//  swiftweibo
//
//  Created by zhao on 2018/8/27.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import SDWebImage


@objcMembers class Status: NSObject {
//    微博创建时间
    var created_at: String?{
        didSet{
            //            created_at = "Sun Sep 12 14:50:57 +0800 2014"
//            将服务器返回的时间字符串转换NSDate
//            创建formatter
//            设置时间格式
//            设置时间区域使用NSDateFormatter转换时间字符串时，默认的时区是系统时区，例如在中国一般都是北京时间(+8)，如果直接转换会导致结果相差8小时，所以一般的做法是先指定时区为GMT标准时间再转换
            let cratedate = NSDate.myDateWith(timeString: created_at!)
            created_at = cratedate.descDate
            
        }
    }
//    微博id
    var id : NSNumber?
//    微博信息内容
    var text:String?
    
    
//    微博来源
    var source:String?{
        didSet{
//"source": <a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
            guard source != nil else{
                source = "来自" + ""
                return
            }
            guard source!.length > 0 else {
                source = "来自" + ""
                return
            }
            if let str = source {
                let startlacation = (str as NSString).range(of: ">").location + 1
                let length = (str as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startlacation
                source = "来自" + (str as NSString).substring(with: NSRange.init(location: startlacation, length: length))
            }
        }
    }
    
    
//    配图数组
//    配图宽高：两种方式，一种是服务器告诉，第二种是先下载下来，获得宽高
    
    var pic_urls : [[String:AnyObject]]?{
        didSet{
            
//            注意，返回的如果为空判断
//            处理url
            storedPicUrls = [URL]()
            storeLargePicUrls = [URL]()
            for dic in pic_urls!{
                if let urlstr = dic["thumbnail_pic"] {
                    storedPicUrls?.append(URL.init(string: urlstr as! String)!)
                    
                    let largeUrl = urlstr.replacingOccurrences(of: "thumbnail", with: "large")
                    
                    storeLargePicUrls?.append(URL.init(string: largeUrl)!)
                }
            }
        }
    }
//    处理并且保存缩略图的url
    var storedPicUrls : [URL]?
    //    处理并且保存大图的url，只是URL路径和缩略图不一样
    var storeLargePicUrls : [URL]?
    
    
    
    var user : User?
    
    var retweeted_status:Status?
//    如果有转发，原创没有配图
//    定义一个属性，用于返回原创获取转发配图的URL数组,这个用来缓存配图
    var pictureUrlsSelect : [URL]?{
        return retweeted_status != nil ? retweeted_status?.storedPicUrls : storedPicUrls
    }
// 一个用来计算属性，用于返回原创或者转发配图的大图URL数组
    var largePictureUrlsSelect : [URL]?{
        return retweeted_status != nil ? retweeted_status?.storeLargePicUrls : storeLargePicUrls
        
    }
    
    
    
    class func dictionaryToModel(list:[[String:AnyObject]])->[Status]{
        var modelarr = [Status]()
        for dic in list{
            modelarr.append(Status(dic: dic))
        }
        return modelarr
        
    }
    
    init(dic:[String:AnyObject]){
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "user"{
            user = User(dic: value as! [String:AnyObject])
            return
        }
        if key == "retweeted_status" {
            retweeted_status = Status(dic: value as! [String:AnyObject])
            return
        }

//        调用父类方法，按照默认处理
        super.setValue(value, forKey: key)

    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    var properties = ["created_at","id","text","source","pic_urls"]

    override var description: String {
        let dic = dictionaryWithValues(forKeys: properties)
        return "\(dic)"

    }
    class func loadStatus(since_id:NSNumber,max_id:NSNumber,finished:@escaping (_ modelArr:[Status]?,_ error:Error?)->())  {
        
        
//        let path = "2/statuses/home_timeline.json"
//        var params = ["access_token":userAccToken.loadAccountMess()?.access_token]
//        statusDAO.loadCacheStatus(since_id: since_id, max_id: max_id) { (statuses) in
//            print(statuses)
//        }
        
        
        
//        let since_idd = Int(truncating: since_id)
//        let max_idd = Int(truncating:max_id)
//        if since_idd > 0 {
//            params["since_id"] = "\(since_idd)"
//        }
//        if max_idd > 0{
//            params["max_id"] = "\(max_idd - 1)"
//        }
        
        
        statusDAO.loadStatuses(since_id: since_id, max_id: max_id) { (array, error) in
            if array == nil {
                finished(nil,error)
                return
            }
            if error != nil{
                finished(nil,error)
                return
            }
            let models = dictionaryToModel(list: array!)
            cacheStatusImages(list: models, finished: finished)
        }
        
        
//        httpSessionMTool.shareNetWorkTool().get(path, parameters: params, progress: { (_) in
//
//        }, success: { (task, json) in
//
//            if let responseJson = json as? [String : AnyObject]{
//                print("=--=fanhui de response----",responseJson)
//                statusDAO.cacheStatus(statuses: responseJson["statuses"] as! [[String:AnyObject]])
//               let models = dictionaryToModel(list: responseJson["statuses"] as! [[String:AnyObject]])
//                cacheStatusImages(list: models, finished: finished)
////                finished(models,nil)//这一步放到了图片缓存完成才返回
//            }
//
//
//        }) { (task, error) in
//            print(error)
//            finished(nil,error)
//        }
        
        
    }
//    用请求网络的类方法调用类方法
    class func cacheStatusImages(list:[Status],finished:@escaping (_ modelArr:[Status]?,_ error:Error?)->()){
        
        print("abc".cacheDir())
        if list.count == 0 {
            finished(list,nil)
            return
        }
//        创建一个组group
        let group  = DispatchGroup()
        
        
        for status in list {
            
//            if status.storedPicUrls == nil{
//                continue
//            }
//            上面和下面的方式都相等用法，判断用户时候有配图,如果没有不缓存，跳过循环
            guard let _ = status.pictureUrlsSelect else{
                continue
            }
            
            for url in status.pictureUrlsSelect!{
                group.enter()

                SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.init(rawValue: 0), progress: nil) { (_, _, _, _, _, _) in

                    group.leave()
                }
            
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("全部图片加载完毕，通知主线程")
            
            finished(list,nil)
        }
        
    }

}
