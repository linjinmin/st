//
//  ChangePwdViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/27.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ChangePwdViewController: UIViewController, SingleKeyBoardDelegate, UITextFieldDelegate {

    // 原密码field
    weak var oldpasswordField: UITextField!
    // 密码field
    weak var passwordField: UITextField!
    // 重复密码field
    weak var repasswordField: UITextField!
    // 确认按钮btn
    weak var confirmBtn: UIButton!
    
    fileprivate lazy var textFields: [UITextField] = [self.oldpasswordField, self.passwordField, self.repasswordField]
    
    // code timer
    var timer: Timer!
    var timeCount: Int = 0
    
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupKeyBoardNotification()
        
    }
    
    
    func setup() {
        // 设置背景颜色
        view.backgroundColor = Constant.loginOrRegisterBackgroundColor
        
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
        oldpasswordField = setupTextField(placeHolder: "旧密码", tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, leftView: "password")
        view.addSubview(oldpasswordField)
        oldpasswordField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(repasswordField)
            make.bottom.equalTo(passwordField.snp.top).offset(-30)
        }
        
        // 登录label
        let titleLabel = UILabel()
        titleLabel.text = "修改密码"
        titleLabel.textColor = Constant.loginOrRegisterTitleColor
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(oldpasswordField.snp.top).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        // 确认按钮
        let confirmBtn = UIButton()
        confirmBtn.setTitle("更改密码", for: .normal)
        confirmBtn.backgroundColor = Constant.viewColor
        confirmBtn.setTitleColor(Constant.viewBackgroundColor, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        confirmBtn.layer.borderColor = UIColor.white.cgColor
        confirmBtn.layer.shadowOpacity = 0.2
        confirmBtn.layer.shadowColor = UIColor.black.cgColor
        confirmBtn.layer.shadowOffset = CGSize(width: 0, height: 11)
        confirmBtn.layer.shadowRadius = 11
        confirmBtn.layer.cornerRadius = 21
        self.confirmBtn = confirmBtn
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(repasswordField)
            make.top.equalTo(repasswordField.snp.bottom).offset(30)
        }
    }
    
    
    @objc func confirmBtnClick() {
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
        
        if !validateOldPassword() {
            SVProgressHUD.showError(withStatus: "旧密码格式错误")
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
        params["old_password"] = oldpasswordField.text
        params["new_password"] = passwordField.text
        params["method"] = Api.alterPassword
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                self.navigationController?.dismiss(animated: true, completion: nil)
                SVProgressHUD.showSuccess(withStatus: "修改密码成功")
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadingTitle)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // 旧密码检测
    func validateOldPassword() -> Bool {
        let  passWordRegex = "^[a-zA-Z0-9]\\w{5,17}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: oldpasswordField.text)
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
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
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
        textField.layer.shadowRadius = 11
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 0, height: 11)
        textField.delegate = self
        textField.inputAccessoryView = singleKeyBoard
        return textField
    }

}
