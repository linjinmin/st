//
//  NoticeTableViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/27.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NoticeTableViewController: UITableViewController {
    
    // cell 标识
    var reuseId: String! = "notice"
    
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
