//
//  UserShowViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class UserShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 用户头像
    weak var headImageView: UIImageView!
    // 用户昵称
    weak var nameLabel: UILabel!
    // 性别
    weak var sexLabel:UILabel!
    // 省市学校
    weak var addressLabel: UILabel!
    // 手机号label
    weak var mobileLabel:UILabel!
    // 手机号btn
    weak var mobileBtn: UIButton!
    // 社团tableView
    weak var tissueTableView: UITableView!
    // 活动tableView
    weak var activeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "优社团"
        view.backgroundColor = Constant.viewBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() {
        
        // 大的scrollview
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
        // 用户头像
        let headImageView = UIImageView()
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = 40
        scrollView.addSubview(headImageView)
        self.headImageView = headImageView
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(20)
            make.top.equalTo(scrollView).offset(20)
            make.height.width.equalTo(80)
        }
        
        // 用户姓名
        let nameLabel = setupLabel(font: 20, color: UIColor.black)
        scrollView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(20)
        }
        
        // 性别
        let sexLabel = setupLabel(font: 16, color: UIColor.lightGray)
        scrollView.addSubview(sexLabel)
        self.sexLabel = sexLabel
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }
        
        // 地址
        let addressLabel = setupLabel(font: 16, color: UIColor.lightGray)
        scrollView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(sexLabel.snp.bottom).offset(10)
        }
        
        // 手机号label
        let mobileLabel = setupLabel(font: 16, color: UIColor.lightGray)
        scrollView.addSubview(mobileLabel)
        mobileLabel.isHidden = true
        self.mobileLabel = mobileLabel
        mobileLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
        }
        
        // 手机号btn
        let mobileBtn = UIButton()
        mobileBtn.setTitle("申请查看手机号", for: .normal)
        mobileBtn.setTitleColor(Constant.viewColor, for: .normal)
        mobileBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        mobileBtn.addTarget(self, action: #selector(mobileBtnClick), for: .touchUpInside)
        scrollView.addSubview(mobileBtn)
        mobileBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        // 参与的社团
        let tissueLabel = setupLabel(font: 18, color: UIColor.black)
        tissueLabel.text = "社团"
        scrollView.addSubview(tissueLabel)
        tissueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(20)
        }
        
        // 社团tableView
        let tissueTableView = UITableView()
        tissueTableView.delegate = self
        tissueTableView.dataSource = self
        tissueTableView.backgroundColor = UIColor.clear
        tissueTableView.separatorStyle = .none
        tissueTableView.showsHorizontalScrollIndicator = false
        tissueTableView.showsVerticalScrollIndicator = false
        scrollView.addSubview(tissueTableView)
        self.tissueTableView = tissueTableView
        tissueTableView.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(tissueLabel.snp.bottom).offset(10)
            make.width.equalTo(Constant.screenW - 40)
            make.height.equalTo(150)
        }
        
        // 活动Label
        let activeLabel = setupLabel(font: 18, color: UIColor.black)
        activeLabel.text = "最近参与"
        scrollView.addSubview(activeLabel)
        activeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(tissueTableView.snp.bottom).offset(10)
        }
        
        // 活动tableView
        let activeTableView = UITableView()
        activeTableView.delegate = self
        activeTableView.dataSource = self
        activeTableView.backgroundColor = UIColor.clear
        activeTableView.separatorStyle = .none
        activeTableView.showsHorizontalScrollIndicator = false
        activeTableView.showsVerticalScrollIndicator = false
        scrollView.addSubview(activeTableView)
        self.activeTableView = activeTableView
        activeLabel.snp.makeConstraints { (make) in
            
        }
        
    }
    
    @objc func mobileBtnClick() {
        
    }
    
    func setupLabel(font: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = color
        return label
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    

}
