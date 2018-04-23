//
//  TemplateActiveDetailViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class TemplateActiveDetailViewController: UIViewController {

    // 活动id
    var activeId: NSString!
    // 活动名称label
    weak var activeNameLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称按钮
//    weak var tissueBtn: UIButton!
    // 活动详情
    weak var detailLabel: UILabel!
    // 照片墙scrollview
    weak var photoScrollview: UIScrollView!
    // 照片强label
    weak var photoLabel: UILabel!
    // 照片
    lazy var images = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    var templateActive: TemplateActive! {
        didSet{
            
            activeNameLabel.text = "\(templateActive.name ?? "")"
            addressLabel.text = "地点：\(templateActive.address ?? "暂无")"
//            tissueBtn.setTitle("\(templateActive.tissue_name ?? "")", for: .normal)
            //            tissueNameLabel.text = "社团：\(activeDetail.tissue_name ?? "")"
            detailLabel.text = "活动详情：\(templateActive.describe ?? "暂无")"
            // 照片墙
            if templateActive.photo.count > 0 {
                
                let width = templateActive.photo.count * 80
                photoScrollview.contentSize = CGSize(width: width, height: 60)
                var count = 0;
                for item in templateActive.photo {
                    
                    let item = item as! [String: AnyObject]
                    
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: count * 80, y: 0, width: 60, height: 60)
                    imageView.layer.cornerRadius = 10
                    imageView.layer.masksToBounds = true
                    imageView.isUserInteractionEnabled = true
                    imageView.sd_setImage(with: URL(string: item["detail"] as! String), placeholderImage: UIImage(named: "image_placeholder"))
                    imageView.tag = count
                    //                    imageView.contentMode = .scaleAspectFill
                    //                    imageView.clipsToBounds = true
                    images.add(item["detail"] as! String)
                    //添加单击监听
                    let tapSingle=UITapGestureRecognizer(target:self,
                                                         action:#selector(imageViewTap(_:)))
                    tapSingle.numberOfTapsRequired = 1
                    tapSingle.numberOfTouchesRequired = 1
                    imageView.addGestureRecognizer(tapSingle)
                    
                    
                    photoScrollview.addSubview(imageView)
                    count = count + 1
                }
                
            } else {
                // 隐藏照片墙
                photoLabel.isHidden = true
                photoScrollview.isHidden = true
            }
            
            view.layoutIfNeeded()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "优社团"
        view.backgroundColor = Constant.viewBackgroundColor
        
        setup()
        getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        // 大的scrollview
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
        // 活动名称
        let activeNameLabel = setupLabel(font: 22)
        scrollView.addSubview(activeNameLabel)
        self.activeNameLabel = activeNameLabel
        activeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(20)
            make.top.equalTo(scrollView).offset(20)
        }
        
        // 地点
        let addressLabel = setupLabel(font: 16)
        scrollView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(activeNameLabel.snp.bottom).offset(20)
        }
        
//        // 社团
//        let tissueNameLabel = setupLabel(font: 16)
//        tissueNameLabel.text = "发起社团："
//        scrollView.addSubview(tissueNameLabel)
//        tissueNameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(activeNameLabel)
//            make.top.equalTo(addressLabel.snp.bottom).offset(10)
//        }
        
        // 社团按钮
//        let tissueBtn = UIButton()
//        tissueBtn.setTitleColor(Constant.viewColor, for: .normal)
//        tissueBtn.backgroundColor = UIColor.clear
//        tissueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        tissueBtn.addTarget(self, action: #selector(tissueBtnClick), for: .touchUpInside)
//        scrollView.addSubview(tissueBtn)
//        self.tissueBtn = tissueBtn
//        tissueBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(tissueNameLabel)
//            make.left.equalTo(tissueNameLabel.snp.right).offset(1)
//        }
        
        // 活动详情
        let detailLabel = setupLabel(font: 16)
        scrollView.addSubview(detailLabel)
        detailLabel.numberOfLines = 0
        self.detailLabel = detailLabel
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.width.equalTo(Constant.screenW - 40)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
        }
        
        // 照片label
        let photoLabel = setupLabel(font: 16)
        photoLabel.text = "照片墙"
        scrollView.addSubview(photoLabel)
        self.photoLabel = photoLabel
        photoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(detailLabel.snp.bottom).offset(20)
        }
        
        // 照片墙
        let photoScrollView = UIScrollView()
        photoScrollView.showsHorizontalScrollIndicator = false
        photoScrollView.backgroundColor = UIColor.clear
        scrollView.addSubview(photoScrollView)
        self.photoScrollview = photoScrollView
        photoScrollView.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(photoLabel.snp.bottom).offset(10)
            make.height.equalTo(80)
            make.width.equalTo(Constant.screenW-40)
        }
        
    }
    
    func getData() {
        
        let params = NSMutableDictionary()
        params["active_id"] = activeId
        params["method"] = Api.activeTemplate
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"] == 200 {
                
                let templateActive = TemplateActive(dict: response["data"].dictionaryObject! as [String : AnyObject])
                
                self.templateActive = templateActive
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func userBtnClick(sender: UIButton) {
        
        let user_id = sender.tag
        
        let vc = UserShowViewController()
        vc.user_id = ((user_id as NSNumber).stringValue as NSString)
        vc.active_id = activeId
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }
    
    
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        //进入图片全屏展示
        let previewVC = ImagePreviewVC(images: images as! [String], index: index)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    

}
