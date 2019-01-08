//
//  httpSessionMTool.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/29.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class httpSessionMTool: AFHTTPSessionManager {
    
    
    private static let onceIns : httpSessionMTool = {
    
        let url = URL(string: "https://api.weibo.com/")
        let t = httpSessionMTool(baseURL:url)
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return t
    
    }()
    
    
    
    override func mutableCopy() -> Any {
        return httpSessionMTool.onceIns
    }
    
    class func shareNetWorkTool() -> httpSessionMTool{
        return onceIns
    }
    func sendStatus(text:String,image:UIImage?,successCallback:@escaping (_ sta:Status)->(),errorCallback:@escaping (_ error:Error)->()){
        
        var path = "2/statuses/"
        if  image != nil {
            
            path += "upload.json"
            let params = ["":userAccToken.loadAccountMess()!.access_token,"":text]
            post(path, parameters: params, constructingBodyWith: { (formData) in
                //                将数据转换为二进制
                let data = UIImagePNGRepresentation(image!)!
                //                上传数据
                /**
                 第一个参数，需要上传的二进制数据
                 第二个参数，服务端对应哪个字段名称
                 第三个参数，文件的名称（大部分可以随便写，服务端会重命名）
                 第四个参数，数据类型，通用的类型
                 */
                formData.appendPart(withFileData: data, name: "pic", fileName: "abc.png", mimeType: "application/octet-stream")
                
                
            }, progress: { (progress) in
                print("---progress---",progress)
            }, success: { (task, response) in
//                SVProgressHUD.showInfo(withStatus: "成功")
                successCallback(Status(dic: response as! [String:AnyObject]))
            }) { (task, error) in
                errorCallback(error)
            }
            
        }else{
            
            path += "update.json"
            let str = text.urlEncodeString(inputStr: text)
            let params = ["access_token":userAccToken.loadAccountMess()?.access_token!,"status":str]
            post(path, parameters: params, progress: { (progress) in
                
            }, success: { (task, response) in
//                print(response)
//                SVProgressHUD.showSuccess(withStatus: "发送成功")
                successCallback(Status(dic: response as! [String:AnyObject]))
                
            }) { (_, error) in
//                print(error)
//                SVProgressHUD.showError(withStatus: "发送失败")
                
                errorCallback(error)
                
                
            }
        }

    }
    
    
    
}
