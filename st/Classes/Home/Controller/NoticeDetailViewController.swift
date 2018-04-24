//
//  NoticeDetailViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/21.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {

    // 标题label
    weak var titleLabel: UILabel!
    // 时间label
    weak var timeLabel: UILabel!
    // 内容label
    weak var contentLabel: UILabel!
    
    var message: UserMessage! {
        didSet {
            
            titleLabel.text = "\(message.title ?? "")"
            timeLabel.text = "\(message.create_time ?? "")"
            contentLabel.text = "    \(message.msg ?? "")"
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "消息详情"
        view.backgroundColor = Constant.viewBackgroundColor
        
        setup()
    }
    
    func setup() {
        
        // 标题
        let titleLabel = setupLabel(font: 20, color: Constant.viewColor)
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(30)
        }
        
        // 时间label
        let timeLabel = setupLabel(font: 14, color: UIColor.lightGray)
        view.addSubview(timeLabel)
        self.timeLabel = timeLabel
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        // 详情
        let contentLabel = setupLabel(font: 16, color: UIColor.black)
        contentLabel.numberOfLines = 0
        view.addSubview(contentLabel)
        self.contentLabel = contentLabel
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabel(font: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = color
        return label
    }

    

}
