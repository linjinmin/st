//
//  HomeViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import swiftScan
import SDWebImage
import MJRefresh
import SVProgressHUD
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var scrollView: UIScrollView!
    // 头像
    weak var headImageView: UIImageView!
    // 姓名
    weak var nameLabel: UILabel!
    // 学校
    weak var schoolLabel: UILabel!
    // 活动tableView
    weak var activeTableView: UITableView!
    // 红点view
    weak var redView: UIView!
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
    lazy var leftVc = {() -> LeftViewController in
        let leftVc = LeftViewController()
        leftVc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        return leftVc
    }()
    
    lazy var activeArr = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    lazy var scanVc = {() -> NavigationController in
        let scanVc = ScanViewController()
        scanVc.view.frame = CGRect(x: 0, y: 20, width: Constant.screenW, height: Constant.screenH)
        let navi = NavigationController(rootViewController:scanVc)
        return navi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        view.backgroundColor = Constant.viewBackgroundColor
        
        setupHeadView()
        setupScrollView()
        setupScrollViewDetail()
        setupRefresh()
        refreshToken()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = Api.host + "/" + ((AccountTool.getUser()?.head_pic)! as String )
        headImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_placeholder"))
        nameLabel.text = ((AccountTool.getUser()?.name)! as String )
        schoolLabel.text = ((AccountTool.getUser()?.school_name)! as String)
    }
    
    // 设置主滑动视图
    func setupScrollView() {
     
        let scrollView = UIScrollView(frame: CGRect(x:0, y:65, width:Constant.screenW, height:Constant.screenH - 65))
        scrollView.backgroundColor = Constant.viewBackgroundColor
//        scrollView.contentSize = CGSize(width: Constant.screenW, height: 602)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(65)
        }
    }
    
    // 设置主滑动视图内部视图
    func setupScrollViewDetail() {
        
        // 用户头像
        let headImageView = UIImageView()
        let url = Api.host + "/" + ((AccountTool.getUser()?.head_pic)! as String )
        headImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_placeholder"))
        headImageView.layer.cornerRadius = 37
        headImageView.layer.masksToBounds = true
        scrollView.addSubview(headImageView)
        self.headImageView = headImageView
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(30)
            make.top.equalTo(scrollView).offset(20)
            make.width.height.equalTo(74)
        }
//        headImageView.frame = CGRect(x:30, y:20, width:74, height:74)
        
        // 用户姓名
        let nameLabel = UILabel()
        nameLabel.text = ((AccountTool.getUser()?.name)! as String )
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(25)
            make.top.equalTo(scrollView).offset(32)
        }
//        nameLabel.frame = CGRect(x:130, y:32, width:160, height:25)
        
        // 用户学校
        let schoolLabel = UILabel()
        schoolLabel.text = ((AccountTool.getUser()?.school_name)! as String)
        schoolLabel.font = UIFont.systemFont(ofSize: 16)
        schoolLabel.textColor = UIColor.gray
        scrollView.addSubview(schoolLabel)
        self.schoolLabel = schoolLabel
        schoolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
        }
//        schoolLabel.frame = CGRect(x:130, y:60, width:160, height:20)
        
        // 常用功能label
        let killsLabel = UILabel()
        killsLabel.text = "常用功能"
        killsLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(killsLabel)
        killsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(20)
        }
//        killsLabel.frame = CGRect(x:30, y:120, width:100, height:20)
        
        // 我的社团
