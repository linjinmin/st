//
//  ActiveMemberListTableViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/25.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import MJRefresh

class ActiveMemberListTableViewController: UITableViewController {

    // 活动id
    var activeId: NSString!
    // cell 标识
    var reuseId: String! = "member"
    // 活动数组
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "签到人员"
        
        setup()
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    func setup() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constant.viewBackgroundColor
        tableView.register(ActiveMemberListTableViewCell().classForCoder, forCellReuseIdentifier: reuseId)
    }
    
    func setupRefresh() {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        header?.stateLabel.textColor = UIColor.gray
        header?.lastUpdatedTimeLabel.textColor = UIColor.gray
        tableView.mj_header = header
    }
    
    @objc func loadNew() {
        
        let params = NSMutableDictionary()
        params["active_id"] = activeId
        params["method"] = Api.activeSignMemberList
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            self.arr.removeAllObjects()
            
            if response["code"].intValue == 200 {
                
                if response["data"].arrayObject != nil {
                    
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    
                    for item in dict {
                        let member = SignMember(dict: item as! [String : AnyObject])
                        self.arr.add(member)
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.tableView.mj_header.endRefreshing()
            
        }) { (task, error) in
            self.tableView.mj_header.endRefreshing()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! ActiveMemberListTableViewCell
        
        if indexPath.row == 0 {
            cell.is_first = "1"
        }
        
        let member = arr[indexPath.row] as! SignMember
        cell.member = member
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        return 70
    }

}
