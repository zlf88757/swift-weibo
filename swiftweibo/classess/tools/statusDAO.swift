//
//  statusDAO.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/27.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class statusDAO: NSObject {
    /**
     清空过期的数据
     */
    class func cleanStatuses(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en")
        
        let date = Date(timeIntervalSinceNow: -60)
        let dateStr = formatter.string(from: date)
        print("过期时间打印一下---》",dateStr)
        
        let sql = "delete from t_status where createDate <= '\(dateStr)'"
        SQLiteQueueManager.shareManagerQueue().db?.inDatabase({ (db) in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        })
    }
    
    
    
    
    /**
      1/尝试从本地数据库获取
      2/本地如果有，就直接返回
      3/如果没有从网络获取
      4/将网络获取的数据存储起来
     */
    class func loadStatuses(since_id:NSNumber,max_id:NSNumber,finish:@escaping ([[String:AnyObject]]?,_ error:NSError?)->()){
//        1/尝试从本地数据库获取
        loadCacheStatus(since_id: since_id, max_id: max_id) { (arr) in
//            2/本地如果有，就直接返回
            if arr.count > 0{
                finish(arr,nil)
                return
            }
//            3/如果没有从网络获取
            let path = "2/statuses/home_timeline.json"
            var params = ["access_token":userAccToken.loadAccountMess()?.access_token]
            let since_idd = Int(truncating: since_id)
            let max_idd = Int(truncating:max_id)
            if since_idd > 0 {
                params["since_id"] = "\(since_idd)"
            }
            if max_idd > 0{
                params["max_id"] = "\(max_idd - 1)"
            }
            httpSessionMTool.shareNetWorkTool().get(path, parameters: params, progress: { (_) in
                
            }, success: { (task, json) in
                
                if let responseJson = json as? [String : AnyObject]{
                    let array = responseJson["statuses"] as! [[String:AnyObject]]
                    print("=--=fanhui de response----",responseJson)
//                    statusDAO.cacheStatus(statuses: responseJson["statuses"] as! [[String:AnyObject]])
                    cacheStatus(statuses: array)
                    finish(array,nil)
                    
                }
                
                
            }) { (task, error) in
                print(error)
                finish(nil,error as NSError)
            }
            
            
            
            
        }

    }
    
    class func loadCacheStatus(since_id:NSNumber,max_id:NSNumber,finish:@escaping ([[String:AnyObject]])->()){
        
//        定义sql语句
        let since_idd = Int(truncating: since_id)
        let max_idd = Int(truncating:max_id)
        
        var sql = "select * from t_status "
//        注意：还有 = 0的第一次的情况，所以拼接的条件单独出来，如果都是0，就没有statusId筛选
        if since_idd > 0 {
            sql += "WHERE statusId > \(since_idd)"
        }
        if max_idd > 0{
            sql += "WHERE statusId <= \(max_idd)"
        }
        sql += "order by statusId desc limit 20"
        var statuses = [[String:AnyObject]]()
        SQLiteQueueManager.shareManagerQueue().db?.inDatabase({ (db) in
            
            
            if let res = db?.executeQuery(sql, withArgumentsIn: nil){
                
                while res.next(){
//                    取出数据库中的微博字符串
                    let dicString = res.string(forColumn: "statusText")
//                    微博字符串转换微博字典
                    let data = dicString?.data(using: String.Encoding.utf8)
                    let dic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    statuses.append(dic as! [String : AnyObject])
                }
                finish(statuses)
            }
            
            finish(statuses)
        })
        
        
        
    }
    
    class func cacheStatus( statuses : [[String:AnyObject]]){
        
        
        let userid = userAccToken.loadAccountMess()!.uid!
        
        let sql = "insert into t_status (statusId,statusText,userId) values (?,?,?)"
        SQLiteQueueManager.shareManagerQueue().db?.inTransaction({ (db, rollback) in
            for dic in statuses{
                let statusid = dic["id"]!
                var data:Data? = Data()
                do {
                    data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
                } catch  {
                    print(error)
                    
                }
                let statusText = String(data: data!, encoding: String.Encoding.utf8)
                if !db!.executeUpdate(sql: sql, statusid ,statusText as AnyObject,userid as AnyObject){
                    rollback?.pointee = true
                }else{
                    print("插入成功了")
                }
            }
        })
    }
    
    

}