//        let teamBtn = BomButton(frame: CGRect(x:30, y:150, width:50, height:70))
        let teamBtn = BomButton()
        teamBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        teamBtn.setTitle("我的社团", for: .normal)
        teamBtn.setTitleColor(UIColor.black, for: .normal)
        teamBtn.setImage(UIImage(named: "team"), for: .normal)
        teamBtn.titleLabel?.textAlignment = .center
        teamBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        teamBtn.addTarget(self, action: #selector(societyBtnClick), for: .touchUpInside)
        scrollView.addSubview(teamBtn)
        teamBtn.snp.makeConstraints { (make) in
            make.left.equalTo(killsLabel)
            make.top.equalTo(killsLabel.snp.bottom).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(70)
        }
        
        // 我的活动
//        let myactiveBtn = BomButton(frame: CGRect(x:110, y:150, width:50, height:70))
        let myactiveBtn = BomButton()
        myactiveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        myactiveBtn.setTitle("我的活动", for: .normal)
        myactiveBtn.setTitleColor(UIColor.black, for: .normal)
        myactiveBtn.setImage(UIImage(named: "myactive"), for: .normal)
        myactiveBtn.titleLabel?.textAlignment = .center
        myactiveBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        myactiveBtn.addTarget(self, action: #selector(myActiveBtnClick), for: .touchUpInside)
        scrollView.addSubview(myactiveBtn)
        myactiveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(teamBtn)
            make.left.equalTo(teamBtn.snp.right).offset(30)
            make.width.height.equalTo(teamBtn)
        }
        
        // 活动广场
//        let activeBtn = BomButton(frame: CGRect(x:190, y:150, width:50, height:70))
        let activeBtn = BomButton()
        activeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        activeBtn.setTitle("活动广场", for: .normal)
        activeBtn.setTitleColor(UIColor.black, for: .normal)
        activeBtn.setImage(UIImage(named: "active"), for: .normal)
        activeBtn.titleLabel?.textAlignment = .center
        activeBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        activeBtn.addTarget(self, action: #selector(squareBtnClick), for: .touchUpInside)
        scrollView.addSubview(activeBtn)
        activeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(teamBtn)
            make.left.equalTo(myactiveBtn.snp.right).offset(30)
            make.width.height.equalTo(teamBtn)
        }
        
        // 活动群聊
//        let contactBtn = BomButton(frame: CGRect(x:270, y:150, width:50, height:70))
        let contactBtn = BomButton()
        contactBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        contactBtn.setTitle("活动群聊", for: .normal)
        contactBtn.setTitleColor(UIColor.black, for: .normal)
        contactBtn.setImage(UIImage(named: "contact"), for: .normal)
        contactBtn.titleLabel?.textAlignment = .center
        contactBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        scrollView.addSubview(contactBtn)
        contactBtn.snp.makeConstraints { (make) in
            make.top.equalTo(teamBtn)
            make.left.equalTo(activeBtn.snp.right).offset(30)
            make.width.height.equalTo(teamBtn)
        }
        
        // 社团活动label
        let activeLabel = UILabel()
        activeLabel.text = "社团活动"
        activeLabel.font = UIFont.systemFont(ofSize: 18)
        activeLabel.textColor = UIColor.black
        scrollView.addSubview(activeLabel)
        activeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(myactiveBtn.snp.bottom).offset(20)
        }
//        activeLabel.frame = CGRect(x:30, y:245, width:100, height:20)
        
        // 设置tableView
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
//        tableView.isScrollEnabled = false
        
        scrollView.addSubview(tableView)
        activeTableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(activeLabel.snp.bottom).offset(10)
            make.width.equalTo(Constant.screenW - 60)
            make.height.equalTo(340)
            make.bottom.equalTo(scrollView)
        }
//        tableView.frame = CGRect(x:30, y:275, width:Constant.screenW - 60, height:327)
        
    }
    
    // 头部视图
    func setupHeadView() {
        
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: 64)
        headView.backgroundColor = Constant.viewBackgroundColor
        view.addSubview(headView)
        
        // 左侧导航栏按钮
        let leftBtn = UIButton()
        leftBtn.backgroundColor = Constant.viewBackgroundColor
        leftBtn.setImage(UIImage(named: "left_bar"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchDown)
        headView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(20)
            make.centerY.equalTo(headView).offset(10)
            make.height.width.equalTo(35)
        }
        
        // 红色view
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        redView.layer.cornerRadius = 5
        redView.isHidden = true
        headView.addSubview(redView)
        self.redView = redView
        redView.snp.makeConstraints { (make) in
            make.height.width.equalTo(10)
            make.right.top.equalTo(leftBtn)
        }
        
        // 又侧扫一扫
        let rightBtn = UIButton()
        rightBtn.backgroundColor = Constant.viewBackgroundColor
        rightBtn.setImage(UIImage(named: "shao"), for: .normal)
        rightBtn.addTarget(self, action: #selector(scanBtnClick), for: .touchDown)
        headView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(headView).offset(-20)
            make.height.width.equalTo(leftBtn)
            make.centerY.equalTo(headView).offset(10)
        }
        
        // 标题
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.text = "优社团"
        title.textColor = UIColor.black
        headView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(headView).offset(10)
            make.centerX.equalTo(headView)
        }
        
    }
    
    func setupRefresh() {
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNewActive))
        header?.stateLabel.textColor = UIColor.gray
        header?.lastUpdatedTimeLabel.textColor = UIColor.gray
        activeTableView.mj_header = header
