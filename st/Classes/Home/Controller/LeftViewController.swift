//
//  LeftViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/10.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LeftViewController: UIViewController {
    
    // 背景view
    weak var bgView: UIView!
    // 左侧功能条view
    weak var leftView: UIView!
    // 红点view
    weak var redView: UIView!
    // 名字label
    weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景
        setupBg()
        // 设置左侧功能条
        setupLeftView()
        // 设置手势
        setupGesture()
        // 设置左侧功能条详细内容
        setupDetailView()

        checkUnreadMessage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.rootViewController?.viewWillAppear(animated)
        if self.nameLabel != nil {
            nameLabel.text = "\(AccountTool.getUser()?.name! ?? "")"
        }
    }
    
    
    // 设置背景
    func setupBg() {
        let bgViewTmp = UIView()
        bgViewTmp.backgroundColor = UIColor(red: 91/255, green: 91/255, blue: 91/255, alpha: 1)
        bgViewTmp.alpha = 0
        bgView = bgViewTmp
        view .addSubview(bgViewTmp)
        bgViewTmp.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
    
    
    // 设置左侧功能条
    func setupLeftView() {
        
        // 设置左侧功能条view
        let leftViewTmp = UIView()
        leftViewTmp.frame = CGRect(x: -Constant.functionListViewWidth, y: 0, width: Constant.functionListViewWidth, height: Constant.screenH)
        leftViewTmp.backgroundColor = Constant.viewBackgroundColor
        view.addSubview(leftViewTmp)
        self.leftView = leftViewTmp
        
        // 设置隐藏btn 点击回到主界面
        let backButton = UIButton()
        backButton.backgroundColor = UIColor.clear
        backButton.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backButton.frame = CGRect(x: Constant.functionListViewWidth, y: 0, width: Constant.screenW - Constant.functionListViewWidth, height: Constant.screenH)
        view.addSubview(backButton)
        
    }
    
    
    // 设置左侧功能条内容
    func setupDetailView() {
        
        // 头像
        let headImageView = UIImageView(image: UIImage(named: "user"))
        headImageView.layer.cornerRadius = 25
        headImageView.layer.masksToBounds = true
//        headImageView.layer.shadowOpacity = 0.8
//        headImageView.layer.shadowColor = Constant.viewColor.cgColor
        leftView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView).offset(Constant.functionListViewWidth * 0.1)
            make.height.width.equalTo(50)
            make.top.equalTo(leftView).offset(40)
        }
        
        // 姓名
        let nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.systemFont(ofSize: 18)
        nicknameLabel.text = "\(AccountTool.getUser()?.name! ?? "")"
        leftView.addSubview(nicknameLabel)
        self.nameLabel = nicknameLabel
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.top.equalTo(headImageView).offset(10)
            make.height.equalTo(25)
            make.width.equalTo(120)
        }
        
        // 个人信息按钮
        let infoBtn = setupBtn("个人信息", normalImage: "info", normalColor: Constant.functionListFontColor, font: 16, selector: #selector(infoBtnClick))
        leftView.addSubview(infoBtn)
        infoBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.height.equalTo(45)
            make.top.equalTo(headImageView.snp.bottom).offset(40)
        }
        
        // 修改密码
        let pwdBtn = setupBtn("修改密码", normalImage: "left_password", normalColor: Constant.functionListFontColor, font: 16, selector:#selector(pwdBtnClick))
        leftView.addSubview(pwdBtn)
        pwdBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(infoBtn)
            make.top.equalTo(infoBtn.snp.bottom).offset(Constant.functionListBtnOffset)
        }
        
        // 消息公告
        let noticeBtn = setupBtn("消息公告", normalImage: "message", normalColor: Constant.functionListFontColor, font: 16, selector: #selector(noticeBtnClick))
        leftView.addSubview(noticeBtn)
        noticeBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(infoBtn)
            make.top.equalTo(pwdBtn.snp.bottom).offset(Constant.functionListBtnOffset)
        }
        
        // 红点
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        redView.layer.cornerRadius = 5
        redView.isHidden = true
        leftView.addSubview(redView)
        self.redView = redView
        redView.snp.makeConstraints { (make) in
            make.centerY.equalTo(noticeBtn)
            make.height.width.equalTo(10)
            make.right.equalTo(leftView).offset(-20)
        }
        
        // 意见反馈
        let feedbackBtn = setupBtn("意见反馈", normalImage: "feedback", normalColor: Constant.functionListFontColor, font: 16, selector: #selector(feedbackBtnClick))
        leftView.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(infoBtn)
            make.top.equalTo(noticeBtn.snp.bottom).offset(Constant.functionListBtnOffset)
        }
        
        // 关于我们
        let aboutBtn = setupBtn("关于我们", normalImage: "message", normalColor: Constant.functionListFontColor, font: 16, selector: #selector(aboutBtnClick))
        leftView.addSubview(aboutBtn)
        aboutBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(infoBtn)
        make.top.equalTo(feedbackBtn.snp.bottom).offset(Constant.functionListBtnOffset)
        }
        
        // 登出
        let logoutBtn = setupBtn("账号注销", normalImage: "logout", normalColor: Constant.functionListFontColor, font: 16, selector: #selector(logoutBtnClick))
        leftView.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(infoBtn)
            make.top.equalTo(aboutBtn.snp.bottom).offset(Constant.functionListBtnOffset)
        }
        
        // 优社团 标识
        let teamLabel = UILabel()
        teamLabel.font = UIFont.systemFont(ofSize: 20)
        teamLabel.textColor = Constant.viewColor
        teamLabel.text = "优社团"
        leftView.addSubview(teamLabel)
        teamLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(leftView)
            make.bottom.equalTo(leftView).offset(-25)
        }
        
    }
    
    
    // 个人信息按钮点击
    @objc func infoBtnClick() {
//        let vc = UserInfoViewController()
//        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
//        let nav = NavigationController(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
        let vc = UserShowViewController()
        vc.user_id = AccountTool.getUser()?.id!
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let nav = NavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // 修改密码按钮点击
    @objc func pwdBtnClick() {
        let vc = ChangePwdViewController()
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let nav = NavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // 消息公告按钮点击
    @objc func noticeBtnClick() {
        let vc = NoticeTableViewController()
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let nav = NavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // 意见反馈按钮点击
    @objc func feedbackBtnClick() {
        let vc = SuggesViewController()
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let nav = NavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // 关于我们按钮点击
    @objc func aboutBtnClick() {
        
    }
    
    // 界面展示动画
    func showAnimation() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.bgView.alpha = 0.5
            self.leftView.x = 0
        }
    }
    
    
    // 界面关闭动画
    func hideAnimation() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0.5
            self.leftView.x = -Constant.functionListViewWidth
        }) { (finish) in
            self.presentingViewController?.childViewControllers.last?.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // 隐藏按钮点击退出当前视图
    @objc func backBtnClick() {
        hideAnimation()
    }
    
    // 登出
    @objc func logoutBtnClick() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.logout
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                SVProgressHUD.showSuccess(withStatus: "登出成功")
                // 删除本地缓存
                AccountTool.clearUser()
                AccountTool.clearAccount()
                UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    // 设置滑动手势
    func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(pan)
    }
    
    // 拖拽手势
    @objc func panGesture(_ pan: UIPanGestureRecognizer) {
        let translatePoint = pan.translation(in: view)
        let translateX = translatePoint.x
        let currentX = leftView.x
        
        if pan.state == .ended {
            
            if self.leftView.x < -87.5 {
                hideAnimation()
            } else {
                showAnimation()
            }
            
        } else if pan.state == .changed {
            
            if currentX + translateX < 0 {
                leftView.x += translateX
                bgView.alpha += translateX * (1/343.0)
            }
            
            pan.setTranslation(CGPoint.zero, in: view)
        }
    }
    

    @objc func leftViewBtnTouchDown(sender: UIButton) {
//        sender.backgroundColor = UIColor.gray
    }
    
    @objc func leftViewBtnTouchCancel(sender: UIButton) {
        sender.backgroundColor = UIColor.clear
    }
    
    
    /**
     * @brief 生成按钮
     * @param title          按钮标题
     * @param normalImage    正常状态下图像
     * @param selectedImage 高亮状态下图像
     * @param normalColor    正常状态下字体颜色
     * @param selectedColor 高亮状态下字体颜色
     * @param font           字体大小
     * @param interaction    是否允许用户交互
     * @param selector       方法
     * @return 返回button
     */
    func setupBtn(_ title: String, normalImage: String, normalColor: UIColor, font: CGFloat, selector:Selector) -> UIButton {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .left
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(named: normalImage), for: .normal)
        btn.setTitleColor(normalColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: font)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constant.functionListViewWidth * 0.15, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: Constant.functionListViewWidth * 0.1, bottom: 0, right: 0)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.addTarget(self, action: #selector(leftViewBtnTouchDown(sender:)), for: .touchDown)
        btn.addTarget(self, action: #selector(leftViewBtnTouchCancel(sender:)), for: .touchCancel)
        return btn
    }

    

}
