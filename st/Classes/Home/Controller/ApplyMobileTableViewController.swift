//
//  ApplyMobileTableViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class ApplyMobileTableViewController: UITableViewController {

    // cell 标识
    var reuseId: String! = "apply"
    
    // 当前页
    var curPage: NSInteger!
    
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "请求列表"
        // 初始化
        setup()
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
    }
    
    func setup() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.viewBackgroundColor
        tableView.register(ApplyMobileTableViewCell().classForCoder, forCellReuseIdentifier: reuseId)
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
        params["method"] = Api.applyMobileList
        params["page"] = curPage
        params["size"] = Constant.size
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let dict = response["data"].arrayObject as! [NSDictionary]
                self.arr.removeAllObjects()
                
                if dict.count != 0 {
                    for item in dict {
                        let applyMobile = ApplyMobile(dict: item as! [String : AnyObject])
                        self.arr.add(applyMobile)
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
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func loadMore() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.applyMobileList
        params["page"] = curPage
        params["size"] = Constant.size
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let dict = response["data"].arrayObject as! [NSDictionary]
                
                if dict.count != 0 {
                    for item in dict {
                        let applyMobile = ApplyMobile(dict: item as! [String : AnyObject])
                        self.arr.add(applyMobile)
                    }
                    
                    self.curPage = self.curPage + 1
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.tableView.mj_footer.endRefreshing()
            
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! ApplyMobileTableViewCell
        cell.backgroundColor = UIColor.clear
        let apply = arr[indexPath.row]
        cell.apply = apply as! ApplyMobile
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
