//
//  photoBrowserCustomCollectionViewCell.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/11.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

protocol photoBrowserCellDelegate : NSObjectProtocol {
    func photoDidClose(cell:photoBrowserCustomCollectionViewCell)
}

class photoBrowserCustomCollectionViewCell: UICollectionViewCell {
    
    weak var cellDelegate : photoBrowserCellDelegate?
    
    var imageUrl : URL?{
        didSet{
            reSetScrollViewAndImageView()
            activityView.startAnimating()
            itemImageView.sd_setImage(with:  imageUrl) { (image, _, _, url) in
                self.activityView.stopAnimating()
               self.handleLongPicAndPosition()
            }
        }
    }
    func reSetScrollViewAndImageView()  {
        scrollView.contentSize = CGSize.zero
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        
        itemImageView.transform = CGAffineTransform.identity
    }
    func handleLongPicAndPosition()  {
        let size = handleDisplaySize(image: itemImageView.image!)
        if size.height < screen_height{
            let y = (screen_height - size.height)*0.5
            self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
            self.itemImageView.frame = CGRect(origin: CGPoint.zero, size:size)
        }else{
            itemImageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
        }
    }
    func handleDisplaySize(image:UIImage) -> CGSize {
//        拿到图片的宽高比
        let scale = image.size.height/image.size.width
//        根据宽度计算高度
        let height = screen_width * scale
        
        
        return CGSize(width: screen_width, height: height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    
    func setUpUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(itemImageView)
        contentView.addSubview(activityView)
        
        scrollView.frame = UIScreen.main.bounds
        activityView.center = contentView.center
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.3
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePhotoBrowser) )
        itemImageView.addGestureRecognizer(tap)
        itemImageView.isUserInteractionEnabled = true
        
    }
    @objc func closePhotoBrowser() {
        cellDelegate?.photoDidClose(cell: self)
    }
    
    lazy var scrollView : UIScrollView = {
       let ss = UIScrollView()
        
        return ss
    }()
    lazy var itemImageView : UIImageView = {
       let ii = UIImageView()
        ii.backgroundColor = UIColor.yellow
        return ii
    }()
    lazy var activityView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension photoBrowserCustomCollectionViewCell : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return itemImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("didzoom")
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("didendzooming")
//        注意：缩放的本质是修改transform，修改transform不会影响到bounds，只会影响frame
        print(view?.frame)
        print(view?.bounds)
        var offsetx = (screen_width - view!.frame.width)*0.5
        var offsetY = (screen_height - view!.frame.height)*0.5
        print("打印缩放的offsetx，offsety",offsetx,offsetY)
        offsetx = offsetx < 0 ? 0 : offsetx
        offsetY = offsetY < 0 ? 0 : offsetY
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetx, offsetY, offsetY)
        
    }
    
}
