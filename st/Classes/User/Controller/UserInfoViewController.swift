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
import SDWebImage

class UserInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SingleKeyBoardDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    // 性别
    weak var sexField: UITextField!
    // 选中的city id
    var cityId: String!
    // 选中的school id
    var schoolId: String!
    // 选中的系
    var seriesId: String!
    // 上传的头像类型
    var mimeType: String!
    // 选中的性别
    var sexId: String!
    
    fileprivate lazy var textFields: [UITextField] = [self.nameField, self.sexField, self.cityField, self.schoolField, self.seriesField]
    
    // 省数据
    var cityData: NSDictionary!
    // 所有学校数据
    var allSchoolData: [NSDictionary]!
    // 当前省份学校数据
    var citySchoolData: [NSDictionary]!
    // 当前学校系数据
    var seriesData: [[String: Any]]!
    // 性别数据
    var sexData: [String: String] = ["0":"男", "1":"女"]
    
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
    
    // 性别
    lazy var sexPickerView = {() -> UIPickerView in
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
        self.navigationItem.title = "个人信息"
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
            make.height.equalTo(70)
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
            make.top.equalTo(schoolView).offset(5)
        }
        
        // 学校field
        let schoolField = setupField(placeholder: "学校", inputView: self.schoolPickerView)
        schoolField.text = ((AccountTool.getUser()?.school_name)! as String)
        schoolView.addSubview(schoolField)
        self.schoolField = schoolField
        schoolField.snp.makeConstraints { (make) in
            make.top.equalTo(schoolLabel.snp.bottom).offset(5)
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
            make.top.equalTo(cityView).offset(5)
        }
        
        // 省市field
        let cityField = setupField(placeholder: "省份", inputView: self.cityPickerView)
        cityField.text = ((AccountTool.getUser()?.province_name)! as String)
        cityView.addSubview(cityField)
        self.cityField = cityField
        cityField.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(5)
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
            make.top.equalTo(seriesView).offset(5)
        }
        
        // 系field
        let seriesField = setupField(placeholder: "系院", inputView: seriesPickerView)
        seriesField.text = "\(AccountTool.getUser()?.series_name ?? "")"
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
            make.top.equalTo(seriesLabel.snp.bottom).offset(5)
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
        
        // 性别
        let sexView = setupBackView()
        view.addSubview(sexView)
        sexView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolView)
            make.bottom.equalTo(cityView.snp.top)
        }
        
        // 性别label
        let sexLabel = UILabel()
        sexLabel.text = "性别:"
        sexLabel.textColor = UIColor.black
        sexLabel.font = UIFont.systemFont(ofSize: 16)
        sexView.addSubview(sexLabel)
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexView).offset(30)
            make.top.equalTo(sexView).offset(5)
        }
        
        // 性别field
        let sexField = setupField(placeholder: "性别", inputView: self.sexPickerView)
        sexField.text = "\(AccountTool.getUser()?.sex_name ?? "")"
        sexView.addSubview(sexField)
        self.sexField = sexField
        sexField.snp.makeConstraints { (make) in
            make.top.equalTo(sexLabel.snp.bottom).offset(5)
            make.height.equalTo(32)
            make.left.equalTo(sexView).offset(30)
            make.right.equalTo(sexView).offset(-30)
        }
        
        let sexHen = setupHenView()
        sexView.addSubview(sexHen)
        sexHen.snp.makeConstraints { (make) in
            make.left.equalTo(sexView).offset(30)
            make.right.equalTo(sexView)
            make.height.equalTo(1)
            make.bottom.equalTo(sexView)
        }
        
        // 名称
        let nameView = setupBackView()
        view.addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolView)
            make.bottom.equalTo(sexView.snp.top)
        }
        
        // 姓名text
        let nameLabel = UILabel()
        nameLabel.text = "姓名:"
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameView).offset(30)
            make.top.equalTo(nameView).offset(5)
        }
        
        // 姓名field
        let namefield = ConfirmField()
        namefield.placeholder = "姓名"
        namefield.textColor = UIColor.black
        namefield.text = ((AccountTool.getUser()?.name)! as String)
        namefield.font = UIFont.systemFont(ofSize: 18)
        namefield.inputAccessoryView = singleKeyBoard
        nameView.addSubview(namefield)
        self.nameField = namefield
        namefield.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
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
        let iconImageView = UIImageView()
        let url = Api.host + "/" + ((AccountTool.getUser()?.head_pic)! as String )
        iconImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "user_placeholder"))
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.masksToBounds = true
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.width.equalTo(100)
            make.bottom.equalTo(nameView.snp.top).offset(-15)
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
        
        // 修改头像按钮
        let headBtn = UIButton()
        headBtn.backgroundColor = UIColor.clear
        headBtn.addTarget(self, action: #selector(headBtnClick), for: .touchUpInside)
        view.addSubview(headBtn)
        headBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(iconImageView)
        }
        
        // 初始化信息
        seriesId = "\(AccountTool.getUser()?.series ?? "")"
        schoolId = "\(AccountTool.getUser()?.school ?? "")"
        cityId = "\(AccountTool.getUser()?.province ?? "")"
        sexId = "\(AccountTool.getUser()?.sex ?? "")"
    }
    
    @objc func headBtnClick() {
        SVProgressHUD.show(withStatus: "正在打开相册")
        localPhoto()
    }
    
    // 打开本地相册
    func localPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show(withStatus: "正在加载图片")
        let type = info[UIImagePickerControllerMediaType] as! String
        if type == "public.image" {
            let image: UIImage! = (info[UIImagePickerControllerOriginalImage] as! UIImage)
            var data:NSData!
            if UIImagePNGRepresentation(image) == nil {
                data = (UIImageJPEGRepresentation(image, 1.0)! as NSData)
                mimeType = "image/jpeg"
            } else {
                data = (UIImagePNGRepresentation(image)! as NSData)
                mimeType = "image/png"
            }
            
            if  data.length > 3145728 {
                SVProgressHUD.showError(withStatus: "图片应小于3M")
                return
            }
            
            postHeadImage(data: data)
        }
        
    }
    
    // 上传照片
    func postHeadImage(data: NSData) {
        
        SVProgressHUD.show(withStatus: "正在上传")
        let params = NSMutableDictionary()
        params["method"] = Api.uploadHeadPic
        Networking.share().post(Api.host, parameters: params, constructingBodyWith: { (formData) in
            let fileName = NSUUID().uuidString + "." + self.mimeType
            formData.appendPart(withFileData: data as Data, name: "file", fileName: fileName, mimeType: self.mimeType)
        }, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            print(response)
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
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
        } else if pickerView == self.sexPickerView {
            return self.sexData.count
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
            
        } else if pickerView == self.sexPickerView {
            
            return self.sexData[String(row)]
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
        } else if pickerView == self.sexPickerView {
            self.sexField.text = self.sexData[String(row)]
            self.sexId = String(row)
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
        params["series_id"] = self.seriesId
        params["name"] = self.nameField.text
        params["sex"] = self.sexId
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                // 认证成功， 记录认证信息
                AccountTool.saveAuth()
                SVProgressHUD.showSuccess(withStatus: "修改信息成功")
                // 更新信息
                AccountTool.getUserInfo()
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
