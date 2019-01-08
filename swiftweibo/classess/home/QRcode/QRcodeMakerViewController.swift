//
//  QRcodeMakerViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class QRcodeMakerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    private func creatQRCodeImage() -> UIImage{
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据
        filter?.setValue("myswift".data(using: String.Encoding.utf8), forKey: "inputMessage")
        
        // 4.从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        //        return UIImage(CIImage: ciImage!)
        let bgImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: 300)
        
        // 5.创建一个头像
        let icon = UIImage(named: "nange.jpg")
        
        // 6.合成图片(将二维码和头像进行合并)
        let newImage = creteImage(bgImage: bgImage, iconImage: icon!)
        
        // 7.返回生成好的二维码
        return newImage
    }
    
    /**
     合成图片
     
     :param: bgImage   背景图片
     :param: iconImage 头像
     */
    private func creteImage(bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        // 3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage!
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent
//            CGRectIntegral(image.extent)
        let scale: CGFloat = min(size / (extent.size.width), size / (extent.size.height))
        
        // 1.创建bitmap;
        let width = (extent.size.width) * scale
        let height =  ( extent.size.width ) * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
//        bitmapRef.interpolationQuality
        
//        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.none)
//        CGContextScaleCTM(bitmapRef, scale, scale);
//        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
//        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!

        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    // MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
}
