//
//  myTableViewController.swift
//  swiftweibo
//
//  Created by zhao on 2018/8/24.
//  Copyright © 2018年 zhaolingfei. All rights reserved.
//

import UIKit

class myTableViewController: UITableViewController {

    var isFirstShowAnimate : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstShowAnimate = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            let vv: UIView = UIView()
            vv.frame = CGRect.init(x: 15, y: 5, width: UIScreen.main.bounds.size.width - 30, height: 40)
            vv.backgroundColor = UIColor.orange
            vv.layer.cornerRadius = 5
            cell?.contentView.addSubview(vv)
        }
        cell?.backgroundColor = UIColor.blue
        
        cell?.layer.removeAllAnimations()
        return cell!
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                if isFirstShowAnimate == true {
                    let num = (UIScreen.main.bounds.size.height - 20)/50
        
                    if indexPath.row < Int(num) + 1{
                        cell.layer.transform = CATransform3DMakeTranslation(-UIScreen.main.bounds.size.width, 1, 0)
                        UIView.animate(withDuration: 1 , delay: Double(indexPath.row) * 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: {
                           cell.layer.transform = CATransform3DIdentity
                        }, completion: nil)
                    }else{
                        isFirstShowAnimate = false
                        cellAnimateMoveS(cell: cell)
                    }
                }else{
        cellAnimateMoveS(cell: cell)
                }
    }
   
    func cellAnimateMoveS(cell:UITableViewCell) {
        cell.layer.transform = CATransform3DMakeTranslation(-UIScreen.main.bounds.size.width, 1, 0)
        
        UIView.animate(withDuration: 1 ) {
            cell.layer.transform = CATransform3DIdentity
            
        }
    }

}
