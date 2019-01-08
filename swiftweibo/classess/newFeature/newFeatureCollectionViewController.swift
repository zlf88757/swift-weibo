//
//  newFeatureCollectionViewController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/8/13.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class newFeatureCollectionViewController: UICollectionViewController {

    private let pageCount = 4
    private var layout:newFeatureFlowLayout = newFeatureFlowLayout()
    
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        collectionView?.register(newFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
    

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return pageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! newFeatureCell
    
        // Configure the cell
        
        cell.imageIndex = indexPath.item
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        let path = collectionView.indexPathsForVisibleItems.last!
//        print("-------",path.item)
        if path.item == pageCount - 1  {
            let cell = collectionView.cellForItem(at: path) as! newFeatureCell
            cell.btnAnimation()
        }
        
    }


}
class newFeatureFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
        
    }
    
}
private class newFeatureCell:UICollectionViewCell
{
    var imageIndex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(String(describing: imageIndex! + 1))")
           
            bottomBtn.isHidden = imageIndex == 3 ? false : true
//            原先在此处赋值动画，现在放到了cell显示完之后方法里面
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnAnimation() {
//        let ani = CAKeyframeAnimation(keyPath: "transform.scale");
//        ani.values = [1.0,1.2,1.4,1.2,1.0]
//        ani.duration = 9
////        ani.repeatCount = MAXFLOAT
//        ani.calculationMode = kCAAnimationCubic
//        bottomBtn.layer.add(ani, forKey: nil)
        
//        bottomBtn.isHidden = false
        
        bottomBtn.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        bottomBtn.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
//            清空形变
            self.bottomBtn.transform = CGAffineTransform.identity
        }) { (_) in
            self.bottomBtn.isUserInteractionEnabled = true
        }
    }
//    在APPdelegate中切换根视图控制器
    
    @objc func startButtonClick()  {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZLFSwitchRootViewControllerKey), object: true)
    }
    
    private func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(bottomBtn)
        weak var weakSelf = self
        iconView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.equalTo()(0)
            make.left.equalTo()(0)
            make.right.equalTo()(0)
            make.bottom.equalTo()(0)
        }
        bottomBtn.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.centerX.equalTo()(weakSelf?.contentView.mas_centerX)
            make.bottom.equalTo()(-20)
        }
    }
    private lazy var iconView = UIImageView()
    private lazy var bottomBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(startButtonClick), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
}
