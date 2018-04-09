//
//  SearchViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import MJRefresh

class SearchViewController: UIViewController, SingleKeyBoardDelegate, UITableViewDelegate, UITableViewDataSource {

    
    weak var field: UITextField!
    weak var tableView: UITableView!
    // 当前页
    var curPage: NSInteger!
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "社团搜索"
        view.backgroundColor = Constant.viewBackgroundColor
        setup()
        setupRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        // tableView
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(bgview.snp.bottom).offset(5)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view)
        }
        
    }
    
    
    func setupRefresh() {
//        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
//        header?.stateLabel.textColor = UIColor.gray
//        header?.lastUpdatedTimeLabel.textColor = UIColor.gray
//        tableView.mj_header = header
        let footer = MJRefreshBackStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer?.stateLabel.textColor = UIColor.gray
        tableView.mj_footer = footer
    }
    
    @objc func loadMore() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.tissueByName
        params["page"] = curPage
        params["size"] = Constant.page
        params["name"] = field.text
        
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
    
    @objc func searchBtnClick() {
        
        view.endEditing(true)
        
        if field.text == "" {
            return
        }
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
        let params = NSMutableDictionary()
        params["method"] = Api.tissueByName
        params["name"] = field.text

        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                self.arr.removeAllObjects()
                let dict = response["data"].arrayObject as! [NSDictionary]
                
                if dict.count != 0 {
                    for item in dict {
                        let briefSociety = SearchSociety(dict: item as! [String : AnyObject])
                        self.arr.add(briefSociety)
                    }
                    self.curPage = 2
                    self.tableView.reloadData()
                }
                
                SVProgressHUD.dismiss()
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchSocietyTableViewCell()
        let cellColorIndex = indexPath.row % 4
        let leftColor = cellColors[cellColorIndex]
        let rightColor = cellColorsAlpha[cellColorIndex]
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = cell.contentView.frame
        gradientLayer.frame.size.height = 180
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        let briefSociety = arr[indexPath.row]
        cell.briefSociety = briefSociety as! SearchSociety
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }
    
}
