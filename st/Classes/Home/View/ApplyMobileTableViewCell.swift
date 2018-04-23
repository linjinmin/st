//
//  ApplyMobileTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SwiftyJSON


class ApplyMobileTableViewCell: UITableViewCell {

    // 用户头像
    weak var headPic: UIImageView!
    // 用户昵称
    weak var nameBtn: UIButton!
    // 内容
    weak var content: UILabel!
    // 来源
    weak var originBtn: UIButton!
    // 结果
    weak var result: UILabel!
    // 同意按钮
    weak var agreeBtn: UIButton!
    // 拒绝按钮
    weak var refuseBtn: UIButton!
    
    var apply: ApplyMobile! {
        didSet {
            
            headPic.sd_setImage(with: URL(string: apply.head_pic as String), placeholderImage: UIImage(named: "image_placeholder"))
            nameBtn.setTitle("\(apply.name ?? "")", for: .normal)
            content.text = "\(apply.msg ?? "")"
            originBtn.setTitle("\(apply.active ?? "")", for: .normal)
            
            
            
            if apply.status == "0" {
                result.isHidden = true
            } else if apply.status == "1" {

                result.text = "已同意"
                agreeBtn.isHidden = true
                refuseBtn.isHidden = true

            } else if apply.status == "2" {

                result.text = "已忽略"
                agreeBtn.isHidden = true
                refuseBtn.isHidden = true
            }
        }
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 1
            super.frame = newFrame
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // 设置用户头像
        let headPic = UIImageView()
        headPic.layer.masksToBounds = true
        headPic.layer.cornerRadius = 30
        contentView.addSubview(headPic)
        self.headPic = headPic
        headPic.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.height.width.equalTo(60)
        }
        
        // 用户昵称
        let nameBtn = UIButton()
        nameBtn.backgroundColor = .clear
        nameBtn.setTitleColor(Constant.viewColor, for: .normal)
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        nameBtn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        contentView.addSubview(nameBtn)
        self.nameBtn = nameBtn
        nameBtn.snp.makeConstraints { (make) in
            make.top.equalTo(headPic)
            make.left.equalTo(headPic.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        // 内容
        let content = setupLabel(14)
        contentView.addSubview(content)
        self.content = content
        content.snp.makeConstraints { (make) in
            make.centerY.equalTo(headPic)
            make.left.equalTo(nameBtn)
        }
        
        let originLabel = setupLabel(14)
        originLabel.text = "来源："
        originLabel.textColor = UIColor.lightGray
        contentView.addSubview(originLabel)
        originLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(headPic)
            make.left.equalTo(nameBtn)
            make.height.equalTo(17)
        }
        
        // 来源
        let originBtn = UIButton()
        originBtn.backgroundColor = .clear
        originBtn.setTitleColor(Constant.viewColor, for: .normal)
        originBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        originBtn.addTarget(self, action: #selector(originBtnClick), for: .touchUpInside)
        contentView.addSubview(originBtn)
        self.originBtn = originBtn
        originBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(headPic)
            make.left.equalTo(originLabel.snp.right)
            make.height.equalTo(17)
        }
        
        // 忽略按钮
        let refuseBtn = UIButton()
        refuseBtn.backgroundColor = .white
        refuseBtn.setTitle("忽略", for: .normal)
        refuseBtn.setTitleColor(Constant.viewColor, for: .normal)
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        refuseBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        refuseBtn.layer.borderWidth = 1
        refuseBtn.layer.borderColor = Constant.viewColor.cgColor
        refuseBtn.layer.cornerRadius = 5
        contentView.addSubview(refuseBtn)
        self.refuseBtn = refuseBtn
        refuseBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(contentView.snp.centerY).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }
        
        // 同意按钮
        let agreeBtn = UIButton()
        agreeBtn.backgroundColor = Constant.viewColor
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.setTitleColor(.white, for: .normal)
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        agreeBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        agreeBtn.layer.cornerRadius = 5
        contentView.addSubview(agreeBtn)
        self.agreeBtn = agreeBtn
        agreeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView.snp.centerY).offset(-5)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }
        
        let result = setupLabel(16)
        result.textColor = UIColor.lightGray
        contentView.addSubview(result)
        self.result = result
        result.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        let henBottom = UIView()
        henBottom.backgroundColor = Constant.littleGray
        contentView.addSubview(henBottom)
        henBottom.snp.makeConstraints { (make) in
            make.left.equalTo(headPic)
            make.right.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        
    }
    
    @objc func agreeBtnClick() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.applyMobileCheck
        params["user_id_two"] = apply.user_id_two
        params["status"] = 1
        params["apply_id"] = apply.id
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                self.agreeBtn.isHidden = true
                self.refuseBtn.isHidden = true
                self.result.text = "已同意"
                self.result.isHidden = false
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func refuseBtnClick() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.applyMobileCheck
        params["user_id_two"] = apply.user_id_two
        params["status"] = 2
        params["apply_id"] = apply.id
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                self.agreeBtn.isHidden = true
                self.refuseBtn.isHidden = true
                self.result.text = "已忽略"
                self.result.isHidden = false
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func nameBtnClick() {
        let vc = UserShowViewController()
        vc.user_id = apply.user_id_two
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        
        var object = self.next
        while !(object?.isKind(of: UIViewController.classForCoder()))! && object != nil {
            object = object?.next
        }
        
        let superController = object as! UIViewController
        superController.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func originBtnClick() {
        let vc = ActiveDetailViewController()
        vc.activeId = apply.active_id
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        
        var object = self.next
        while !(object?.isKind(of: UIViewController.classForCoder()))! && object != nil {
            object = object?.next
        }
        
        let superController = object as! UIViewController
        superController.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabel(_ font: CGFloat) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }

}
