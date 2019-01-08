//
//  publicConst.swift
//  ZFGT
//
//  Created by zhao on 2018/7/25.
//  Copyright © 2018年 allyoubank.com. All rights reserved.
//

import Foundation

import SnapKit

import SVProgressHUD

 


    


public let screen_height  = UIScreen.main.bounds.height
public let screen_width = UIScreen.main.bounds.width

public let screen_height_6 = 667
public let screen_width_6  = 375

public let auto_scale_x = CGFloat( screen_width) / CGFloat( screen_width_6);
public let auto_scale_y = screen_height == 812 ? 1 : CGFloat(screen_height) / CGFloat(screen_height_6);

let statusBarHei = screen_height == 812 ? 44 : 20
let safeAreaTopHei = screen_height == 812 ? 88 : 64
let safeAreaBottomHei = screen_height == 812 ? 34 : 0

public let mainOrangeColor = UIColor.colorWith(hexStr: "#FF7627")

// MARK: 时间戳变成时间yyyy MM dd HH:mm:ss
func transToTime(timestamp:String) -> String {
    let timeinter = Double(timestamp)
    let ttt : TimeInterval = timeinter!
    let date = Date.init(timeIntervalSince1970: ttt)
    
    let dateformatter = DateFormatter()
    dateformatter.timeZone = TimeZone.init(identifier: "Asia/Hong_Kong")
    dateformatter.dateFormat = "yyyy MM dd HH:mm:ss"
//    let timezoneee = NSTimeZone.system
//    dateformatter.timeZone = timezoneee
    
    let timeSs = dateformatter.string(from: date)
    
    return timeSs
}

func transToTimestamp(time:String) -> String {
    let dateformatter = DateFormatter()
    dateformatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateformatter.dateFormat = "yyyy MM dd HH:mm:ss"
//    dateformatter.dateStyle = DateFormatter.Style.medium
//    dateformatter.timeStyle = DateFormatter.Style.short
    
    let date = dateformatter.date(from: time)
    let timstamp = date?.timeIntervalSince1970
    let stampstr = "\(timstamp!)"
    return stampstr
}


// MARK: BUTTON按钮方法
func createButtonByCustom(normalImage:String?,normalTitle:String?,titleFont:CGFloat?,backgroundImage:String?,normalTitleColor:UIColor?) -> UIButton {
    let bbb = UIButton(type: UIButtonType.custom)
    if normalImage != nil {
        bbb.setImage(UIImage(named: normalImage!), for: UIControlState.normal)
    }
    if normalTitle != nil {
        bbb.setTitle(normalTitle, for: UIControlState.normal)
    }
    if titleFont != nil {
        bbb.titleLabel?.font = UIFont.systemFont(ofSize: titleFont!)
    }
    if backgroundImage != nil {
        bbb.setBackgroundImage(UIImage(named: backgroundImage!), for: UIControlState.normal)
    }
    if normalTitleColor != nil {
        bbb.setTitleColor(normalTitleColor, for: UIControlState.normal)
    }
    return bbb
    
}
// MARK: 加粗字体方法
/**
 加粗字体方法 (不改变字体字号只加粗文字)
 */
func boldFontForLabel(label:UILabel,isBold:Bool) {
    var fontname = label.font.fontName
    let size = label.font.pointSize
    if isBold {
        if fontname.hasSuffix("-Bold"){
//            本身是加粗字体不操作
        }else{
            fontname = fontname + "-Bold"
            label.font = UIFont.init(name: fontname, size: size)// 加粗
        }
    }else{
//        去除加粗
        if fontname.hasSuffix("-Bold"){
            fontname = fontname.replacingOccurrences(of: "-Bold", with: "")
            label.font = UIFont.init(name: fontname, size: size) // 去除加粗
        }
    }
}

// MARK: 富文本按照指定字  改变颜色或者大小
/**
 字体富文本之按照指定字范围改变颜色或者大小
 */
