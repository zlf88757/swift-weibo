//
//  emoticonViewController.swift
//  表情键盘
//
//  Created by zhaolingfei on 2018/9/13.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

let emoticonCellIdentifier = "emoticonCellIdentifier"

class emoticonViewController: UIViewController {
    
    var emoticonDidSelectCallback:(_ emotion:emotionIcons )->()
    
    init(callBack:@escaping (_ emotion:emotionIcons )->()) {
        self.emoticonDidSelectCallback = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        setUpUI()
//        let sss = emotionIconPackage.loadPackages()
//        print(sss)
    }
    func setUpUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
//        布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let dic = ["collectionView":collectionView,"toolBar":toolBar]
        var constraint = [NSLayoutConstraint]()
        constraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        constraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        constraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolBar(44)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        view.addConstraints(constraint)
        
    }
    @objc func barButtonItemAction(barbuttonitem:UIBarButtonItem) {
        print(barbuttonitem.tag)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: barbuttonitem.tag), at: UICollectionViewScrollPosition.left, animated: true)
    }

    private lazy var collectionView:UICollectionView = {
       let ccc = UICollectionView(frame: CGRect.zero, collectionViewLayout: emotionFlowLayout())
        ccc.register(emotionIconsCell.self, forCellWithReuseIdentifier: emoticonCellIdentifier)
        ccc.dataSource = self
        ccc.delegate = self
        return ccc
    }()
    private lazy var toolBar:UIToolbar = {
       let bar = UIToolbar()
        var items = [UIBarButtonItem]()
        var itemIndex = 0
        for title in ["最近","默认","emoji","浪小花"]{
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(barButtonItemAction(barbuttonitem:)))
            item.tag = itemIndex
            itemIndex = itemIndex + 1
            items.append(item)
            let itemmm = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            items.append(itemmm)
            
        }
        items.removeLast()
        bar.backgroundColor = UIColor.purple
        bar.items = items
        return bar
    }()
    lazy var packages:[emotionIconPackage] = emotionIconPackage.packageList

}
extension emoticonViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count 
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCellIdentifier, for: indexPath) as! emotionIconsCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        let e = packages[indexPath.section]
        cell.emotionIconData = e.emotionIconArray?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let e = packages[section]
        return e.emotionIconArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.item)
        let emo = packages[indexPath.section].emotionIconArray![indexPath.item]
        emo.times = emo.times + 1
        packages[0].appendRecentEmotion(emo: emo)
        collectionView.reloadData()
        emoticonDidSelectCallback(emo)
    }
}

class emotionFlowLayout : UICollectionViewFlowLayout
{
    override func prepare() {
        super.prepare()
//        设置cell相关属性
        let width = (collectionView?.bounds.width)! / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
//        设置collectionview
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let y = (collectionView!.bounds.height - 3 * width) * 0.49
        collectionView?.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
    }
}
