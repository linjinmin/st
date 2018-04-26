//
//  ConfirmViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/15.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ConfirmViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SingleKeyBoardDelegate {

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
    // 选中的city id
    var cityId: String!
    // 选中的school id
    var schoolId: String!
    // 选中的系
    var seriesId: String!
    
    fileprivate lazy var textFields: [UITextField] = [self.nameField, self.cityField, self.schoolField, self.seriesField]
    
    // 省数据
    var cityData: NSDictionary!
    // 所有学校数据
    var allSchoolData: [NSDictionary]!
    // 当前省份学校数据
    var citySchoolData: [NSDictionary]!
    // 当前学校系数据
    var seriesData: [[String: Any]]!
    
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
        getSchoolData()
        
    }
    
    // 初始化
    func setup() {
        
        let schoolView = setupBackView()
        view.addSubview(schoolView)
        schoolView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(80)
            make.centerY.equalTo(view).offset(60)
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
            make.right.equalTo(schoolView)
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
            make.right.equalTo(cityView)
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
        let seriesBtn = UIButton()
        seriesBtn.backgroundColor = Constant.viewBackgroundColor
        seriesBtn.setTitle("新增系院", for: .normal)
        seriesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        seriesBtn.setTitleColor(Constant.viewColor, for: .normal)
        seriesBtn.frame = CGRect(x: 0, y: 0, width: 85, height: 42)
        seriesBtn.addTarget(self, action: #selector(addSeriesBtn), for: .touchDown)
        seriesField.rightView = seriesBtn
        seriesField.rightViewMode = .always
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
            make.right.equalTo(seriesView)
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
            make.right.equalTo(nameView)
            make.height.equalTo(1)
            make.bottom.equalTo(nameView)
        }

        // 头像
        let iconImageView = UIImageView(image: UIImage(named: "user_placeholder"))
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.masksToBounds = true
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.width.equalTo(100)
            make.bottom.equalTo(nameView.snp.top).offset(-20)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.cityPickerView {
            return self.cityData.count
        } else if pickerView == self.schoolPickerView {
            return self.citySchoolData.count
        } else if pickerView == self.seriesPickerView {
            if self.seriesData != nil {
                return self.seriesData.count
            } else {
                SVProgressHUD.showError(withStatus: "请先选择学校")
                return 0
            }
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var count = 0
        
        if pickerView == self.cityPickerView {
            
            for dictItem in self.cityData {
                if count == row {
                    return (dictItem.value as! String)
                }
                    
                count += 1
            }
            
        } else if pickerView == self.schoolPickerView {
            
            for dictItem in self.citySchoolData {
                
                if count == row {
                    return (dictItem["school"] as! String)
                }
                
                count += 1
            }
            
        } else if pickerView == self.seriesPickerView {
            
            for dictItem in self.seriesData {
                
                if count == row {
                    return (dictItem["name"] as! String)
                }
                
                count += 1
                
            }
            
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var count = 0
        
        if pickerView == self.cityPickerView {
            for dictItem in self.cityData {
                if count == row {
                    self.cityField.text = (dictItem.value as! String)
                    self.cityId = (dictItem.key as! String)
                    // 修改学校数据
                    self.citySchoolData.removeAll()
                    let key = (dictItem.key as! String)
                    for schoolItem in self.allSchoolData {
                        if (schoolItem["provinceid"] as! String) == key {
                            self.citySchoolData.append(schoolItem)
                        }
                    }
                }
                
                count += 1
            }
        } else if pickerView == self.schoolPickerView {
            for dictItem in self.citySchoolData {
                if count == row {
                    self.schoolField.text = (dictItem["school"] as! String)
                    self.schoolId = (dictItem["id"] as! String)
                    // 自动选择城市
                    for city in self.cityData {
                        if (city.key as! String) == (dictItem["provinceid"] as! String) {
                            self.cityField.text = (city.value as! String)
                            self.cityId = (city.key as! String)
                        }
                    }
                    getSeriesData()
                }
                count += 1
            }
        } else if pickerView == self.seriesPickerView {
            
            for dictItem in self.seriesData {
                if count == row {
                    self.seriesField.text = (dictItem["name"] as! String)
                    self.seriesId = (dictItem["id"] as! String)
                }
                
                count += 1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 获取省数据
    func getCityData() {
        
        let path:String = Bundle.main.path(forResource: "city", ofType: "plist")!
        self.cityData = NSDictionary(contentsOfFile: path)
        
    }
    
    // 获取学校数据
    func getSchoolData() {
        let path:String = Bundle.main.path(forResource: "school", ofType: "plist")!
        self.allSchoolData = NSArray(contentsOfFile: path) as! [NSDictionary]
        self.citySchoolData = self.allSchoolData
    }
    
    // 获取系院数据
    func getSeriesData() {
        
        if self.schoolId == nil {
            SVProgressHUD.showError(withStatus: "请先选择学校")
            return
        }
        
        let params = NSMutableDictionary()
        params["method"] = Api.seriesMethod
        params["school"] = self.schoolId
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                self.seriesData = response["data"].arrayObject as! [[String : Any]]
            } else {
                SVProgressHUD.showError(withStatus: "获取系院数据失败:" + response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    // 认证按钮
    @objc func confirmBtnClick() {
        
        if self.cityId == nil {
            SVProgressHUD.showError(withStatus: "请选择城市")
            return
        }
        
        if self.schoolId == nil {
            SVProgressHUD.showError(withStatus: "请选择学校")
            return
        }
        
        if self.nameField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入姓名")
            return
        }
        
        if self.seriesField.text == "" {
            SVProgressHUD.showError(withStatus: "请选择系院")
            return
        }
        
        let params = NSMutableDictionary()
        params["method"] = Api.editUserInfoMethod
        params["province_id"] = self.cityId
        params["school_id"]  = self.schoolId
        params["series"] = self.seriesId
        params["name"] = self.nameField.text
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                // 认证成功， 记录认证信息
                AccountTool.saveAuth()
                AccountTool.getUserInfo()
                self.navigationController?.dismiss(animated: true, completion: nil)
                SVProgressHUD.showSuccess(withStatus: "认证成功")
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController()
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
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
    
    // 新增系院按钮点击
    @objc func addSeriesBtn() {
        
        if self.schoolId == nil {
            SVProgressHUD.showError(withStatus: "请先选择学校")
            return
        }
        
        let alertController = UIAlertController(title: "提示", message: "请输入您的系院", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "系院"
        }
        
        let confirmAction = UIAlertAction.init(title: "确认", style: .destructive) { (action) in
            let textField = alertController.textFields?.first
            if textField?.text == "" {
                SVProgressHUD.showError(withStatus: "系院不能为空")
                return
            }
            
            let params = NSMutableDictionary()
            params["method"] = Api.addSeriesMethod
            params["school_id"] = self.schoolId
            params["name"] = textField?.text
            Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
                
                let response = JSON(response as Any)
                
                if response["code"].intValue == 200 {
                    SVProgressHUD.showSuccess(withStatus: "新增系院成功")
                    // 重新获取系院数据
                    self.getSeriesData()
                } else {
                    SVProgressHUD.showError(withStatus: response["msg"].stringValue)
                }
                
            }, failure: { (task, error) in
                SVProgressHUD.showError(withStatus: Constant.loadFaildText)
            })
            
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alertController, animated: true, completion: nil)
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
