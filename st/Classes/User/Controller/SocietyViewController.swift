//
//  SocietyViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

import MJRefresh
import SVProgressHUD
import SwiftyJSON

class SocietyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    weak var tableView: UITableView!
    // 当前页
    var curPage: NSInteger!
    
    lazy var arr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    lazy var searchView = {() -> SearchViewController in
        let leftVc = SearchViewController()
        leftVc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        return leftVc
    }()
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.viewBackgroundColor
        navigationItem.title = "我的社团"
        setup()
        setupRightBarBtn()
        setupRefresh()
        
        tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRightBarBtn() {
        let button = UIButton()
        button.frame = CGRect(x:0 ,y:0, width:20, height:32)
        button.setImage(UIImage(named: "search"), for: .normal)
        button.setTitleColor(UIColor(red:230/255.0, green:230/255.0, blue:230/255.0, alpha:1), for: .normal)
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }

    func setup() {
        
        
        // 我的社团label
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = UIColor.black
//        label.text = "我的社团:"
//        view.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.left.equalTo(view).offset(30)
//            make.top.equalTo(view).offset(20)
//        }
        
        // tableView
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
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        
    }
    
    func setupRefresh() {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        header?.stateLabel.textColor = UIColor.gray
        header?.lastUpdatedTimeLabel.textColor = UIColor.gray
        tableView.mj_header = header
//        let footer = MJRefreshBackStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//        footer?.stateLabel.textColor = UIColor.gray
//        tableView.mj_footer = footer
    }
    
    @objc func loadNew() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.myTissue
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                self.arr.removeAllObjects()
                let dict = response["data"].arrayObject as! [NSDictionary]
                
                if dict.count != 0 {
                    for item in dict {
                        let briefSociety = BriefSociety(dict: item as! [String : AnyObject])
                        self.arr.add(briefSociety)
                    }
                    
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.mj_header.endRefreshing()
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            self.tableView.mj_header.endRefreshing()
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func loadMore() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.myTissue
        params["page"] = curPage
        params["size"] = Constant.page
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SocietyTableViewCell()
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
        let breifSociety = arr[indexPath.row]
        cell.briefSociety = breifSociety as! BriefSociety
        return cell
    }
    
    @objc func search() {
        navigationController?.pushViewController(searchView, animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
