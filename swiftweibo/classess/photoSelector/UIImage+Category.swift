//
//  UIImage+Category.swift
//  图片选择器
//
//  Created by zhaolingfei on 2018/9/21.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
extension UIImage{
    /**
     制定宽度
     */
    func imageWithScale(ToWidth:CGFloat)->UIImage {
        let height = ToWidth * size.height / size.width
        let ToSize = CGSize(width: ToWidth, height: height)
        UIGraphicsBeginImageContext(ToSize)
        draw(in: CGRect(origin: CGPoint.zero, size: ToSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
