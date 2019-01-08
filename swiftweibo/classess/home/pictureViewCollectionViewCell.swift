//
//  pictureViewCollectionViewCell.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/5.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class pictureViewCollectionViewCell: UICollectionViewCell {
    
    var imageUrl:URL?{
        didSet{
            iconImageView.sd_setImage(with: imageUrl!, completed: nil)
//            判断是否需要显示gif图标
            
            if (imageUrl!.absoluteString as NSString).pathExtension.lowercased() == "gif" {
                print("打印是否为GIF",imageUrl!.absoluteString)
                gifIconIMV.isHidden = false
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI()  {
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(gifIconIMV)
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        gifIconIMV.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
    private lazy var iconImageView:UIImageView = UIImageView()
    lazy var gifIconIMV : UIImageView = {
       let iii = UIImageView(image: UIImage(named: "avatar_vgirl"))
        iii.isHidden = true
        return iii
    }()
    
}
