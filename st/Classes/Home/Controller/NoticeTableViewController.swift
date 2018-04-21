//
//  NoticeTableViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/27.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import SwiftyJSON

class NoticeTableViewController: UITableViewController {
    
    // cell 标识
    var reuseId: String! = "notice"
    
    
    // 当前页
    var curPage: NSInteger!
    
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "平台公告"
        // 初始化
        setup()
    }
    
    func setup() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.viewBackgroundColor
        tableView.register(NoticeTableViewCell().classForCoder, forCellReuseIdentifier: reuseId)
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
        params["method"] = Api.noticeList
        params["page"] = curPage
        params["size"] = Constant.size
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let dict = response["data"].arrayObject as! [NSDictionary]
                
                if dict.count != 0 {
                    for item in dict {
                        let briefSociety = BriefSociety(dict: item as! [String : AnyObject])
                        self.arr.add(briefSociety)
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
    
    @objc func loadMore() {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        return cell!
    }

    

}
