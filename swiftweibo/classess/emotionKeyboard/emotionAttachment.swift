//
//  emotionAttachment.swift
//  表情键盘
//
//  Created by zhaolingfei on 2018/9/18.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class emotionAttachment: NSTextAttachment {
    var chs:String?

    class func imageText(emoticon:emotionIcons,font:UIFont)->NSAttributedString{
        let attachment = emotionAttachment()
        attachment.chs = emoticon.chs
        
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s + 2, height: s + 2)
        //            根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}
