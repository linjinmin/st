//
//  SuggesViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SuggesViewController: UIViewController, SingleKeyBoardDelegate {
    
    weak var textView: UITextView!
    
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "意见反馈"
        view.backgroundColor = Constant.viewBackgroundColor
        // 初始化
        setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        // label
        let label = UILabel()
        label.text = "对APP有任何意见或建议 欢迎反馈"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        let textView = UITextView()
        let placeholder = UILabel()
        placeholder.text = "意见或帮助描述"
        placeholder.numberOfLines = 0
        placeholder.textColor = UIColor.lightGray
        placeholder.font = UIFont.systemFont(ofSize: 17)
        placeholder.sizeToFit()
        textView.addSubview(placeholder)
        textView.setValue(placeholder, forKey: "_placeholderLabel")
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.contentMode = .top
        textView.inputAccessoryView = singleKeyBoard
        view.addSubview(textView)
        self.textView = textView
        textView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
        
        // 确认按钮
        let confirmBtn = UIButton()
        confirmBtn.setTitle("提交", for: .normal)
        confirmBtn.backgroundColor = Constant.viewColor
        confirmBtn.setTitleColor(Constant.viewBackgroundColor, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        confirmBtn.layer.borderColor = UIColor.white.cgColor
        confirmBtn.layer.shadowOpacity = 0.2
        confirmBtn.layer.shadowColor = UIColor.black.cgColor
        confirmBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        confirmBtn.layer.shadowRadius = 5
        confirmBtn.layer.cornerRadius = 21
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(42)
            make.top.equalTo(textView.snp.bottom).offset(20)
        }
        
    }
    
    
    @objc func confirmBtnClick() {
        
    }
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
    }

}
