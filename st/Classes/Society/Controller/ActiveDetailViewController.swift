//
//  ActiveDetailViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/12.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ActiveDetailViewController: UIViewController {

    // 活动id
    var activeId: NSString!
    // 活动名称label
    weak var activeNameLabel: UILabel!
    // 报名状态label
    weak var joinStatusLabel: UILabel!
    // 活动状态
    weak var statusLabel: UILabel!
    // 报名时间
    weak var signTimeLabel: UILabel!
    // 活动开始时间
    weak var activeTimeLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称按钮
    weak var tissueBtn: UIButton!
    // 奖励
    weak var awardLabel: UILabel!
    // 活动详情
    weak var detailLabel: UILabel!
    // 参与人数
    weak var joinLabel: UILabel!
    // 成员scrollview
    weak var memberScrollview: UIScrollView!
    // 照片墙scrollview
    weak var photoScrollview: UIScrollView!
    // 照片强label
    weak var photoLabel: UILabel!
    // 报名btn
    weak var btn: UIButton!
    // 照片
    lazy var images = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    var activeDetail: ActiveDetail! {
        didSet{
            
            activeNameLabel.text = "\(activeDetail.active_name ?? "")"
            joinStatusLabel.text = "\(activeDetail.join_status ?? "")"
            signTimeLabel.text = "报名时间：\(activeDetail.sign_begin ?? "")-\(activeDetail.sign_end ?? "")"
            activeTimeLabel.text = "活动时间：\(activeDetail.active_begin ?? "")-\(activeDetail.active_end ?? "")"
            addressLabel.text = "地点：\(activeDetail.address ?? "暂无")"
            tissueBtn.setTitle("\(activeDetail.tissue_name ?? "")", for: .normal)
            awardLabel.text = "\(activeDetail.award ?? "")"
            detailLabel.text = "活动详情：\(activeDetail.describe ?? "暂无")"
            joinLabel.text = "\(activeDetail.member_join ?? "")/\(activeDetail.member_count ?? "")"
            
            if activeDetail.users.count > 0 {
                let width = activeDetail.users.count * 80
                memberScrollview.contentSize = CGSize(width: width, height: 60)
                
                var count = 0
                // 活动成员
                for item in activeDetail.users {
                    
                    let item = item as! [String: AnyObject]
                    
                    let teamBtn = BomButton(frame: CGRect(x:count * 80, y:0, width:60, height:80))
                    teamBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    teamBtn.setTitle("\(item["name"] as! String)", for: .normal)
                    teamBtn.setTitleColor(UIColor.black, for: .normal)
                    teamBtn.sd_setImage(with: URL(string: item["head_pic"] as! String), for: .normal)
                    teamBtn.sd_setImage(with: URL(string: item["head_pic"] as! String), for: .normal, placeholderImage: UIImage(named: "image_placeholder"))
                    teamBtn.titleLabel?.textAlignment = .center
                    teamBtn.imageView?.frame = CGRect(x: 0, y: 0, width: teamBtn.frame.width, height: teamBtn.frame.width)
                    teamBtn.tag = ((item["id"] as? NSString)?.integerValue)!
                    teamBtn.addTarget(self, action: #selector(userBtnClick(sender:)), for: .touchUpInside)
                    memberScrollview.addSubview(teamBtn)
                    count = count + 1
                }
            }
            
            // 照片墙
            if activeDetail.photo.count > 0 {

                let width = activeDetail.photo.count * 80
                photoScrollview.contentSize = CGSize(width: width, height: 60)
                var count = 0;
                for item in activeDetail.photo {

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
            
            if activeDetail.is_team == "1" {
                btn.setTitle("组队报名", for: .normal)
            }
            
            // 显示右上角二维码按钮
            if activeDetail.is_release == "1" {
                let button = UIButton()
                button.frame = CGRect(x:0 ,y:0, width:20, height:32)
                button.setImage(UIImage(named: "qr"), for: .normal)
                button.addTarget(self, action: #selector(qrBtnClick), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "优社团"
        view.backgroundColor = Constant.viewBackgroundColor
        
        setup()
        getData()
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        // 大的scrollview
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.bounces = false
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
        
        // 添加报名状态label
        let joinStatusLabel = setupLabel(font: 14)
        joinStatusLabel.textColor = UIColor.gray
        scrollView.addSubview(joinStatusLabel)
        self.joinStatusLabel = joinStatusLabel
        joinStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel.snp.right).offset(5)
            make.centerY.equalTo(activeNameLabel)
        }
        
        // 状态label
        let statusLabel = setupLabel(font: 16)
        scrollView.addSubview(statusLabel)
        self.statusLabel = statusLabel
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(activeNameLabel)
            make.left.equalTo(activeNameLabel.snp.right).offset(15)
        }
        
        // 报名时间label
        let signTimeLabel = setupLabel(font: 16)
        scrollView.addSubview(signTimeLabel)
        self.signTimeLabel = signTimeLabel
        signTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(activeNameLabel.snp.bottom).offset(20)
        }
        
        // 活动时间
        let activeTimeLabel = setupLabel(font: 16)
        scrollView.addSubview(activeTimeLabel)
        self.activeTimeLabel = activeTimeLabel
        activeTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(signTimeLabel.snp.bottom).offset(10)
        }
        
        // 地点
        let addressLabel = setupLabel(font: 16)
        scrollView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(activeTimeLabel.snp.bottom).offset(10)
        }
        
        // 社团
        let tissueNameLabel = setupLabel(font: 16)
        tissueNameLabel.text = "发起社团："
        scrollView.addSubview(tissueNameLabel)
        tissueNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
        }
        
        // 社团按钮
        let tissueBtn = UIButton()
        tissueBtn.setTitleColor(Constant.viewColor, for: .normal)
        tissueBtn.backgroundColor = UIColor.clear
        tissueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        tissueBtn.addTarget(self, action: #selector(tissueBtnClick), for: .touchUpInside)
        scrollView.addSubview(tissueBtn)
        self.tissueBtn = tissueBtn
        tissueBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tissueNameLabel)
            make.left.equalTo(tissueNameLabel.snp.right).offset(1)
        }
        
        // 奖励字段
        let awardNoticeLabel = setupLabel(font: 16)
        awardNoticeLabel.text = "活动奖励："
        scrollView.addSubview(awardNoticeLabel)
        awardNoticeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(tissueNameLabel.snp.bottom).offset(10)
        }
        
        let awardLabel = setupLabel(font: 16)
        awardLabel.numberOfLines = 0
        scrollView.addSubview(awardLabel)
        self.awardLabel = awardLabel
        awardLabel.snp.makeConstraints { (make) in
            make.left.equalTo(awardNoticeLabel.snp.right)
            make.top.equalTo(awardNoticeLabel)
        }
        
        // 活动详情
        let detailLabel = setupLabel(font: 16)
        scrollView.addSubview(detailLabel)
        detailLabel.numberOfLines = 0
        self.detailLabel = detailLabel
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.width.equalTo(Constant.screenW - 40)
            make.top.equalTo(awardLabel.snp.bottom).offset(10)
        }
        
        // 活动成员
        let memberLabel = setupLabel(font: 20)
        memberLabel.text = "活动成员"
        scrollView.addSubview(memberLabel)
        memberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(detailLabel.snp.bottom).offset(30)
        }
        
        // 参与人员
        let joinLabel = setupLabel(font: 16)
        scrollView.addSubview(joinLabel)
        self.joinLabel = joinLabel
        joinLabel.snp.makeConstraints { (make) in
            make.center.equalTo(memberLabel)
            make.left.equalTo(scrollView).offset(Constant.screenW - 70)
        }
        
        // 参与人员logo
        let joinImageView = UIImageView(image: UIImage(named:"user"))
        scrollView.addSubview(joinImageView)
        joinImageView.snp.makeConstraints { (make) in
            make.left.equalTo(joinLabel.snp.right).offset(1)
            make.centerY.equalTo(joinLabel)
            make.height.width.equalTo(18)
        }
        
        // 成员scroview
        let memberScrollView = UIScrollView()
        scrollView.addSubview(memberScrollView)
        self.memberScrollview = memberScrollView
        memberScrollView.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.width.equalTo(Constant.screenW - 40)
            make.height.equalTo(90)
            make.top.equalTo(memberLabel.snp.bottom).offset(10)
        }
        
        // 照片label
        let photoLabel = setupLabel(font: 16)
        photoLabel.text = "照片墙"
        scrollView.addSubview(photoLabel)
        self.photoLabel = photoLabel
        photoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.top.equalTo(memberScrollView.snp.bottom).offset(20)
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
        scrollView.addSubview(btn)
        self.btn = btn
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(30)
            make.width.equalTo(Constant.screenW - 60)
            make.top.equalTo(photoScrollView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
    }
    
    func getData() {
        
        let params = NSMutableDictionary()
        params["active_id"] = activeId
        params["method"] = Api.ActiveDetail
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"] == 200 {
                
                let activeDetail = ActiveDetail(dict: response["data"].dictionaryObject! as [String : AnyObject])
                
                self.activeDetail = activeDetail
                SVProgressHUD.dismiss()
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
    }
    
    
    // 报名按钮点击
    @objc func btnClick() {
        
        if activeDetail.is_team.intValue == 1 {
            // 组队报名
            let vc = TeamJoinViewController()
            vc.active_id = activeId
            vc.max = activeDetail.max
            vc.min = activeDetail.min
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @objc func qrBtnClick() {
        
        let vc = QrViewController()
        vc.activeId = activeId
        vc.tissueId = activeDetail.tissue_id
        vc.name = activeDetail.active_name
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tissueBtnClick() {
        
        let vc = SocietyDetailViewController()
        vc.tissue_id = activeDetail.tissue_id!
        navigationController?.pushViewController(vc, animated: true)
        
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
