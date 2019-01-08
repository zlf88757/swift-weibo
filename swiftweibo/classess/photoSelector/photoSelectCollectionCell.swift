//
//  photoSelectCollectionCell.swift
//  图片选择器
//
//  Created by zhaolingfei on 2018/9/20.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

@objc protocol photoSelectorCellDelegate:NSObjectProtocol {
    @objc optional func photoDidSelector(cell:photoSelectCollectionCell)
    @objc optional func photoDidRemoveSelector(cell:photoSelectCollectionCell)
}

class photoSelectCollectionCell: UICollectionViewCell {
    
    var delegate:photoSelectorCellDelegate?
    
    var image:UIImage?{
        didSet{
            if image != nil{
                removeButton.isHidden = false
                addbutton.setBackgroundImage(image, for: UIControlState.normal)
                addbutton.isUserInteractionEnabled = false
            }else{
                removeButton.isHidden = true
                addbutton.setBackgroundImage(UIImage(named: "compose_pic_add"), for: UIControlState.normal)
                addbutton.isUserInteractionEnabled = true
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    func setUpUI()
    {
        contentView.addSubview(addbutton)
        contentView.addSubview(removeButton)
         addbutton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[addbutton]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["addbutton":addbutton])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[addbutton]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["addbutton":addbutton])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:[removeButton]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["removeButton":removeButton])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[removeButton]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["removeButton":removeButton])
        
        contentView.addConstraints(cons)
    }
    @objc func addClick(btn:UIButton){
        delegate?.photoDidSelector!(cell: self)
    }
    @objc func removeClick(btn:UIButton){
        delegate?.photoDidRemoveSelector!(cell: self)
    }
    
    lazy var removeButton : UIButton = {
       let b = UIButton(type: UIButtonType.custom)
        b.setBackgroundImage(UIImage(named: "compose_photo_close"), for: UIControlState.normal)
        b.addTarget(self, action: #selector(removeClick(btn:)), for: UIControlEvents.touchUpInside)
        return b
    }()
    lazy var addbutton:UIButton = {
    let b = UIButton(type: UIButtonType.custom)
        b.setBackgroundImage(UIImage(named: "compose_pic_add"), for: UIControlState.normal)
        b.addTarget(self, action: #selector(addClick(btn:)), for: UIControlEvents.touchUpInside)
    return b
}()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
