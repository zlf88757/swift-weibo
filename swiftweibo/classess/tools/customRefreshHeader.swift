//
//  customRefreshHeader.swift
//  swiftweibo
//
//  Created by zhaolingfei on 2018/9/10.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit
import MJRefresh

class customRefreshHeader: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        
        setTitle("下拉刷新", for: MJRefreshState.idle)
        setTitle("松手开始刷新", for: MJRefreshState.pulling)
        setTitle("正在加载", for: MJRefreshState.refreshing)
        
    }
    
    

}
