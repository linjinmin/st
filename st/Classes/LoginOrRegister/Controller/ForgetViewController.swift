//
//  ForgetViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/4.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ForgetViewController: UIViewController, UITextFieldDelegate {

    // 账号field
    weak var mobileField: UITextField!
    // 新密码field
    weak var passwordField: UITextField!
    // 重复密码field
    weak var repasswordField: UITextField!
    // 验证码field
    weak var codeField: UITextField!
    // 验证码btn
    weak var codeBtn: UIButton!
    
    fileprivate lazy var textFields: [UITextField] = [self.mobileField, self.passwordField, self.repasswordField, self.codeField]
    
    
    // code timer
    var timer: Timer!
    var timeCount: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupKeyBoardNotification()
    }
    
    func setup() {
        // 设置背景颜色
        view.backgroundColor = Constant.loginOrRegisterBackgroundColor
        
        // 设置背景图片
        let backgrounImage = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgrounImage)
        backgrounImage.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(view)
        }
        
        // 重复密码field
        repasswordField = setupTextField(placeHolder: "确认新密码", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "password_con")
        repasswordField.isSecureTextEntry = true
        view.addSubview(repasswordField)
        repasswordField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(42)
            make.top.equalTo(view.snp.centerY).offset(-40)
        }
        
        // 密码field
        passwordField = setupTextField(placeHolder: "新密码", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "password")
        passwordField.isSecureTextEntry = true
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(repasswordField)
            make.bottom.equalTo(repasswordField.snp.top).offset(-30)
        }
        
        // 账号field
        mobileField = setupTextField(placeHolder: "手机号", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "user")
        view.addSubview(mobileField)
        mobileField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(repasswordField)
            make.bottom.equalTo(passwordField.snp.top).offset(-30)
        }
        
        
        // 登录label
        let titleLabel = UILabel()
        titleLabel.text = "重置密码"
        titleLabel.textColor = Constant.loginOrRegisterTitleColor
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(mobileField.snp.top).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        // 验证码field
        codeField = setupTextField(placeHolder: "验证码", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "code")
        view.addSubview(codeField)
        codeField.snp.makeConstraints { (make) in
            make.left.height.equalTo(repasswordField)
            make.top.equalTo(repasswordField.snp.bottom).offset(30)
            make.right.equalTo(view.snp.centerX).offset(10)
        }
        
        // 获取验证码按钮
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(Constant.loginOrRegisterTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(codeBtnClick), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.layer.cornerRadius = 21
        view.addSubview(button)
        codeBtn = button
        button.snp.makeConstraints { (make) in
            make.top.height.equalTo(codeField)
            make.right.equalTo(repasswordField)
            make.left.equalTo(view.snp.centerX).offset(20)
        }
        
        // 确认按钮
        let confirmBtnClick = UIButton()
        confirmBtnClick.setTitle("确认", for: .normal)
        confirmBtnClick.backgroundColor = .white
        confirmBtnClick.setTitleColor(Constant.loginOrRegisterTitleColor, for: .normal)
        confirmBtnClick.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmBtnClick.addTarget(self, action: #selector(resetBtnClick), for: .touchUpInside)
        confirmBtnClick.layer.borderColor = UIColor.white.cgColor
        confirmBtnClick.layer.shadowOpacity = 0.2
        confirmBtnClick.layer.shadowColor = UIColor.black.cgColor
        confirmBtnClick.layer.shadowOffset = CGSize(width: 0, height: 5)
        confirmBtnClick.layer.shadowRadius = 5
        confirmBtnClick.layer.cornerRadius = 21
        view.addSubview(confirmBtnClick)
        confirmBtnClick.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(repasswordField)
            make.top.equalTo(codeField.snp.bottom).offset(30)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 获取验证码按钮点击
    @objc func codeBtnClick(sender: UIButton) {
        
        if !validateMobile() {
            SVProgressHUD.showError(withStatus: "请输入合法手机号")
            return
        }
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
        let params = NSMutableDictionary()
        params["method"]  = Api.forgetCodeMethod
        params["account"] = mobileField.text
        
        // 获取验证码
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = response as! Dictionary<String, Any>
            
            if response["code"] as! CGFloat == 200 {
                SVProgressHUD.showSuccess(withStatus: "验证码已发送")
            } else {
                SVProgressHUD.showError(withStatus: response["msg"] as? String)
            }
            
            // 开启定时
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            self.timeCount = 60
            self.codeBtn.isEnabled = false
            self.codeBtn.titleLabel?.alpha = 0.5
        }) { (tesk, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
    }
    
    // 确认按钮点击
    @objc func resetBtnClick() {
        
        if !validateMobile() {
            SVProgressHUD.showError(withStatus: "请输入合法手机号")
            return
        }
        
        if !validatePassword() {
            SVProgressHUD.showError(withStatus: "密码格式错误")
            return
        }
        
        if !validateRepassword() {
            SVProgressHUD.showError(withStatus: "重复密码错误")
            return
        }
        
        let params = NSMutableDictionary()
        params["method"] = Api.forgetPwdMethod
        params["account"] = mobileField.text
        params["new_password"] = passwordField.text
        params["code"] = codeField.text

        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].floatValue == 200 {
                SVProgressHUD.showSuccess(withStatus: "重置密码成功，请重新登录")
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    
    @objc func countDown() {
        // 验证码倒计时
        timeCount -= 1
        
        if timeCount == 0 {
            codeBtn.isEnabled = true
            codeBtn.titleLabel?.alpha = 1
            timer.invalidate()
            timer = nil
        }
        
        codeBtn.setTitle("\(timeCount)秒后重新获取", for: .disabled)
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
    
    // 重复密码检测
    func validateRepassword() -> Bool {
        if passwordField.text == repasswordField.text {
            return true
        }
        return false
    }
    
    // 验证码检测
    func validateCode() -> Bool {
        let codeRegex: String = "^([0-9])\\d{4}$"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codeTest.evaluate(with: codeField.text)
    }
    
    func setupKeyBoardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func keyboardChange(_ note: Foundation.Notification) {
        for textField in textFields {
            if textField.isFirstResponder {
                let frame = ((note as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
                let keyboardY = frame?.origin.y
                if keyboardY == UIScreen.main.bounds.size.height {
                    view.transform = CGAffineTransform.identity
                    return
                }
                let textY = textField.frame.maxY + 180
                if textY > keyboardY! {
                    view.transform = CGAffineTransform(translationX: 0, y: keyboardY! - textY)
                }
            }
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
        textField.layer.shadowRadius = 21
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 0, height: 21)
        textField.delegate = self
        return textField
    }
}
