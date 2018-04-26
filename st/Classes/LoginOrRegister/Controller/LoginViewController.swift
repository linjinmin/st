//
//  LoginViewController.swift
//  st
//
//  Created by 林劲民 on 2018/2/28.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate, SingleKeyBoardDelegate{
    
    
    // 手机号field
    weak var mobileField: UITextField!
    // 密码field
    weak var passwordField: UITextField!
    
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    
    // 初始化
    func setup() {
        // 设置背景颜色
        view.backgroundColor = Constant.loginOrRegisterBackgroundColor
        
        // 设置背景图片
        let backgrounImage = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgrounImage)
        backgrounImage.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(view)
        }
        
        // 设置账号textfield
        mobileField = setupTextField(placeHolder: "手机号", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .numberPad, font: 17, leftView: "user")
        view.addSubview(mobileField)
        mobileField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(42)
            make.top.equalTo(view.snp.centerY).offset(-120)
        }
        
        // 密码field
        passwordField = setupTextField(placeHolder: "密码", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "login_password")
        passwordField.isSecureTextEntry = true
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(mobileField)
            make.top.equalTo(mobileField.snp.bottom).offset(30)
        }
        
        // 登录label
        let titleLabel = UILabel()
        titleLabel.text = "登录"
        titleLabel.textColor = Constant.loginOrRegisterTitleColor
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(mobileField.snp.top).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        // 登录按钮
        let registerBtn = UIButton()
        registerBtn.backgroundColor = .white
        registerBtn.setTitle("登录", for: .normal)
        registerBtn.setTitleColor(Constant.loginOrRegisterTitleColor, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        registerBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        registerBtn.layer.borderColor = UIColor.white.cgColor
        registerBtn.layer.shadowOpacity = 0.2
        registerBtn.layer.shadowColor = UIColor.black.cgColor
        registerBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        registerBtn.layer.shadowRadius = 5
        registerBtn.layer.cornerRadius = 21
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.right.height.equalTo(mobileField)
            make.top.equalTo(passwordField.snp.bottom).offset(30)
            make.left.equalTo(view.snp.centerX).offset(16)
        }
        
        // 注册按钮
        let LoginBtn = UIButton()
        LoginBtn.backgroundColor = .white
        LoginBtn.setTitle("注册", for: .normal)
        LoginBtn.setTitleColor(Constant.loginOrRegisterTitleColor, for: .normal)
        LoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        LoginBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchDown)
        LoginBtn.layer.borderColor = UIColor.white.cgColor
        LoginBtn.layer.shadowOpacity = 0.2
        LoginBtn.layer.shadowColor = UIColor.black.cgColor
        LoginBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        LoginBtn.layer.shadowRadius = 5
        LoginBtn.layer.cornerRadius = 21
        view.addSubview(LoginBtn)
        LoginBtn.snp.makeConstraints { (make) in
            make.left.height.equalTo(mobileField)
            make.top.equalTo(passwordField.snp.bottom).offset(30)
            make.right.equalTo(view.snp.centerX).offset(-8)
        }
        
        // 忘记密码label
        let forgetBtn = UIButton()
        forgetBtn.setTitle("忘记密码", for: .normal)
        forgetBtn.setTitleColor(Constant.loginOrRegisterTitleColor, for: .normal)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        forgetBtn.backgroundColor = Constant.loginOrRegisterBackgroundColor
        forgetBtn.addTarget(self, action: #selector(forgetBtnClick), for: .touchUpInside)
        view.addSubview(forgetBtn)
        forgetBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(mobileField.snp.top).offset(-5)
            make.right.equalTo(mobileField).offset(-5)
        }
        
    }
    
    
    func setupTextField(placeHolder: String, tintColor: UIColor, textColor: UIColor, backgroundColor: UIColor, keyboardType: UIKeyboardType, font: CGFloat, leftView: String) -> UITextField {
        
        let textField = LoginOrRegisterField()
        textField.tintColor         = tintColor
        textField.placeholder       = placeHolder
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [
            NSAttributedStringKey.foregroundColor : Constant.placeholderColor,
            NSAttributedStringKey.font: Constant.placeholderFont
        ])
        textField.keyboardType      = keyboardType
        textField.textColor         = textColor
        textField.backgroundColor   = backgroundColor
        textField.font              = UIFont.systemFont(ofSize: font)
        textField.leftViewMode      = UITextFieldViewMode.always
        textField.leftView          = UIImageView.init(image: UIImage(named:leftView))
        textField.layer.cornerRadius = 21
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 5
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 0, height: 5)
        textField.delegate = self
        textField.inputAccessoryView = singleKeyBoard
        return textField
    }
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 注册按钮点击
    @objc func registerBtnClick() {
        let vc = RegisterViewController()
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let generalNaviVc = NavigationController(rootViewController: vc)
        present(generalNaviVc, animated: true, completion: nil)
    }
    
    // 登录按钮点击
    @objc func loginBtnClick() {
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
        if !loginCheck() {
            return
        }
        
        let params = NSMutableDictionary()
        params["account"] = mobileField.text
        params["password"] = passwordField.text
        params["method"] = Api.loginMethod
 
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                let dict = NSMutableDictionary()
                dict["token"] = (response["data"].dictionaryObject! as [String : AnyObject])["token"]
                let date = NSDate()
                let timeInterval = Int(date.timeIntervalSince1970 * 1000)
                dict["tokenTime"] = timeInterval
                let account = Account(dict: dict as! [String : AnyObject])
                AccountTool.setAccount(account)
                AccountTool.saveToken(dict: dict)
                Networking.setHeader()
                
                // 保存用户信息
                let userDict = (response["data"].dictionaryObject! as [String : AnyObject])["user"]
                let user = User(dict: userDict as! [String : AnyObject])
                AccountTool.setUser(user)
                // 保存数据到本地
                AccountTool.saveUserInfo(dict: userDict as! NSDictionary)
                
                let vc = HomeViewController()
                vc.is_login = "1"
                UIApplication.shared.keyWindow?.rootViewController = vc
                AccountTool.checkAuth(window: UIApplication.shared.keyWindow!)
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (tesk, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    // 忘记密码点击
    @objc func forgetBtnClick() {
        let vc = ForgetViewController()
        vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
        let generalNaviVc = NavigationController(rootViewController: vc)
        present(generalNaviVc, animated: true, completion: nil)
    }
    
    // 登录判断
    func loginCheck() -> Bool {
        
        if !validateMobile() || !validatePassword() {
            SVProgressHUD.showError(withStatus: "手机号或密码格式错误")
            return false
        }
        
        return true
    }
    
    // 手机号检测
    func validateMobile() -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: mobileField.text)
    }
    
    // 密码检测
    func validatePassword() -> Bool {
        let  passWordRegex = "^[a-zA-Z0-9]\\w{5,17}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: passwordField.text)
    }

}
