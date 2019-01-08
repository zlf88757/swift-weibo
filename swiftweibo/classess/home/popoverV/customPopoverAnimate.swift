//
//  customPopoverAnimate.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/28.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

let popoverAniWillShow     =  "popoverAniWillShow"
let popoverAniWillDismiss  =  "popoverAniWillDismiss"


protocol customPopoverAnimateDelegate : NSObjectProtocol {
    
}

class customPopoverAnimate: NSObject ,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
    var isPresented : Bool = false
    var presentedVFrame  = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        print("----tovc----fromvc",toVC,fromVC)
        
        if isPresented {
            
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            print("----toview----fromview",toView,fromView)
            //           视图添加到容器上面
            transitionContext.containerView.addSubview(toView)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
//            从上面方法获取相同时间做动画即可
            UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                toView.transform = CGAffineTransform.identity
                
            }) { (_) in
                transitionContext.completeTransition(true)
            }
            
        }else{
            
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
  
        }
        
        
    }
    
    //    uipresentationcontroller 专门负责转场动画
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let presentC = customPopoverPresentVC(presentedViewController: presented, presenting: presenting)
        presentC.presentedVFrame = presentedVFrame
        
        return presentC
        
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = true
//        发送通知控制器要展开
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: popoverAniWillShow) , object: self)
        return self
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = false
//        发送通知控制器要消失了
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: popoverAniWillDismiss), object: self)
        return self
    }
    
}
