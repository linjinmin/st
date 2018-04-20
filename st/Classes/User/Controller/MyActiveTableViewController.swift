//
//  MyActiveTableViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/29.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import SwiftyJSON

class MyActiveTableViewController: UITableViewController {

    // 获取活动状态
    var status: NSInteger!
    // cell 标识
    var reuseId: String! = "myActive"
    // 当前页
    var curPage: NSInteger!
    // 活动数组
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    func setup() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.viewBackgroundColor
        tableView.register(MyActiveTableViewCell().classForCoder, forCellReuseIdentifier: reuseId)
    }
    
    
    func setupRefresh() {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        header?.stateLabel.textColor = UIColor.gray
        header?.lastUpdatedTimeLabel.textColor = UIColor.gray
        tableView.mj_header = header
        let footer = MJRefreshBackStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer?.stateLabel.textColor = UIColor.gray
        tableView.mj_footer = footer
    }
    
    @objc func loadNew() {
        
        curPage = 1
        
        let params = NSMutableDictionary()
        params["status"] = status
        params["page"] = curPage
        params["size"] = Constant.size
        params["method"] = Api.myActive
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            self.arr.removeAllObjects()
            
            if response["code"].intValue == 200 {
                
                if response["data"].arrayObject != nil {
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    
                    for item in dict {
                        let myActive = MyActive(dict: item as! [String : AnyObject])
                        self.arr.add(myActive)
                    }
                    
                    self.curPage = self.curPage + 1
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                    
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.tableView.mj_header.endRefreshing()
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func loadMore() {
        
        let params = NSMutableDictionary()
        params["status"] = status
        params["page"] = curPage
        params["size"] = Constant.size
        params["method"] = Api.myActive
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                if response["data"].arrayObject != nil {
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    
                    for item in dict {
                        let myActive = MyActive(dict: item as! [String : AnyObject])
                        self.arr.add(myActive)
                    }
                    
                    self.curPage = self.curPage + 1
                    self.tableView.reloadData()
                    
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myActive = arr[indexPath.row] as! MyActive
        let vc = ActiveDetailViewController()
        vc.activeId = myActive.id
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! MyActiveTableViewCell
        let cellColorIndex = indexPath.row % 4
        var leftColor = cellColors[cellColorIndex]
        var rightColor = cellColorsAlpha[cellColorIndex]
        
        if status == 3 {
            leftColor = UIColor.lightGray
            rightColor = UIColor.lightGray
        }
        
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame.size.height = 200
        gradientLayer.frame.size.width = Constant.screenW - 60
        gradientLayer.locations = gradientLocations
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        cell.status = status
        let myActive = arr[indexPath.row]
        cell.myActive = myActive as! MyActive
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

}
