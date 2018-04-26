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

class ActiveSquareViewController: UIViewController, SingleKeyBoardDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    
    
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
    // 当前页
    var curPage: NSInteger!
    // 没有活动label
    var noActiveLabel: UILabel!
    
    // 关键词
    lazy var keyword = { () -> String in
        let str = ""
        return str
    }()
    
    
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()

    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "活动广场"
        view.backgroundColor = Constant.viewBackgroundColor
        setup()
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
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
        bgview.backgroundColor = Constant.viewBackgroundColor
//        bgview.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
        field.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        field.layer.cornerRadius = 5
        field.delegate = self
        bgview.addSubview(field)
        self.field = field
        field.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgview)
            make.left.equalTo(bgview).offset(15)
            make.right.equalTo(bgview).offset(-15)
            make.height.equalTo(40)
        }
        
//        // 搜索按钮
//        let btn = UIButton()
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        btn.backgroundColor = Constant.viewColor
//        btn.layer.cornerRadius = 5
//        btn.setTitle("搜索", for: .normal)
//        btn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
//        bgview.addSubview(btn)
//        btn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(bgview)
//            make.left.equalTo(field.snp.right).offset(5)
//            make.height.equalTo(field)
//            make.right.equalTo(bgview).offset(-5)
//        }
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.bottom.equalTo(view)
            make.top.equalTo(bgview.snp.bottom).offset(10)
        }
        
//        // 主要活动view
//        let mainActiveView = UIView()
//        mainActiveView.backgroundColor = UIColor.clear
//        mainActiveView.frame = CGRect.init(x: 0, y: 0, width: Constant.screenW, height: 260)
//        view.addSubview(mainActiveView)
//
//        // 滚动试图
//        let photoScrollView = UIScrollView()
//        photoScrollView.delegate = self
//        photoScrollView.showsHorizontalScrollIndicator = false
//        photoScrollView.backgroundColor = UIColor.clear
//        photoScrollView.isPagingEnabled = true
//        mainActiveView.addSubview(photoScrollView)
//        self.photoScrollView = photoScrollView
//        photoScrollView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(mainActiveView)
//            make.top.equalTo(mainActiveView)
//            make.height.equalTo(150)
//        }
//
//        let activeBottomView = UIView()
//        activeBottomView.backgroundColor = UIColor.clear
//        mainActiveView.addSubview(activeBottomView)
//        activeBottomView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalTo(mainActiveView)
//            make.top.equalTo(photoScrollView.snp.bottom).offset(5)
//        }
//
//        // 横线1
//        let hen1 = UIView()
//        hen1.backgroundColor = Constant.littleGray
//        activeBottomView.addSubview(hen1)
//        hen1.snp.makeConstraints { (make) in
//            make.top.equalTo(activeBottomView)
//            make.left.right.equalTo(activeBottomView)
//            make.height.equalTo(1)
//        }
//
//        // 横线2
//        let hen2 = UIView()
//        hen2.backgroundColor = Constant.littleGray
//        activeBottomView.addSubview(hen2)
//        hen2.snp.makeConstraints { (make) in
//            make.bottom.equalTo(activeBottomView).offset(-10)
//            make.left.right.equalTo(activeBottomView)
//            make.height.equalTo(1)
//        }
//
//        // 活动大标题
//        let nameLabel = setupLabel(font: 20)
//        activeBottomView.addSubview(nameLabel)
//        self.nameLabel = nameLabel
//        nameLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(activeBottomView)
//            make.left.equalTo(activeBottomView).offset(20)
//        }
//
//        // 地点label
//        let addressLabel = setupLabel(font: 13)
//        activeBottomView.addSubview(addressLabel)
//        self.addressLabel = addressLabel
//        addressLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(activeBottomView).offset(2)
//            make.left.equalTo(activeBottomView.snp.centerX).offset(5)
//        }
//
//        // 活动时间label
//        let activeTimeLabel = setupLabel(font: 13)
//        activeBottomView.addSubview(activeTimeLabel)
//        self.activeTimeLabel = activeTimeLabel
//        activeTimeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(addressLabel)
//            make.centerY.equalTo(activeBottomView).offset(-2)
//        }
//
//        // 活动报名时间label
//        let signTimeLabel = setupLabel(font: 13)
//        activeBottomView.addSubview(signTimeLabel)
//        self.signTimeLabel = signTimeLabel
//        signTimeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(addressLabel)
//            make.bottom.equalTo(activeTimeLabel.snp.top).offset(-2)
//        }
//
//        // 发起社团label
//        let tissueNameLabel = setupLabel(font: 13)
//        activeBottomView.addSubview(tissueNameLabel)
//        self.tissueNameLabel = tissueNameLabel
//        tissueNameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(addressLabel)
//            make.top.equalTo(addressLabel.snp.bottom).offset(2)
//        }
        
        // 隐藏热门活动
//        tableView.tableHeaderView = mainActiveView
        
        // 没有活动label
        let noActiveLabel = setupLabel(font: 20)
        noActiveLabel.textColor = UIColor.lightGray
        noActiveLabel.text = "没有相关活动"
        noActiveLabel.isHidden = true
        view.addSubview(noActiveLabel)
        self.noActiveLabel = noActiveLabel
        noActiveLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(40)
        }
        
    }
    
    @objc func loadNew() {
        
        curPage = 1
        
        let params = NSMutableDictionary()
        params["page"] = curPage
        params["size"] = Constant.size
        params["keyword"] = keyword
        params["method"] = Api.activeSquare
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                self.arr.removeAllObjects()
                
                if response["data"].arrayObject != nil {
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    for item in dict {
                        let activeSquare = ActiveSquare(dict: item as! [String : AnyObject])
                        self.arr.add(activeSquare)
                    }
                    self.curPage = self.curPage + 1
                    self.noActiveLabel.isHidden = true
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.noActiveLabel.isHidden = false
                }
                
                self.tableView.mj_header.endRefreshing()
                
            } else {
                self.tableView.mj_header.endRefreshing()
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (task, error) in
            self.tableView.mj_header.endRefreshing()
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func loadMore() {
        
        let params = NSMutableDictionary()
        params["page"] = curPage
        params["size"] = Constant.size
        params["keyword"] = keyword
        params["method"] = Api.activeSquare
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                
                if response["data"].arrayObject != nil {
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    for item in dict {
                        let activeSquare = ActiveSquare(dict: item as! [String : AnyObject])
                        self.arr.add(activeSquare)
                    }
                    self.curPage = self.curPage + 1
                    
                    self.tableView.mj_footer.endRefreshing()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.tableView.reloadData()
            
            SVProgressHUD.dismiss()
            
        }) { (task, error) in
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        keyword = textField.text!
        
        tableView.mj_header.beginRefreshing()
        
        return true
    }
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActiveSquareTableViewCell()
        let cellColorIndex = indexPath.row % 4
        let leftColor = cellColors[cellColorIndex]
        let rightColor = cellColorsAlpha[cellColorIndex]
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame.size.width = Constant.screenW - 20
        gradientLayer.frame.size.height = 165
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        let active = arr[indexPath.row]
        cell.active = active as! ActiveSquare
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let active = arr[indexPath.row] as! ActiveSquare
        let vc = ActiveDetailViewController()
        vc.activeId = active.id
        vc.view.frame = CGRect.init(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }
    

}
