//
//  titleButton.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/7/25.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class titleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.blue, for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        self.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Swift中可以这样写
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }

}
