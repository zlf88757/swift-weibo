//
//  emotionIconsCell.swift
//  表情键盘
//
//  Created by zhaolingfei on 2018/9/14.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class emotionIconsCell: UICollectionViewCell {
    
    var emotionIconData:emotionIcons?{
        didSet{
            if emotionIconData?.chs != nil{
                iconButton.setImage(UIImage(contentsOfFile: (emotionIconData?.imagePath)!), for: UIControlState.normal)
            }else{
                iconButton.setImage(nil, for: UIControlState.normal)
            }
//            设置emotion的表情，十六进制的表情， emoji表情的大小就是字体的大小
            iconButton.setTitle(emotionIconData?.emotionString ?? "", for: UIControlState.normal)
            if emotionIconData!.isRemoveButton {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }else{
                iconButton.setImage(nil, for: UIControlState.highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    
    func setUpUI()
    {
        contentView.addSubview(iconButton)
        iconButton.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        
    }
    
    
    lazy var iconButton : UIButton = {
       let bbb = UIButton(type: UIButtonType.custom)
        bbb.backgroundColor = UIColor.yellow
        bbb.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        bbb.isUserInteractionEnabled = false
        return bbb
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
