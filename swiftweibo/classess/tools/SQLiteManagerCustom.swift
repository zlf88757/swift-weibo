//
//  SQLiteManagerCustom.swift
//  
//
//  Created by zhaolingfei on 2018/9/27.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit


class SQLiteManagerCustom: NSObject {
    
    private static let manager : SQLiteManagerCustom = SQLiteManagerCustom()
    
    class func shareManager()->SQLiteManagerCustom{
        return manager
    }
    
    private var db:FMDatabase?
    
    /**
     打开数据库
     */
    func openDB(dbName:String){
        let path = dbName.docDir()
        print(path)
        db = FMDatabase(path: path)
        if !db!.open() {
            print("打开失败")
            return
        }
        createTable()

    }
    
    func createTable(){
        let sql = "create table if not exists person_custom (id integer primary key autoincrement , name TEXT , age INTEGER ) "
        let s = db!.executeUpdate(sql, withArgumentsIn: nil)
        if s {
            print("创建成功")
        }else{
            print("创建失败")
        }
    }
    func insert(){
        
        let sql = "insert into person_custom (name,age) values ('zhangsan',19)"
        let s = db!.executeUpdate(sql, withArgumentsIn: nil)
        if s {
            print("插入成功")
        }else{
            print("插入失败")
        }
        
    }
    func selectFromDB(){
        let sql = "select * from person_custom"
        let res = SQLiteManagerCustom.shareManager().db!.executeQuery(sql, withArgumentsIn: nil)
//        var models = [String]()
        while res!.next() {
            
            let id = res?.int(forColumn: "id")
            let name = res?.string(forColumn: "name")
            let age = res?.int(forColumn: "age")
            print(id,name,age)
        }
    }
    
    

}