//        let footer = MJRefreshBackStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreActive))
//        footer?.stateLabel.textColor = UIColor.gray
//        activeTableView.mj_footer = footer
    }
    
    @objc func loadNewActive() {
        let params = NSMutableDictionary()
        params["method"] = Api.homeActive
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                self.activeArr.removeAllObjects()
                
                if response["data"].arrayObject != nil {
                    let dict = response["data"].arrayObject as! [NSDictionary]
                    for item in dict {
                        let homeActive = HomeActive(dict: item as! [String : AnyObject])
                        self.activeArr.add(homeActive)
                    }
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
            self.activeTableView.mj_header.endRefreshing()
            self.activeTableView.mj_header.endRefreshing()
            self.activeTableView.reloadData()
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
            self.activeTableView.mj_header.endRefreshing()
        }
        
    }
    
    
    // 判断是否存在未读消息
    func checkUnreadMessage() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.unreadMessage
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                if response["data"].stringValue == "1" {
                    // 说明存在未读的
                    self.redView.isHidden = false
                } else {
                    self.redView.isHidden = true
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
        
    }
    
    // 刷新token
    func refreshToken() {
        // 刷新token
        let params = NSMutableDictionary()
        params["method"] = Api.refreshTokenMethod
        params["token"] = AccountTool.getAccount()?.token!
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                let token = response["data"]["token"].stringValue
                // 保存token对象
                let dict = NSMutableDictionary()
                dict["token"] = token
                let date = NSDate()
                let timeInterval = Int(date.timeIntervalSince1970 * 1000)
                dict["time"] = timeInterval
                let account = Account(dict: dict as! [String : AnyObject])
                AccountTool.setAccount(account)
                AccountTool.saveToken(dict: dict)
                Networking.setHeader()
                // 判断是否认证
                AccountTool.checkAuth(window:  (UIApplication.shared.keyWindow)!)
                // 获取用户信息
                if AccountTool.getUser() == nil {
                    AccountTool.getUserInfo()
                }
                self.activeTableView.mj_header.beginRefreshing()
                self.checkUnreadMessage()
            } else {
                UIApplication.shared.keyWindow!.rootViewController = LoginViewController()
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
    }
    
//    @objc func loadMoreActive() {
//        print("more")
//        activeTableView.mj_footer.endRefreshing()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeActiveTableViewCell()
        let cellColorIndex = indexPath.row % 4
        let leftColor = cellColors[cellColorIndex]
        let rightColor = cellColorsAlpha[cellColorIndex]
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = cell.contentView.frame
        gradientLayer.frame.size.height = 100
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        let homeActive = activeArr[indexPath.row]
        cell.homeActive = homeActive as! HomeActive
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ActiveDetailViewController()
        let homeActive = activeArr[indexPath.row] as! HomeActive
        vc.activeId = homeActive.id!
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        let navi = NavigationController(rootViewController:vc)
        present(navi, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeArr.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func leftBtnClick() {
        view.addSubview(leftVc.view)
        leftVc.showAnimation()
    }
    
    @objc func scanBtnClick() {
        present(scanVc, animated: true, completion: nil)
    }
    
    @objc func myActiveBtnClick() {
        let vc = MyActiveViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        let navi = NavigationController(rootViewController:vc)
        present(navi, animated: true, completion: nil)
    }
    
    @objc func societyBtnClick() {
        let vc = MySocietyViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        let navi = NavigationController(rootViewController:vc)
        present(navi, animated: true, completion: nil)
    }
    
    @objc func squareBtnClick() {
        let vc = ActiveSquareViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        let navi = NavigationController(rootViewController:vc)
        present(navi, animated: true, completion: nil)
    }

}
