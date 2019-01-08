//
//  QRcodeViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeViewController: UIViewController , UITabBarDelegate{

    @IBOutlet weak var containerHeiCons: NSLayoutConstraint!
    @IBOutlet weak var scanLineIMGV: UIImageView!
    
    @IBOutlet weak var ScanLinetopConst: NSLayoutConstraint!
    @IBOutlet weak var dismissVC: UIBarButtonItem!
    
    @IBOutlet weak var customTabbar: UITabBar!
    
    @IBOutlet weak var messLabel: UILabel!
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var scanQRcode: UITabBarItem!
    
    @IBOutlet weak var showQRcode: UITabBarItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabbar.selectedItem = customTabbar.items![0]
        customTabbar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimationS()
//        开始扫描
        startScanQRcode()
    }
    func startScanQRcode()  {
//1、判断是否能将输入添加到会话
        if !session.canAddInput(deviceInput!) {
            return
        }
        
//2、是否将输出添加到会话
        if !session.canAddOutput(output){
            return
        }
//3、输入和输出都添加到会话
        session.addInput(deviceInput!)
        session.addOutput(output)
//4、设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
//5、设置输出对象代理，只要解析成功通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
//       系统提供不会只扫描一个，但是可以设置一个区域来扫描区域才显示
//        output.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        
//6、添加预览图层
      view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.addSublayer(drawLayer)
//7、告诉session 开始扫描
        session.startRunning()
        
    }

    func startAnimationS() {
        self.ScanLinetopConst.constant = -self.containerHeiCons.constant
//        view.layoutIfNeeded()// 这个要添加，不然会混乱
        UIView.animate(withDuration: 6.0, animations: {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.ScanLinetopConst.constant = self.containerHeiCons.constant
            
            self.view.layoutIfNeeded()// 添加
        })
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
           self.containerHeiCons.constant = 400
        }else{
           self.containerHeiCons.constant = 200
        }
        
        self.scanLineIMGV.layer.removeAllAnimations()
        startAnimationS()
        
    }
    
//输入设备
    lazy var session : AVCaptureSession = AVCaptureSession()
    lazy var deviceInput : AVCaptureDeviceInput? = {
        let devi = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let deviceInput = try AVCaptureDeviceInput(device: devi!)
            return deviceInput
        }catch{
            print(error)
            return nil
        }
    }()
   
    lazy var output : AVCaptureMetadataOutput = {
    let outp = AVCaptureMetadataOutput()
        return outp
    }()
    
//    创建预览图层
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = self.view.frame
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return layer
    }()
    lazy var drawLayer: CALayer = {
       let layer = CALayer()
        layer.frame = self.view.frame
        return layer
    }()

}

extension QRcodeViewController : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(metadataObjects)
        print(metadataObjects.last)
        
        clearDrawLayer()
        
        for obj in  metadataObjects {
            if obj  is  AVMetadataMachineReadableCodeObject
            {
                let codeobj = previewLayer.transformedMetadataObject(for: obj )
                print(codeobj)
                drawCornerLayer(codeobj: codeobj as! AVMetadataMachineReadableCodeObject)
            }
        }
        
        
    }
    
    func drawCornerLayer(codeobj : AVMetadataMachineReadableCodeObject) {
        
   /*     let layer = CAShapeLayer()
        layer.lineWidth = 3
        layer.lineJoin = "round"
        layer.strokeColor = UIColor.red.cgColor
        layer.path = UIBezierPath(rect: CGRect(x: 100, y: 100, width: 100, height: 100)).cgPath
        drawLayer.addSublayer(layer)   */
        
        if codeobj.corners.isEmpty {
            return
        }
        let layer = CAShapeLayer()
        layer.lineWidth = 3
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        layer.path = drawCornersPath(corners: codeobj.corners as NSArray)
        drawLayer.addSublayer(layer)
        
    }
    
    func drawCornersPath(corners:NSArray) -> CGPath {
        let path = UIBezierPath()
        var  point  =  CGPoint.zero
        var index = 0
        
        point  =  CGPoint.init(dictionaryRepresentation: corners[index]  as! CFDictionary)!
        path.move(to: point)
        
        while index < corners.count {
            point = CGPoint.init(dictionaryRepresentation: corners[index]  as! CFDictionary)!
            path.addLine(to: point)
        }
        path.close()
        return path.cgPath
        
    }
    
    func clearDrawLayer()  {
        if drawLayer.sublayers?.count == 0 || drawLayer.sublayers == nil{
            return
        }
        for layer in drawLayer.sublayers!{
            layer.removeFromSuperlayer()
        }
    }
    
}
