//
//  composeViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/12.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class composeViewController: UIViewController {
    private lazy var emoticonVC:emoticonViewController = emoticonViewController {[weak self] (emo) in
        guard self != nil else{
            return
        }
        let strongSelf = self
        strongSelf?.textView.insertEmotionicon(emo: emo, font: 0)
        
    }
    var toolBarBottomConstrait : Constraint?
    var photoTopConstraint : Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardChange(notify:)) , name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        addChildViewController(emoticonVC)
        addChildViewController(photoSelector)
        
        setUpNav()
        setUpInputView()
        setUpPhotoView()
        setUpToolBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.photoSelector.view.frame.origin.y < UIScreen.main.bounds.origin.y  {
            textView.becomeFirstResponder()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    func setUpNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action:#selector(closeVC) )
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendMessage) )
        navigationItem.rightBarButtonItem?.isEnabled = false
//        导航栏
        let titleView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 32))
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 15)
        label.text = "发微博"
        label.sizeToFit()
        let labelll = UILabel.createLabel(color: UIColor(white: 0.0, alpha: 0.5 ), fontSize: 15)
        labelll.text = userAccToken.loadAccountMess()?.screen_name ?? ""
        labelll.sizeToFit()
        
        titleView.addSubview(label)
        titleView.addSubview(labelll)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        labelll.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        navigationItem.titleView = titleView
        
    }
    func setUpPhotoView(){
        view.insertSubview(photoSelector.view, belowSubview: toolBar)
        photoSelector.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            self.photoTopConstraint = make.top.equalTo(screen_height).constraint
        }
    }
    func setUpToolBar(){
        view.addSubview(toolBar)
        view.addSubview(tipLabel)
//        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
//                            ["imageName": "compose_mentionbutton_background"],
//                            ["imageName": "compose_trendbutton_background"],
//                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
//                            ["imageName": "compose_addbutton_background"]]
        let item = UIBarButtonItem.createBarButtonItem(imageName: "compose_toolbar_picture", target: self, action: #selector(selectPicture))
        let item2 = UIBarButtonItem.createBarButtonItem(imageName: "compose_mentionbutton_background", target: self, action: nil)
        let item3 = UIBarButtonItem.createBarButtonItem(imageName: "compose_trendbutton_background", target: self, action: nil)
        let item4 = UIBarButtonItem.createBarButtonItem(imageName: "compose_emoticonbutton_background", target: self, action: #selector(inputEmoticon))
        let item5 = UIBarButtonItem.createBarButtonItem(imageName: "compose_addbutton_background", target: self, action: nil)
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let items = [item,flexible,item2,flexible,item3,flexible,item4,flexible,item5]
        
        toolBar.items = items
        
//        布局toolbar
        toolBar.snp.makeConstraints { (make) in
            self.toolBarBottomConstrait = make.bottom.equalToSuperview().constraint
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
//        tipLabel.text = "150"
        tipLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
    }
    @objc func selectPicture()
    {
// 关闭键盘
        textView.resignFirstResponder()
        self.photoTopConstraint?.update(offset: screen_height*0.4)
    }
    @objc func inputEmoticon()
    {
//        如果是是系统自带的键盘，inputview = nil
//        如果 不是系统自带的键盘，inputview ！=nil
        textView.resignFirstResponder()
        
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        textView.becomeFirstResponder()
    }
    @objc func keyboardChange(notify:Notification){
        print(notify)
//        取出键盘高度
        let rect = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        修改工具条的约束
        let y = rect.cgRectValue.origin.y
        
        toolBarBottomConstrait?.update(offset: -(UIScreen.main.bounds.size.height-y))
    }
    
    
    
    private func setUpInputView(){
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(5)
        }
    }
//    MARK: 左边关闭页面
    @objc func closeVC()
    {
        dismiss(animated: true) {
            
        }
    }
    //    MARK: 右边头部按钮发送微博数据
    @objc func sendMessage(){
        
        let text = textView.getTextViewString()
        let image = photoSelector.pictureImages.first
        
        httpSessionMTool.shareNetWorkTool().sendStatus(text: text, image: image, successCallback: { (status) in
            SVProgressHUD.showInfo(withStatus: "成功")
            self.closeVC()
        }) { (error) in
            SVProgressHUD.showError(withStatus: "发送失败")
        }
        
            
    }
    lazy var textView : UITextView = {
       let tt = UITextView()
        tt.delegate = self
        return tt
    }()
    lazy var placeholderLabel : UILabel = {
       let ll = UILabel.createLabel(color: UIColor.darkGray, fontSize: 13)
        ll.text = "share some thing ......"
        return ll
    }()
    lazy var toolBar:UIToolbar = UIToolbar()
    lazy var photoSelector = photoSelectorViewController()
    lazy var tipLabel:UILabel = {
       let lll = UILabel.createLabel(color: UIColor.gray, fontSize: 16)
        return lll
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}
private let maxTipLength = 10
extension composeViewController : UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        let count = textView.getTextViewString().count
        let res = maxTipLength - count
        tipLabel.textColor = (res > 0) ? UIColor.darkGray : UIColor.red
        tipLabel.text = res == maxTipLength ? "" : "\(res)"
    }
}
