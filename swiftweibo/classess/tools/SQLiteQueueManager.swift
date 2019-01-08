//
//  SQLiteQueueManager.swift
//  
//
//  Created by zhaolingfei on 2018/9/27.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class SQLiteQueueManager: NSObject {
    
    private static let managerQueue:SQLiteQueueManager = SQLiteQueueManager()
    
    class func shareManagerQueue()->SQLiteQueueManager{
        return managerQueue
    }
    
    var db:FMDatabaseQueue?
    
    func openDB(name:String){
        let path = name.docDir()
        print(path)
        db = FMDatabaseQueue(path: path)
        createTable()
    }
    func createTable(){
        let sql = "create table if not exists t_status (statusId integer primary key , statusText TEXT , userId INTEGER ,createDate TEXT NOT NULL DEFAULT (datetime('now',localtime))) "
        db?.inDatabase({ (db) in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        })
    }
    
    func insertDB(){
        let sql = "insert into person_custom (name,age) values ('zhangsan',19)"
        db?.inTransaction({ (db, rollback) in
            if !db!.executeUpdate(sql, withArgumentsIn: nil){
                rollback?.pointee = true
                print("插入失败")
            }
        })
    }
    func selectDB(finish:@escaping ([String])->()){
        let sql = "select * from person_custom"
        var models = [String]()
        db?.inDatabase({ (db) in
            let res = db?.executeQuery(sql, withArgumentsIn: nil)
            while res!.next(){
                
                let name = res?.string(forColumn: "name")
                models.append(name!)
            }
            finish(models)
        })
    }

}
