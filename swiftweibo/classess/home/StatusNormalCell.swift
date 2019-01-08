//
//  StatusNormalCell.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/7.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCellHome {

    override func setUpUI() {
        super.setUpUI()
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.width.equalTo(290)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(290)
        }
    }
    
}
