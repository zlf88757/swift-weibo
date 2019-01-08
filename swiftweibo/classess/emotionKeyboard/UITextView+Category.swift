//
//  UITextView+Category.swift
//  表情键盘
//
//  Created by zhaolingfei on 2018/9/18.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit


extension UITextView{
    
    func insertEmotionicon(emo:emotionIcons,font:CGFloat){
        
        if emo.isRemoveButton{
            deleteBackward()
        }
        
        if emo.emotionString != nil{
            self.replace(self.selectedTextRange!, withText: emo.emotionString! )
        }
        if emo.png != nil{
            //            1、创建附件
            //            let attachment = NSTextAttachment()
            //            let attachment = emotionAttachment()
            //            attachment.chs = emo.chs
            //
            //            attachment.image = UIImage(contentsOfFile: emo.imagePath!)
            //            attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
            ////            根据附件创建属性字符串
            //            let imageAttriText = NSAttributedString(attachment: attachment)
            //            创建含有表情的字符串,默认大小是17，可以修改
            let imageAttriText = emotionAttachment.imageText(emoticon: emo, font:self.font ?? UIFont.systemFont(ofSize: 17))
            let MutableStr = NSMutableAttributedString(attributedString: self.attributedText)
            let range = self.selectedRange
            MutableStr.replaceCharacters(in: range, with: imageAttriText)
            MutableStr.addAttributes([NSAttributedStringKey.font : self.font ?? UIFont.systemFont(ofSize: 17)], range: NSRange(location: range.location, length: 1))
            self.attributedText = MutableStr;
            //            重新定位光标的位置
            self.selectedRange = NSRange(location: range.location + 1, length: 0)
            delegate?.textViewDidChange!(self)
            
        }
    }
    
    func getTextViewString()->String{
        var strM = String()
        self.attributedText.enumerateAttributes(in: NSRange(location: 0, length: self.attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objc, range, _) in
            //            print(objc,"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
            //            遍历的时候传递是一个objc字典，如果字典中NSAttachment这个key有值，那么证明当前是一个图片
            //            range就是纯字符串的范围，如果纯字符串中间有图片，那么range会传递多次
            
            //            print(range,"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
            //            let res = (self.customTextView.text as NSString).substring(with: range)
            //            print(res)
            //            print("++++++_____++++++")
            if objc[NSAttributedStringKey.attachment] != nil {
                let attachment = objc[NSAttributedStringKey.attachment] as! emotionAttachment
                strM += attachment.chs!
            }else{
                strM += (self.text as NSString).substring(with: range)
            }
            
        }
//        print("strM=\(strM)")
        return strM
    }
}
