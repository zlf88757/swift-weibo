//
//  emotionIconPackage.swift
//  表情键盘
//
//  Created by zhaolingfei on 2018/9/14.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class emotionIconPackage: NSObject {
    var id : String?
    var group_name_cn:String?
    var emotionIconArray:[emotionIcons]?
    
    static let packageList:[emotionIconPackage] = emotionIconPackage.loadPackages()
    
    class func emotionIconStr(str:String)->NSAttributedString? {
        var strMutableAttr = NSMutableAttributedString.init(string: str)
        do {
            //            swift \是特殊，\[，用\ 转义
            let pattern = "\\[.*?\\]"
            
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let result = regex.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: str.count))
            var count = result.count
            while count > 0 {
                count = count - 1
                let checkingRes = result[count]
                let sss = (str as NSString).substring(with: checkingRes.range)
                print(sss)
                if let emo =  self.emotionWithStr(str: sss){
                    let attrStr = emotionAttachment.imageText(emoticon: emo, font: UIFont.boldSystemFont(ofSize: 17))
                    strMutableAttr.replaceCharacters(in: checkingRes.range, with: attrStr)
                }
            }
            
            return strMutableAttr
            
        } catch  {
            print("找寻表情字符串出错")
            return nil
        }
    }
    
    
    /**
     根据表情文字找到对应的表情模型
     param： str 表情文字
     return 表情模型
     */
    class func emotionWithStr(str:String)->emotionIcons?{
        
        var emotionicon : emotionIcons?
        for package in emotionIconPackage.packageList {
            emotionicon = package.emotionIconArray?.filter({ (emo) -> Bool in
                return emo.chs == str
            }).first
            if emotionicon != nil{
                break
            }
        }
        return emotionicon
    }
    
    private class func loadPackages()->[emotionIconPackage]{
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
//        创建最近 的分组
        var packages = [emotionIconPackage]()
        let defaultPackage = emotionIconPackage(id: "")
        defaultPackage.group_name_cn = "最近"
        defaultPackage.emotionIconArray = [emotionIcons]()
        defaultPackage.appendEmtyEmotionicon()
        packages.append(defaultPackage)
        
        
        let dic = NSDictionary(contentsOfFile: path!)
        let dicarr = dic!["packages"] as! [[String:AnyObject]]
        
        for i in dicarr{
            let package = emotionIconPackage(id: i["id"] as! String)
            
            package.loadEmotionIconsPath()
            package.appendEmtyEmotionicon()
            packages.append(package)
            
        }
        
        
        return packages
    }
    func loadEmotionIconsPath(){
        print(infoPath())
        print("---------separator-------")
        
        let emoticonDic = NSDictionary(contentsOfFile: infoPath())
        let group_name_cn = emoticonDic!["group_name_cn"] as! String
        self.group_name_cn = group_name_cn
        print(group_name_cn)
        var index = 0
        emotionIconArray = [emotionIcons]()
        let em = emoticonDic!["emoticons"] as! [[String:String]]
        for i  in em {
            if index == 20{
                emotionIconArray?.append(emotionIcons(isRemoveBtn: true))
                index = 0
            }
            let  e = emotionIcons(dic:i,id:self.id!)
            emotionIconArray?.append(e)
            index = index + 1
        }
    }
//    这里是处理所有的（3个模块后面） 空白添加 和 删除按钮添加 追加空白按钮的数据
    func appendEmtyEmotionicon(){
        let leftcount = emotionIconArray!.count % 21
        
//       追加空白按钮
        for _ in leftcount..<20{
            emotionIconArray?.append(emotionIcons(isRemoveBtn: false))
        }
        emotionIconArray?.append(emotionIcons(isRemoveBtn: true))
        
    }
//    传入第0组的emotionicons，添加和删除以前的空白
    func appendRecentEmotion(emo:emotionIcons){
//        如果是删除按钮就不用添加到最近的分组
        if emo.isRemoveButton{
            return
        }
        if emo.id == nil {
            return
        }
//        判断是否已经添加
        let contains = self.emotionIconArray?.contains(emo)
        if !contains!{
            emotionIconArray?.removeLast()
            self.emotionIconArray?.insert(emo, at: 0)
        }
        var result = emotionIconArray?.sorted(by: { (emo1, emo2) -> Bool in
            return emo1.times > emo2.times
        })
        if !contains! {
            result?.removeLast()
            result?.append(emotionIcons(isRemoveBtn: true))
        }
        self.emotionIconArray = result
        
    }
    
    func infoPath()->String{
        return (emotionIconPackage.emotioniconPath().appendingPathComponent(self.id!) as NSString).appendingPathComponent("info.plist")
        
    }
    class func emotioniconPath()->NSString{
        let nsstring = (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle")
        return nsstring as NSString
    }
    init(id:String){
        super.init()
        self.id = id
    }

}
@objcMembers class emotionIcons : NSObject{
    var chs : String?
    var id : String?
    var png : String?{
        didSet{
            imagePath = (emotionIconPackage.emotioniconPath().appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
        }
    }
    var code : String?{
        didSet{
            let scanner = Scanner.init(string:code!)
            var result : UInt32 = 0
            scanner.scanHexInt32(&result)
            //        将十六进制转换字符串
            let string = Character(Unicode.Scalar(result)!)
            emotionString = String(string)
            
        }
    }
    
    var emotionString:String?
    var imagePath: String?
    var isRemoveButton:Bool = false
    var times:Int = 0
    
    init(isRemoveBtn:Bool){
        super.init()
        self.isRemoveButton = isRemoveBtn
    }
    
    init(dic:[String:String], id : String){
        super.init()
        self.id = id
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
