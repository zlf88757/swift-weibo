//
//  ex.swift
//  ZFGT
//
//  Created by zhao on 2018/8/20.
//  Copyright © 2018年 allyoubank.com. All rights reserved.
//

import UIKit

class ex: NSObject {

}
enum HomeworkError : Int, Error {
    case forgotten
    case lost
    case dogAteIt
}
extension HomeworkError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .forgotten: return NSLocalizedString("I forgot it", comment: "I forgot it")
        case .lost: return NSLocalizedString("I lost it", comment: "I lost it")
        case .dogAteIt: return NSLocalizedString("The dog ate it", comment: "The dog ate it")
        }
    }
}
public protocol CustomNSError : Error {
    
    /// The domain of the error.
    static var errorDomain: String { get }
    
    /// The error code within the given domain.
    var errorCode: Int { get }
    
    /// The user-info dictionary.
    var errorUserInfo: [String : Any] { get }
}



extension UIColor{
    
    class func randomColor() ->UIColor{
        return UIColor(red: randomNum(), green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    class func randomNum() ->CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
    
}
// 下标截取任意位置的便捷方法
extension String {
    
    func urlEncodeString(inputStr:String) -> String{
        let charactersToescape = "?!@#$%^&*+,:;='\"`<>(){}/\\|"
        let allowedCharacter = CharacterSet.init(charactersIn: charactersToescape).inverted
        let upStr = inputStr.addingPercentEncoding(withAllowedCharacters: allowedCharacter)
        return upStr!
        
    }
    func decoderUrlEncodeString(input:String) -> String
    {
        let output = input.replacingOccurrences(of: "+", with: "", options: String.CompareOptions.literal , range: input.startIndex..<input.endIndex)
        return output.removingPercentEncoding!
    }
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
   
    
}
extension UILabel{
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    
}

extension NSDate{
    
    class func myDateWith(timeString:String)-> NSDate
    {
        
//        1、将服务器返回的时间字符串转换成为Date返回字符串"Sun Sep 12 14:50:57 +0800 2014"
//        创建formatter
        let formatter = DateFormatter()
        
//        设置时间格式
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
//        设置时间区域 设置时间区域使用NSDateFormatter转换时间字符串时，默认的时区是系统时区，例如在中国一般都是北京时间(+8)，如果直接转换会导致结果相差8小时，所以一般的做法是先指定时区为GMT标准时间再转换
        formatter.locale = Locale.init(identifier: "en")
//        转换字符串，返回Date
        let date = formatter.date(from: timeString)! as NSDate

        return date
        
    }
    
    /**
     刚刚（一分钟内）
     X分钟前（一小时内）
     X小时前（当天）
     昨天 HH:mm（昨天）
     MM-dd HH:mm (一年内)
     yyyy-MM-dd HH:mm (更早时候)
     */
    
    var descDate:String {
        let calendar = Calendar.current
        
        
//        判断是否今天
        if calendar.isDateInToday(self as Date){
            // 1.0获取当前时间和系统时间之间的差距(秒数) Date() 表示当前时间
            let since = Int(Date().timeIntervalSince(self as Date))
            print("当前时间和系统时间之间的差距(秒数) since = \(since)")
            if since < 60
            {
               return "刚刚"
            }
            if since < 60*60{
                return "\(since/60)分钟前"
            }
            return "\(since/(3600))小时前"
        }
//        1.1是否 - 刚刚
//        1.2多少分钟一期
//        1.3多少小时以前
        
        
//        2判断是否昨天
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self as Date) {
            formatterStr = "昨天" + formatterStr
        }else{
            //        3一年内
            
            formatterStr = "MM-dd" + formatterStr
            
            //        4 更早的时候
            let component = calendar.component(Calendar.Component.year, from: self as Date)
            if component >= 1{
                formatterStr = "yyyy-" + formatterStr
            }
            
        }
        
        let formatterr = DateFormatter()
        formatterr.dateFormat = formatterStr
        formatterr.locale = Locale.init(identifier: "en")
        

        
        
        
        
        
        return formatterr.string(from: self as Date)
    }
    

    
}


