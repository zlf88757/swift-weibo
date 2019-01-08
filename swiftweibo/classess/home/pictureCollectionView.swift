//
//  pictureCollectionView.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/6.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

import SDWebImage

let pictureBrowserNotifInfoKey = "pictureBrowserNotifInfoKey"
let pictureBrowserNotifUrlKey = "pictureBrowserNotifUrlKey"
let pictureBrowserNotifSelectName = "pictureBrowserNotifSelectName"

class pictureCollectionView: UICollectionView {
    
    var status:Status?{
        didSet{
            
            reloadData()
        }
    }
    var picturelayout = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: picturelayout)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpUI(){
        register(pictureViewCollectionViewCell.self, forCellWithReuseIdentifier: ZLFPictureViewCellReuseIdentifier)
        dataSource = self
        delegate = self
        
        picturelayout.minimumLineSpacing = 10
        picturelayout.minimumInteritemSpacing = 10
        
        backgroundColor = UIColor.darkGray
        
    }
    
    func calculateImageSize()->CGSize{
        //        1、取出配图的URL个数
        let count = status?.storedPicUrls?.count
        //        2、如果个数为0，返回zero
        if count == 0 || count == nil{
            
            picturelayout.itemSize = CGSize(width: 0.1, height: 0.1)
            
            return CGSize.zero
        }
        //        3、一张配图，返回实际大小
        if count == 1 {
            let key = status?.storedPicUrls!.first?.absoluteString
            let cacheImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
            picturelayout.itemSize = cacheImage!.size
            return cacheImage!.size
        }
        //        4、4张配图，田字格的大小情况
        let width = 90 // 固定宽度 高度一致
        let margin = 10
        if count == 4 {
            let subWidth = width * 2 + margin
            picturelayout.itemSize = CGSize(width: width, height: width)
            return CGSize(width: subWidth, height: subWidth)
        }
        //  5、如果是多张配图，计算九宫格大小  情况有：2、3   5、6   7、8、9
        //        5.1计算列数
        let colNum = 3
        //        5.2计算行数
        let rowNum = (count! - 1)/3+1
        //        宽度 = 列数 * 图片宽度 + （列数 - 1） * 间隙
        let viewWidth = colNum * width + (colNum - 1) * margin
        let viewHeight = rowNum * width + (rowNum - 1)*margin
        picturelayout.itemSize = CGSize(width: width, height: width)
        return CGSize(width: viewWidth, height: viewHeight)
        
    }
    
}
extension pictureCollectionView:UICollectionViewDataSource,UICollectionViewDelegate
{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZLFPictureViewCellReuseIdentifier, for: indexPath) as! pictureViewCollectionViewCell
        cell.imageUrl = status?.storedPicUrls![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicUrls?.count ?? 0
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cc = [pictureBrowserNotifInfoKey:indexPath,pictureBrowserNotifUrlKey:status!.largePictureUrlsSelect!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: pictureBrowserNotifSelectName), object: self, userInfo:cc)
        
    }
    
    
}

