//
//  photoBrowserController.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/11.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import SVProgressHUD

let photoBrowserCollectionCellIdentifier = "photoBrowserCollectionCellIdentifier"
class photoBrowserController: UIViewController {
    
    var currentIndex:Int?
    var pictureUrls:[URL]?
    
    init(index:Int,urls:[URL])
    {
//        先初始化本类，再初始化父类
        currentIndex = index
        pictureUrls = urls
        super.init(nibName: nil, bundle: nil)
        
    }
    
    func setUpUI(){
        view.backgroundColor = UIColor.lightGray
        view.addSubview(collectionV)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        flowLayout.itemSize = UIScreen.main.bounds.size
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionV.frame = UIScreen.main.bounds
        collectionV.dataSource = self
        collectionV.isPagingEnabled = true
        collectionV.register(photoBrowserCustomCollectionViewCell.self, forCellWithReuseIdentifier: photoBrowserCollectionCellIdentifier)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

    @objc func closeAction(b:UIButton){
        dismiss(animated: true) {
            
        }
    }
    @objc func saveAction(b:UIButton){
        let index = collectionV.indexPathsForVisibleItems.last!
        let cell = collectionV.cellForItem(at: index) as! photoBrowserCustomCollectionViewCell
        let image = cell.itemImageView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)) , nil)
    }
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject){
        if error != nil{
            SVProgressHUD.showError(withStatus: "保存失败")
        }else{
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    MARK: 懒加载控件
    private lazy var saveButton : UIButton = {
        let bbb = createButtonByCustom(normalImage: nil, normalTitle: "保存", titleFont: nil, backgroundImage: nil, normalTitleColor: UIColor.white)
        bbb.backgroundColor = UIColor.darkGray
        bbb.addTarget(self, action: #selector(saveAction(b:)), for: UIControlEvents.touchUpInside)
        return bbb
        
    }()
    
    private lazy var closeButton : UIButton = {
       let bbb = createButtonByCustom(normalImage: nil, normalTitle: "关闭", titleFont: nil, backgroundImage: nil, normalTitleColor: UIColor.white)
        bbb.backgroundColor = UIColor.darkGray
        bbb.addTarget(self, action: #selector(closeAction(b:)), for: UIControlEvents.touchUpInside)
        return bbb
        
    }()
    var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionV : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
}

extension photoBrowserController : UICollectionViewDataSource,photoBrowserCellDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCollectionCellIdentifier, for: indexPath) as! photoBrowserCustomCollectionViewCell
        cell.backgroundColor = UIColor.randomColor()
        cell.imageUrl = pictureUrls?[indexPath.item]
        cell.cellDelegate = self
        return cell
        
    }
    
    func photoDidClose(cell: photoBrowserCustomCollectionViewCell) {
        dismiss(animated: true) {
            
        }
    }
    
    
}
