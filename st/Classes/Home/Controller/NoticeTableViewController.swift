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
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
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
                self.arr.removeAllObjects()
                
                if dict.count != 0 {
                    for item in dict {
                        let userMessage = UserMessage(dict: item as! [String : AnyObject])
                        self.arr.add(userMessage)
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
        params["method"] = Api.noticeList
        params["page"] = curPage
        params["size"] = Constant.size
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let dict = response["data"].arrayObject as! [NSDictionary]
                
                if dict.count != 0 {
                    for item in dict {
                        let userMessage = UserMessage(dict: item as! [String : AnyObject])
                        self.arr.add(userMessage)
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
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! NoticeTableViewCell
        cell.backgroundColor = UIColor.clear
        let userMessage = arr[indexPath.row]
        cell.message = userMessage as! UserMessage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userMessage = arr[indexPath.row] as! UserMessage
        
        // 请求设置数据已读
        if userMessage.status == "0" {
            
            userMessage.status = "1"
            arr[indexPath.row] = userMessage
            self.tableView.reloadData()
            
            // 设置已读
            let params = NSMutableDictionary()
            params["method"] = Api.updateMessage
            params["id"] = userMessage.id
            
            Networking.share().post(Api.host, parameters: params, progress: nil, success: nil, failure: nil)
        }
        
        if userMessage.type == "1" {
            // 进入好友请求
            let vc = ApplyMobileTableViewController()
            vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = NoticeDetailViewController()
            vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
            vc.message = userMessage
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
