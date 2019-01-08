//
//  photoSelectorViewController.swift
//  图片选择器
//
//  Created by zhaolingfei on 2018/9/20.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
let photoSelectorCellIdentifier = "photoSelectorCellIdentifier"
class photoSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

    }
    func setUpUI(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.red
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = [NSLayoutConstraint]()
        let dic = ["collectionView":collectionView]
        constraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        constraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        view.addConstraints(constraint)
    }

    
    lazy var collectionView:UICollectionView = {
        let collectionv = UICollectionView(frame: CGRect.zero, collectionViewLayout: photoFlowLayout())
        collectionv.dataSource = self
        collectionv.register(photoSelectCollectionCell.self, forCellWithReuseIdentifier: photoSelectorCellIdentifier)
        return collectionv
    }()
    lazy var pictureImages = [UIImage]()
}
extension photoSelectorViewController : UICollectionViewDataSource ,photoSelectorCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func photoDidSelector(cell: photoSelectCollectionCell) {
//        判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            print("不能打开相册")
            return
        }
//        创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self
//        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        present(vc, animated: true) {
            
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /**
         注意了：一般情况下，只要涉及到从相册获取图片的功能，都需要处理内存
         一般情况下，一个应用程序启动占用20M左右内存，当内存飙升到500M系统就会发出内存警告，这个时候就需要释放内存，否则就会闪退
         只要内存在100M左右，系统就不会闪退
         也就是说，一个应用程序内存20~100M是比较安全的范围
         在取相册图片的过程中，照片一般都是高清大图，内存占用十分大，所以需要做处理
         
         */
        print("----didFinishPick-----",info,"-----endChoose-----")
        let i = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        如果是JPEGRepresentation 来压缩是不保真的
//        不推荐用jpg图片，实现JPG解压缩非常消耗性能
//        let data1 = UIImageJPEGRepresentation(i, 0.1)
//        do {
//            try data1?.write(to: URL.init(fileURLWithPath: "/Users/zhaolingfei/Desktop/1.jpg"))
//        } catch  {
//            print("eeeeeerrrrrrrroooooooorrrrrr")
//        }
        
        let newimage = i.imageWithScale(ToWidth: 200)
        
        pictureImages.append(newimage)
        collectionView.reloadData()
        picker.dismiss(animated: true) {
            
        }
    }
    func photoDidRemoveSelector(cell: photoSelectCollectionCell) {
        let indexpath = collectionView.indexPath(for: cell)
        pictureImages.remove(at: indexpath!.item)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoSelectorCellIdentifier, for: indexPath) as! photoSelectCollectionCell
        cell.backgroundColor = UIColor.yellow
        cell.delegate = self
        cell.image = (pictureImages.count > indexPath.item) ? pictureImages[indexPath.item] : nil
        
        return cell
    }
}
class photoFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: (UIScreen.main.bounds.size.width-50)/4, height: (UIScreen.main.bounds.size.width-50)/4)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
