//
//  UserInfoViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/19.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class UserInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SingleKeyBoardDelegate {
    
    // 头像
    weak var iconImageView: UIImageView!
    // 姓名
    weak var nameField: UITextField!
    // 省份
    weak var cityField: UITextField!
    // 学校
    weak var schoolField: UITextField!
    // 系院
    weak var seriesField: UITextField!
    
    fileprivate lazy var textFields: [UITextField] = [self.nameField, self.cityField, self.schoolField, self.seriesField]
    
    
    // 省数据
    var cityData: NSMutableDictionary!
    
    // 省市pickerview
    lazy var cityPickerView = {() -> UIPickerView in
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // 学校
    lazy var schoolPickerView = {() -> UIPickerView in
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // field 辅助
    lazy var singleKeyBoard = {() -> SingleKeyBoard in
        let keyBoard = SingleKeyBoard.keyBoardTool()
        keyBoard.singleDelegate = self
        return keyBoard
    }()
    
    // 系
    lazy var seriesPickerView = {() -> UIPickerView in
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showError(withStatus: "请先认证")
        self.navigationItem.title = "认证信息"
        view.backgroundColor = Constant.viewBackgroundColor
        // 初始化
        setup()
        setupKeyBoardNotification()
        // 获取data数据
        getCityData()
        
    }
    
    // 初始化
    func setup() {
        
        
        let schoolView = setupBackView()
        view.addSubview(schoolView)
        schoolView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(80)
            make.centerY.equalTo(view).offset(75)
        }
        
        // 学校text
        let schoolLabel = UILabel()
        schoolLabel.text = "学校:"
        schoolLabel.textColor = UIColor.black
        schoolLabel.font = UIFont.systemFont(ofSize: 16)
        schoolView.addSubview(schoolLabel)
        schoolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(schoolView).offset(30)
            make.top.equalTo(schoolView).offset(10)
        }
        
        // 学校field
        let schoolField = setupField(placeholder: "学校", inputView: self.schoolPickerView)
        schoolView.addSubview(schoolField)
        self.schoolField = schoolField
        schoolField.snp.makeConstraints { (make) in
            make.top.equalTo(schoolLabel.snp.bottom).offset(10)
            make.height.equalTo(32)
            make.left.equalTo(schoolView).offset(30)
            make.right.equalTo(schoolView).offset(-30)
        }
        
        let schoolHen = setupHenView()
        schoolView.addSubview(schoolHen)
        schoolHen.snp.makeConstraints { (make) in
            make.left.equalTo(schoolView).offset(30)
            make.right.equalTo(schoolView).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(schoolView)
        }
        
        
        let cityView = setupBackView()
        view.addSubview(cityView)
        cityView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolView)
            make.bottom.equalTo(schoolView.snp.top)
        }
        
        // 省市text
        let cityLabel = UILabel()
        cityLabel.text = "省:"
        cityLabel.textColor = UIColor.black
        cityLabel.font = UIFont.systemFont(ofSize: 16)
        cityView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cityView).offset(30)
            make.top.equalTo(cityView).offset(10)
        }
        
        // 省市field
        let cityField = setupField(placeholder: "省份", inputView: self.cityPickerView)
        cityView.addSubview(cityField)
        self.cityField = cityField
        cityField.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.height.equalTo(32)
            make.left.equalTo(cityView).offset(30)
            make.right.equalTo(cityView).offset(-30)
        }
        
        let cityHen = setupHenView()
        cityView.addSubview(cityHen)
        cityHen.snp.makeConstraints { (make) in
            make.left.equalTo(cityView).offset(30)
            make.right.equalTo(cityView).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(cityView)
        }
        
        let seriesView = setupBackView()
        view.addSubview(seriesView)
        seriesView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolView)
            make.top.equalTo(schoolView.snp.bottom)
        }
        
        // 系text
        let seriesLabel = UILabel()
        seriesLabel.text = "系院:"
        seriesLabel.textColor = UIColor.black
        seriesLabel.font = UIFont.systemFont(ofSize: 16)
        seriesView.addSubview(seriesLabel)
        seriesLabel.snp.makeConstraints { (make) in
            make.left.equalTo(seriesView).offset(30)
            make.top.equalTo(seriesView).offset(10)
        }
        
        // 系field
        let seriesField = setupField(placeholder: "系院", inputView: seriesPickerView)
        seriesView.addSubview(seriesField)
        self.seriesField = seriesField
        seriesField.snp.makeConstraints { (make) in
            make.top.equalTo(seriesLabel.snp.bottom).offset(10)
            make.height.equalTo(32)
            make.left.equalTo(seriesView).offset(30)
            make.right.equalTo(seriesView).offset(-30)
        }
        
        let seriesHen = setupHenView()
        seriesView.addSubview(seriesHen)
        seriesHen.snp.makeConstraints { (make) in
            make.left.equalTo(seriesView).offset(30)
            make.right.equalTo(seriesView).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(seriesView)
        }
        
        // 名称
        let nameView = setupBackView()
        view.addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolView)
            make.bottom.equalTo(cityView.snp.top)
        }
        
        // 姓名text
        let nameLabel = UILabel()
        nameLabel.text = "姓名:"
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameView).offset(30)
            make.top.equalTo(nameView).offset(10)
        }
        
        // 姓名field
        let namefield = ConfirmField()
        namefield.placeholder = "姓名"
        namefield.textColor = UIColor.black
        namefield.font = UIFont.systemFont(ofSize: 18)
        namefield.inputAccessoryView = singleKeyBoard
        nameView.addSubview(namefield)
        self.nameField = namefield
        namefield.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(32)
            make.left.equalTo(nameView).offset(30)
            make.right.equalTo(nameView).offset(-30)
        }
        
        let nameHen = setupHenView()
        nameView.addSubview(nameHen)
        nameHen.snp.makeConstraints { (make) in
            make.left.equalTo(nameView).offset(30)
            make.right.equalTo(nameView).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(nameView)
        }
        
        // 头像
        let iconImageView = UIImageView(image: UIImage(named: "user"))
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.masksToBounds = true
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.width.equalTo(100)
            make.bottom.equalTo(nameView.snp.top).offset(-30)
        }
        
        // 确认按钮
        let confirmBtn = UIButton()
        confirmBtn.setTitle("确认", for: .normal)
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
            make.top.equalTo(seriesView.snp.bottom).offset(30)
        }
        
    }
    
    @objc func confirmBtnClick() {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 获取省数据
    func getCityData() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.provinceMethod
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            //            self.cityData = response["data"].dictionaryValue as! NSMutableDictionary
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: "获取省信息失败")
        }
        
    }
    
    func setupHenView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }
    
    func setupBackView() -> UIView {
        let view = UIView()
        view.backgroundColor = Constant.viewBackgroundColor
        return view
    }
    
    
    func keyBoardDidClickDoneButton(tool: SingleKeyBoard) {
        view.endEditing(true)
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
                let textY = (textField.superview?.frame.maxY)! + 180
                if textY > keyboardY! {
                    view.transform = CGAffineTransform(translationX: 0, y: keyboardY! - textY)
                }
            }
        }
    }
    
    func setupField(placeholder: String, inputView: UIPickerView) -> ConfirmField {
        let field = ConfirmField()
        field.placeholder = placeholder
        field.inputView = inputView
        field.textColor = UIColor.black
        field.font = UIFont.systemFont(ofSize: 18)
        field.inputAccessoryView = singleKeyBoard
        //        field.layer.cornerRadius = 21
        //        field.layer.borderWidth = 1
        //        field.layer.borderColor = Constant.placeholderColor.cgColor
        return field
    }
}
