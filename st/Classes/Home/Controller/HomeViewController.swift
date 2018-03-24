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
    
    lazy var leftVc = {() -> LeftViewController in
        let leftVc = LeftViewController()
        leftVc.view.frame = CGRect(x: 0, y: 20, width: Constant.screenW, height: Constant.screenH)
        return leftVc
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
        
    }
    
    // 设置主滑动视图
    func setupScrollView() {
     
        let scrollView = UIScrollView(frame: CGRect(x:0, y:65, width:Constant.screenW, height:Constant.screenH - 65))
        scrollView.backgroundColor = Constant.viewBackgroundColor
        scrollView.contentSize = CGSize(width: Constant.screenW, height: 602)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        self.scrollView = scrollView
    }
    
    // 设置主滑动视图内部视图
    func setupScrollViewDetail() {
        
        // 用户头像
        let headImageView = UIImageView()
        let url = Api.host + "/" + ((AccountTool.getUser()?.mobile)! as String )
        headImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_placeholder"))
        headImageView.layer.cornerRadius = 37
        headImageView.layer.masksToBounds = true
        scrollView.addSubview(headImageView)
        self.headImageView = headImageView
        headImageView.frame = CGRect(x:30, y:35, width:74, height:74)
        
        // 用户姓名
        let nameLabel = UILabel()
//        nameLabel.text = ((AccountTool.getUser()?.name)! as String)
        nameLabel.text = "测试测试测试"
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.frame = CGRect(x:130, y:47, width:160, height:25)
        
        // 用户学校
        let schoolLabel = UILabel()
        schoolLabel.text = ((AccountTool.getUser()?.school)! as String)
        schoolLabel.font = UIFont.systemFont(ofSize: 16)
        schoolLabel.textColor = UIColor.gray
        scrollView.addSubview(schoolLabel)
        self.schoolLabel = schoolLabel
        schoolLabel.frame = CGRect(x:130, y:75, width:160, height:20)
        
        // 常用功能label
        let killsLabel = UILabel()
        killsLabel.text = "常用功能"
        killsLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(killsLabel)
        killsLabel.frame = CGRect(x:30, y:145, width:100, height:20)
        
        // 我的社团
        let teamBtn = BomButton(frame: CGRect(x:30, y:175, width:50, height:70))
        teamBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        teamBtn.setTitle("我的社团", for: .normal)
        teamBtn.setTitleColor(UIColor.black, for: .normal)
        teamBtn.setImage(UIImage(named: "team"), for: .normal)
        teamBtn.titleLabel?.textAlignment = .center
        teamBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        scrollView.addSubview(teamBtn)
        
        // 活动广场
        let activeBtn = BomButton(frame: CGRect(x:110, y:175, width:50, height:70))
        activeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        activeBtn.setTitle("活动广场", for: .normal)
        activeBtn.setTitleColor(UIColor.black, for: .normal)
        activeBtn.setImage(UIImage(named: "active"), for: .normal)
        activeBtn.titleLabel?.textAlignment = .center
        activeBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        scrollView.addSubview(activeBtn)
        
        // 活动群聊
        let contactBtn = BomButton(frame: CGRect(x:190, y:175, width:50, height:70))
        contactBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        contactBtn.setTitle("活动群聊", for: .normal)
        contactBtn.setTitleColor(UIColor.black, for: .normal)
        contactBtn.setImage(UIImage(named: "contact"), for: .normal)
        contactBtn.titleLabel?.textAlignment = .center
        contactBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        scrollView.addSubview(contactBtn)
        
        // 历史活动
        let recentBtn = BomButton(frame: CGRect(x:270, y:175, width:50, height:70))
        recentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        recentBtn.setTitle("历史活动", for: .normal)
        recentBtn.setTitleColor(UIColor.black, for: .normal)
        recentBtn.setImage(UIImage(named: "recent"), for: .normal)
        recentBtn.titleLabel?.textAlignment = .center
        recentBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
        scrollView.addSubview(recentBtn)
        
        // 社团活动label
        let activeLabel = UILabel()
        activeLabel.text = "社团活动"
        activeLabel.font = UIFont.systemFont(ofSize: 18)
        activeLabel.textColor = UIColor.black
        scrollView.addSubview(activeLabel)
        activeLabel.frame = CGRect(x:30, y:260, width:100, height:20)
        
        // 设置tableView
        let tableView = UITableView()
        //        tableView.delegate = self
        //        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        scrollView.addSubview(tableView)
        tableView.frame = CGRect(x:30, y:290, width:Constant.screenW - 60, height:312)
        
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
   

}
