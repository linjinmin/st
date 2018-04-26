//
//  UserShowViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class UserShowViewController: UIViewController{
    
    // 活动id
    weak var active_id: NSString!
    // 用户id
    weak var user_id: NSString!
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
//    weak var tissueTableView: UITableView!
    // 社团label
    weak var tissueLabel: UILabel!
    // 社团view
    weak var tissueView: UIView!
    // 活动tableView
//    weak var activeTableView: UITableView!
    // 活动label
    weak var activeLabel: UILabel!
    // 活动view
    weak var activeView: UIView!
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
    
    var userInfo: UserInfo! {
        didSet{
            
            headImageView.sd_setImage(with: URL(string: userInfo.head_pic as String), placeholderImage: UIImage(named:"image_placeholder"))
            nameLabel.text = "\(userInfo.name ?? "")"
            sexLabel.text = "\(userInfo.sex ?? "")"
            addressLabel.text = "\(userInfo.province ?? "") \(userInfo.school ?? "") \(userInfo.series ?? "")"
            
            var count = 0
            
            if userInfo.tissue.count > 0 {
                
                tissueView.snp.makeConstraints { (make) in
                    make.left.equalTo(headImageView)
                    make.top.equalTo(tissueLabel.snp.bottom).offset(5)
                    make.width.equalTo(Constant.screenW - 60)
                    make.height.equalTo(userInfo.tissue.count * 70)
                }
                
                for item in userInfo.tissue {
                    
                    let item = item as! [String : AnyObject]
                    let myTissue = MyTissue(dict: item)
                    let view = MyTissueView()
                    view.frame = CGRect(x: count * 70, y: 0, width: Int(Constant.screenW - 60), height: 70)
                    view.myTissue = myTissue
                    tissueView.addSubview(view)
                }
                
                count = count + 1
                
            } else {
                tissueView.snp.makeConstraints { (make) in
                    make.left.equalTo(headImageView)
                    make.top.equalTo(tissueLabel.snp.bottom).offset(5)
                    make.width.equalTo(Constant.screenW - 60)
                    make.height.equalTo(0)
                }
                
                tissueLabel.isHidden = true
            }
            
            count = 0
            
            if userInfo.active != nil {
                if userInfo.active.count > 0 {
                    
                    activeView.snp.makeConstraints { (make) in
                        make.left.equalTo(headImageView)
                        make.top.equalTo(activeLabel.snp.bottom).offset(10)
                        make.width.equalTo(Constant.screenW - 60)
                        make.height.equalTo(userInfo.active.count * 100)
                    }
                    
                    for item in userInfo.active {
                        
                        let item = item as! [String : AnyObject]
                        let myActive = MyActive(dict: item)
                        let view = MyActiveView()
                        view.frame = CGRect(x: count * 100, y:0, width:Int(Constant.screenW - 60), height: 100)
                        view.myActive = myActive
                        let colorIndex = count % 4
                        let leftColor = cellColors[colorIndex]
                        let rightColor = cellColorsAlpha[colorIndex]
                        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
                        let gradientLocations:[NSNumber] = [0.0, 1.0]
                        //创建CAGradientLayer对象并设置参数
                        let gradientLayer = CAGradientLayer()
                        gradientLayer.colors = gradientColors
                        gradientLayer.frame.size.width = Constant.screenW-60
                        gradientLayer.frame.size.height = 100
                        gradientLayer.locations = gradientLocations
                        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                        gradientLayer.type = kCAGradientLayerAxial;
                        view.layer.insertSublayer(gradientLayer, at: 0)
                        view.layer.cornerRadius = 10
                        view.layer.masksToBounds = true
                        activeView.addSubview(view)
                    }
                    
                }
            }
            
            if user_id == AccountTool.getUser()?.id! {
                // 显示手机号
                mobileLabel.text = "\(AccountTool.getUser()?.mobile ?? "")"
                mobileLabel.isHidden = false
                mobileBtn.isHidden = true
            } else if userInfo.apply_mobile == "1" {
                // 显示手机号
                mobileLabel.text = "\(userInfo.mobile ?? "")"
                mobileLabel.isHidden = false
                mobileBtn.isHidden = true
            }
            
            view.layoutIfNeeded()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if user_id == AccountTool.getUser()?.id! {
            
            let url = Api.host + "/" + ((AccountTool.getUser()?.head_pic)! as String )
            headImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_placeholder"))
            
            nameLabel.text = "\(AccountTool.getUser()?.name ?? "")"
            sexLabel.text = "\(AccountTool.getUser()?.sex_name ?? "")"
            addressLabel.text = "\(AccountTool.getUser()?.province_name ?? "") \(AccountTool.getUser()?.school_name ?? "") \(AccountTool.getUser()?.series_name ?? "")"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "优社团"
        view.backgroundColor = Constant.viewBackgroundColor
        
        setup()
        getData()
        
        if user_id == AccountTool.getUser()?.id! {
            // 说明是用户个人信息
            // 设置右编辑按钮
            let button = UIButton()
            button.frame = CGRect(x:0 ,y:0, width:20, height:32)
            button.setTitle("编辑", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(edit), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        headImageView.layer.cornerRadius = 50
        scrollView.addSubview(headImageView)
        self.headImageView = headImageView
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(30)
            make.top.equalTo(scrollView).offset(20)
            make.height.width.equalTo(100)
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
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        // 地址
        let addressLabel = setupLabel(font: 16, color: UIColor.lightGray)
        addressLabel.numberOfLines = 0
        scrollView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(sexLabel.snp.bottom).offset(5)
        }
        
        // 手机号label
        let mobileLabel = setupLabel(font: 16, color: UIColor.lightGray)
        scrollView.addSubview(mobileLabel)
        mobileLabel.isHidden = true
        self.mobileLabel = mobileLabel
        mobileLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
        }
        
        // 手机号btn
        let mobileBtn = UIButton()
        mobileBtn.setTitle("申请查看手机号", for: .normal)
        mobileBtn.setTitleColor(Constant.viewColor, for: .normal)
        mobileBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        mobileBtn.addTarget(self, action: #selector(mobileBtnClick), for: .touchUpInside)
        scrollView.addSubview(mobileBtn)
        self.mobileBtn = mobileBtn
        mobileBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
//            make.width.equalTo(150)
        }
        
        // 参与的社团
        let tissueLabel = setupLabel(font: 18, color: UIColor.black)
        tissueLabel.text = "参与社团"
        scrollView.addSubview(tissueLabel)
        self.tissueLabel = tissueLabel
        tissueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(30)
        }
        
        // 社团view
        let tissueView = UIView()
        tissueView.backgroundColor = UIColor.clear
        scrollView.addSubview(tissueView)
        self.tissueView = tissueView

        // 活动Label
        let activeLabel = setupLabel(font: 18, color: UIColor.black)
        activeLabel.text = "最近参与"
        scrollView.addSubview(activeLabel)
        self.activeLabel = activeLabel
        activeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView)
            make.top.equalTo(tissueView.snp.bottom).offset(10)
        }
        
        // 活动view
        let activeView = UIView()
        activeView.backgroundColor = UIColor.clear
        scrollView.addSubview(activeView)
        self.activeView = activeView
        
    }
    
    func getData() {
        
        let params = NSMutableDictionary()
        params["user_id"] = user_id
        params["method"] = Api.userDetail
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                
                let userInfo = UserInfo(dict: response["data"].dictionaryObject! as [String : AnyObject])
                
                    self.userInfo = userInfo
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func mobileBtnClick() {
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
        let params = NSMutableDictionary()
        params["active_id"] = active_id
        params["user_id"] = user_id
        params["method"] = Api.applyMobile
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"] == 200 {
                SVProgressHUD.showSuccess(withStatus: response["msg"].stringValue)
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }

    }
    
    func setupLabel(font: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = color
        return label
    }
    
    
    @objc func edit() {
        let vc = UserInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
