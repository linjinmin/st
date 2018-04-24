//
//  ActiveSquareViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/19.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import SwiftyJSON

class ActiveSquareViewController: UIViewController, SingleKeyBoardDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    // 搜索框
    weak var field: UITextField!
    // 活动tableView
    weak var tableView: UITableView!
    // 照片scrollview
    weak var photoScrollView: UIScrollView!
    // 活动大标题
    weak var nameLabel: UILabel!
    // 活动报名时间
    weak var signTimeLabel: UILabel!
    // 活动开始时间
    weak var activeTimeLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团label
    weak var tissueNameLabel: UILabel!
    

    
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "活动广场"
        view.backgroundColor = Constant.viewBackgroundColor
        setup()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setup() {
        
        // 背景框view
        let bgview = UIView()
        bgview.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.addSubview(bgview)
        bgview.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        
        // field
        let field = SearchField()
        field.inputAccessoryView = singleKeyBoard
        field.placeholder = "请输入社团名称"
        field.font = UIFont.systemFont(ofSize: 16)
        let leftImageView = UIImageView(image:UIImage(named:"search"))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        field.leftView = leftImageView
        field.leftViewMode = .always
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 5
        bgview.addSubview(field)
        self.field = field
        field.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgview)
            make.left.equalTo(bgview).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(Constant.screenW * 0.7)
        }
        
        // 搜索按钮
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = Constant.viewColor
        btn.layer.cornerRadius = 5
        btn.setTitle("搜索", for: .normal)
        btn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        bgview.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgview)
            make.left.equalTo(field.snp.right).offset(5)
            make.height.equalTo(field)
            make.right.equalTo(bgview).offset(-5)
        }
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(bgview.snp.bottom).offset(10)
        }
        
        // 主要活动view
        let mainActiveView = UIView()
        mainActiveView.backgroundColor = UIColor.clear
        mainActiveView.frame = CGRect.init(x: 0, y: 0, width: Constant.screenW, height: 260)
        view.addSubview(mainActiveView)
        
        // 滚动试图
        let photoScrollView = UIScrollView()
        photoScrollView.delegate = self
        photoScrollView.showsHorizontalScrollIndicator = false
        photoScrollView.backgroundColor = UIColor.clear
        photoScrollView.isPagingEnabled = true
        mainActiveView.addSubview(photoScrollView)
        self.photoScrollView = photoScrollView
        photoScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(mainActiveView)
            make.top.equalTo(mainActiveView)
            make.height.equalTo(150)
        }
        
        let activeBottomView = UIView()
        activeBottomView.backgroundColor = UIColor.clear
        mainActiveView.addSubview(activeBottomView)
        activeBottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(mainActiveView)
            make.top.equalTo(photoScrollView.snp.bottom).offset(5)
        }
        
        // 横线1
        let hen1 = UIView()
        hen1.backgroundColor = Constant.littleGray
        activeBottomView.addSubview(hen1)
        hen1.snp.makeConstraints { (make) in
            make.top.equalTo(activeBottomView)
            make.left.right.equalTo(activeBottomView)
            make.height.equalTo(1)
        }
        
        // 横线2
        let hen2 = UIView()
        hen2.backgroundColor = Constant.littleGray
        activeBottomView.addSubview(hen2)
        hen2.snp.makeConstraints { (make) in
            make.bottom.equalTo(activeBottomView)
            make.left.right.equalTo(activeBottomView)
            make.height.equalTo(1)
        }
        
        // 活动大标题
        let nameLabel = setupLabel(font: 20)
        activeBottomView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(activeBottomView)
            make.left.equalTo(activeBottomView).offset(20)
        }
        
        // 地点label
        let addressLabel = setupLabel(font: 13)
        activeBottomView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(activeBottomView).offset(2)
            make.left.equalTo(activeBottomView.snp.centerX).offset(5)
        }
        
        // 活动时间label
        let activeTimeLabel = setupLabel(font: 13)
        activeBottomView.addSubview(activeTimeLabel)
        self.activeTimeLabel = activeTimeLabel
        activeTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.centerY.equalTo(activeBottomView).offset(-2)
        }
        
        // 活动报名时间label
        let signTimeLabel = setupLabel(font: 13)
        activeBottomView.addSubview(signTimeLabel)
        self.signTimeLabel = signTimeLabel
        signTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.bottom.equalTo(activeTimeLabel.snp.top).offset(-2)
        }
        
        // 发起社团label
        let tissueNameLabel = setupLabel(font: 13)
        activeBottomView.addSubview(tissueNameLabel)
        self.tissueNameLabel = tissueNameLabel
        tissueNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(2)
        }
        
        tableView.tableHeaderView = mainActiveView
        
    }
    
    @objc func searchBtnClick() {
        
    }
    
    @objc func loadNew() {
        
    }
    
    @objc func loadMore() {
        
    }
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }
    

}