func changeStrColorWithGivenStr(totalStr : String , givenStr: String ,givenColor:UIColor   ) -> NSMutableAttributedString {
    let attrStr : NSMutableAttributedString = NSMutableAttributedString.init(string: totalStr)
    
    let nsstr = NSString(string: totalStr)
    
    let strRang = nsstr.range(of: givenStr)
    
    attrStr.addAttribute( NSAttributedStringKey.foregroundColor , value: givenColor, range: strRang)
    
    
    return attrStr
}

/**
 字体富文本之按照指定字范围改变颜色或者大小
 */
func getShortVersionStrWithPrefixx(prefix:String)-> String{
    let infodic = Bundle.main.infoDictionary
    if let dic = infodic {
        let app_Version = dic["CFBundleShortVersionString"] as! String
        if prefix.count > 0 && app_Version.count > 0 {
            let app_v = prefix + app_Version
            return app_v
        }
        return app_Version
    }
    return ""
}

//缩放图片
func scaleImageToScaleSize(ii:UIImage,scaleSi:CGFloat)->UIImage{
    UIGraphicsBeginImageContext(CGSize.init(width: ii.size.width * scaleSi, height: ii.size.height * scaleSi))
    ii.draw(in: CGRect.init(x: 0, y: 0, width:  ii.size.width * scaleSi, height: ii.size.height * scaleSi))
    let scaleimage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return scaleimage
}

//修正照片方向(手机转90度方向拍照)
func fixOrientation(aImage:UIImage)-> UIImage? {
    if  aImage.imageOrientation == UIImageOrientation.up {
        return aImage
    }
    var transform = CGAffineTransform.identity
    
    switch aImage.imageOrientation {
    case UIImageOrientation.down ,UIImageOrientation.downMirrored :
        print("")
        let trans = CGAffineTransform.init(translationX: aImage.size.width, y: aImage.size.height)
        let tra = CGAffineTransform.init(rotationAngle: .pi)
        transform.concatenating(trans)
        transform.concatenating(tra)

    case UIImageOrientation.left , UIImageOrientation.leftMirrored:
        let trans = CGAffineTransform.init(translationX: aImage.size.width, y: 0)
        let tra = CGAffineTransform.init(rotationAngle: .pi / 2)
        transform.concatenating(trans)
        transform.concatenating(tra)

    case UIImageOrientation.right , UIImageOrientation.rightMirrored:
        let trans = CGAffineTransform.init(translationX: 0, y: aImage.size.height)
        let tra = CGAffineTransform.init(rotationAngle: -.pi / 2)
        transform.concatenating(trans)
        transform.concatenating(tra)
    default:
        print("")
    }
    
    switch aImage.imageOrientation {
    case UIImageOrientation.upMirrored,UIImageOrientation.downMirrored:
        let trans = CGAffineTransform.init(translationX: aImage.size.width, y: 0)
        let tra = CGAffineTransform.init(scaleX: -1, y: 1)
        transform.concatenating(trans)
        transform.concatenating(tra)
        
    case UIImageOrientation.leftMirrored,UIImageOrientation.rightMirrored:
        let trans = CGAffineTransform.init(translationX: aImage.size.height, y: 0)
        let tra = CGAffineTransform.init(scaleX: -1, y: 1)
        transform.concatenating(trans)
        transform.concatenating(tra)
   
    default:
        print("")
    }
    
    guard let bitmapcontext = CGContext.init(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue) else {
        return nil
    }
    
    bitmapcontext.concatenate(transform)
    switch aImage.imageOrientation {
    case UIImageOrientation.left,UIImageOrientation.leftMirrored,UIImageOrientation.right,UIImageOrientation.rightMirrored:
//        context?.draw(context, in: CGRect.init(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
        
        bitmapcontext.draw(aImage.cgImage!, in: CGRect.init(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
    default:
        bitmapcontext.draw(aImage.cgImage!, in: CGRect.init(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
    }
    
    let cgimg = bitmapcontext.makeImage()
    let img = UIImage.init(cgImage: cgimg!)
    
    return img
}



