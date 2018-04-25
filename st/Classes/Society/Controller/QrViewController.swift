//
//  QrViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class QrViewController: UIViewController {

    // 活动id
    weak var activeId: NSString!
    // 社团id
    weak var tissueId: NSString!
    // 活动名称
    weak var name: NSString!
    
    // 二维码图片
    weak var qrImageView: UIImageView!
    // 活动label
    weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.viewBackgroundColor
        
        navigationItem.title = "二维码"
        
        setup()
        getData()
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func setup() {
        
        // qr图像
        let qrImageView = UIImageView()
        view.addSubview(qrImageView)
        self.qrImageView = qrImageView
        qrImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(50)
            make.height.width.equalTo(250)
        }
        
        // 活动label
        let nameLabel = setupLabel(font: 20)
        nameLabel.text = "\(name ?? "")"
        view.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(qrImageView)
            make.top.equalTo(qrImageView.snp.bottom).offset(10)
        }
        
        // 提示label
        let noticeLabel = setupLabel(font: 16)
        noticeLabel.text = "扫一扫二维码，签到活动"
        view.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(nameLabel)
        }
        
        // 查看人员按钮
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("查看签到人员列表", for: .normal)
        btn.setTitleColor(Constant.viewColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(nameLabel)
            make.top.equalTo(noticeLabel.snp.bottom).offset(1)
        }
        
    }
    
    
    func getData() {
        
        let params = NSMutableDictionary()
        params["method"] = Api.getQrCode
        params["tissue_id"] = tissueId
        params["active_id"] = activeId
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let qrString = response["data"].stringValue
                let qrImage = self.createQRForString(qrString: qrString, qrImageName: "logo")
                
                if qrImage == nil {
                    SVProgressHUD.showError(withStatus: "二维码生成失败，请联系开发人员")
                } else {
                    self.qrImageView.image = qrImage
                    SVProgressHUD.dismiss()
                }
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func btnClick() {
        
    }

    func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString{
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            //创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
            
            // 中间一般放logo
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
                
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        
        return nil
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }

}
