//
//  TeamJoinViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/19.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class TeamJoinViewController: UIViewController, SingleKeyBoardDelegate {

    // 活动ID
    var active_id: NSString!
    // 最大报名人数
    var max: NSString!
    // 最少报名人数
    var min: NSString!
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    // textfield 数组
    lazy var fieldArr = {() -> NSArray in
        let arr = NSArray()
        return arr
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "组队报名"
        view.backgroundColor = Constant.viewBackgroundColor
        setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        // 报名button
        let btn = UIButton()
        btn.backgroundColor = Constant.viewColor
        btn.setTitle("报名", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(btnClick), for: .touchDown)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.layer.shadowRadius = 5
        btn.layer.cornerRadius = 21
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(50)
            make.bottom.equalTo(view).offset(-30)
        }
        
        // 背景scrollview
        let backScrollView = UIScrollView()
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.backgroundColor = UIColor.clear
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(btn.snp.top).offset(10)
        }
        
        backScrollView.contentSize = CGSize.init(width: Constant.screenW, height: CGFloat(max.intValue * 62 ))
        
        // 提示
        let noticeLabel = setupLabel(font: 16)
        noticeLabel.text = "请输入您队友的手机号，我我们将对您与您的队友绑定报名"
        noticeLabel.numberOfLines = 0
        noticeLabel.frame = CGRect(x: 20, y: 20, width: Constant.screenW-40, height: 60)
        backScrollView.addSubview(noticeLabel)
    
        for index in 1...max.intValue {
            
            let y = (index - 1) * 62 + 90

            let need = index<=min.intValue
            
            let field = setupTextField(tintColor: .black, textColor: .black, backgroundColor: .white, keyboardType: .default, font: 17, need: need)
            field.frame = CGRect(x: 20, y: Int(y), width: Int(Constant.screenW - 40), height: 42)
            fieldArr.adding(field)
            backScrollView.addSubview(field)
        }
        
    }
    
    @objc func btnClick() {
        
    }
    
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }
    
    
    func setupTextField(tintColor: UIColor, textColor: UIColor, backgroundColor: UIColor, keyboardType: UIKeyboardType, font: CGFloat, need: Bool) -> UITextField {
        
        let textField = LoginOrRegisterField()
        textField.tintColor         = tintColor
        if need {
            textField.placeholder       = "请输入队友的手机号（必填）"
        } else {
            textField.placeholder       = "请输入队友的手机号"
        }
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [
            NSAttributedStringKey.foregroundColor : Constant.placeholderColor,
            NSAttributedStringKey.font: Constant.placeholderFont
            ])
        textField.keyboardType      = keyboardType
        textField.textColor         = textColor
        textField.backgroundColor   = backgroundColor
        textField.font              = UIFont.systemFont(ofSize: font)
        textField.layer.cornerRadius = 21
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 5
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 0, height: 5)
        
//        textField.delegate = self
        textField.inputAccessoryView = singleKeyBoard
        return textField
    }

}
