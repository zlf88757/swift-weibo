//
//  commonRefreshControlll.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/9.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class commonRefreshControlll: UIRefreshControl {

    override init() {
        super.init()
        setUpUI()
        
        
    }
    private func setUpUI(){
        addSubview(refreshView)
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    private var rotateArrowFlag = false
    private var loadingAnimFlag = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("-----监听变化的y值-----",frame.origin.y)
        if frame.origin.y >= 0{
            return
        }
        if isRefreshing && !loadingAnimFlag{
            print("圈圈加载中的动画")
            loadingAnimFlag = true
            refreshView.startLoadingViewAnim()
            return
        }
        
        if frame.origin.y < -50 && !rotateArrowFlag{
//            print("翻转")
            rotateArrowFlag = true
            refreshView.rotationArrow(flag: rotateArrowFlag)
        }else if frame.origin.y > -50 && rotateArrowFlag{
            rotateArrowFlag = false
//            print("翻转回来")
            refreshView.rotationArrow(flag:rotateArrowFlag)
        }
        
    }
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingViewAnim()
        loadingAnimFlag = false
    }
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    private lazy var refreshView:commonRefreshView = commonRefreshView.refreshView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class commonRefreshView: UIView {
    @IBOutlet weak var arrowIMG: UIImageView!
    
    @IBOutlet weak var refreshingIMG: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    func rotationArrow(flag:Bool) {
        var angle = Double.pi
        angle += flag ? -0.01 : 0.01
        
        UIView.animate(withDuration: 0.2) {
            self.arrowIMG.transform =  self.arrowIMG.transform.rotated(by: CGFloat(angle))
        }
    }
    func startLoadingViewAnim() {
//        注意防止重复添加动画
        tipView.isHidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        refreshingIMG.layer.add(anim, forKey: nil)
    }
    func stopLoadingViewAnim() {
        tipView.isHidden = false
        refreshingIMG.layer.removeAllAnimations()
    }
    
    class func refreshView() ->commonRefreshView {
    
        return Bundle.main.loadNibNamed("commonRefreshView", owner: nil, options: nil)?.last as! commonRefreshView
    }
    
    
}
