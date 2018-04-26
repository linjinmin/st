//
//  TeamDetailViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/24.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class SocietyDetailViewController: UIViewController{

    // 社团id
    var tissue_id: NSString!
    // 社团头像
    weak var imageView: UIImageView!
    // 社团名称
    weak var nameLabel: UILabel!
    // 成员人数
    weak var member: UIButton!
    // 简介
    weak var describeLabel: UILabel!
    // 照片墙label
    weak var photoLabel: UILabel!
//    weak var photos: NSArray!
    // 照片墙scrollview
    weak var scrollView: UIScrollView!
    // 社团活动activeView
    weak var activeTableView: UITableView!
    // 活动数组
    var activeArr: [NSDictionary]!
    // 社团活动label
    weak var activeLabel: UILabel!
    // 社团label
    weak var shetuanLabel: UILabel!
    // 活动view
    weak var activeView: UIView!
    
    // 照片
    lazy var images = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    
    // societydetail model
    var societyDetail: SocietyDetail! {
        
        didSet{
            
            nameLabel.text = "\(societyDetail.tissue_name ?? "")"
            member.setTitle("成员：\(societyDetail.member_count ?? "")", for: .normal)
            describeLabel.text = "    \(societyDetail.tissue_describe ?? "")"
            activeArr = (societyDetail.active as! [NSDictionary])

            // 照片墙
            if societyDetail.photos.count > 0 {

                let width = societyDetail.photos.count * 100
                scrollView.contentSize = CGSize(width: width, height: 80)
                var count = 0;
                for item in societyDetail.photos {

                    let item = item as! [String: AnyObject]

                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: count * 100, y: 0, width: 80, height: 80)
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
                    scrollView.addSubview(imageView)
                    count = count + 1
                }
                
                activeLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(shetuanLabel)
                    make.top.equalTo(scrollView.snp.bottom).offset(20)
                }

            } else {
                // 隐藏照片墙
                photoLabel.isHidden = true
                scrollView.isHidden = true
                activeLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(describeLabel.snp.bottom).offset(20)
                    make.left.equalTo(shetuanLabel)
                }
            }
            
            if societyDetail.active.count > 0 {
                
                activeView.snp.makeConstraints { (make) in
                    make.left.equalTo(shetuanLabel)
                    make.height.equalTo(societyDetail.active.count * 125)
                    make.top.equalTo(activeLabel.snp.bottom).offset(10)
                    make.width.equalTo(Constant.screenW - 60)
                }
                
                var count = 0
                
                for item in societyDetail.active {
                    
                    let item = item as! [String : AnyObject]
                    let active = SocietyDetailActive(dict: item)
                    let view = SocietyActiveView()
                    view.frame = CGRect(x: count * 115, y:0, width:Int(Constant.screenW - 60), height: 100)
                    view.active = active
                    let colorIndex = count % 4
                    let leftColor = cellColors[colorIndex]
                    let rightColor = cellColorsAlpha[colorIndex]
                    let gradientColors = [leftColor.cgColor, rightColor.cgColor]
                    let gradientLocations:[NSNumber] = [0.0, 1.0]
                    //创建CAGradientLayer对象并设置参数
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.colors = gradientColors
                    gradientLayer.frame.size.width = Constant.screenW-60
                    gradientLayer.frame.size.height = 100
                    gradientLayer.locations = gradientLocations
                    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                    gradientLayer.type = kCAGradientLayerAxial;
                    view.layer.insertSublayer(gradientLayer, at: 0)
                    view.layer.cornerRadius = 10
                    view.layer.masksToBounds = true
                    activeView.addSubview(view)
                    count = count + 1
                    
                }
                
            }
            
            view.layoutIfNeeded()
        }
        
    }
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = Constant.viewBackgroundColor
        navigationItem.title = "优社团"
        // 初始化
        setup()
        getDetail()
        
        SVProgressHUD.show(withStatus: Constant.loadingTitle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func setup() {
        
        // 大的scrollview
        let backScrollView = UIScrollView()
//        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.backgroundColor = UIColor.clear
        backScrollView.bounces = false
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
        // 社团头像
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        backScrollView.addSubview(imageView)
        self.imageView = imageView
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.top.equalTo(backScrollView).offset(20)
            make.centerX.equalTo(backScrollView)
        }
        
        // 社团名称
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.black
        backScrollView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        
        // 查看人员按钮
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitleColor(Constant.viewColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(btn)
        self.member = btn
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        // 社团简介label
        let shetuanLabel = UILabel()
        shetuanLabel.font = UIFont.systemFont(ofSize: 18)
        shetuanLabel.textColor = UIColor.black
        shetuanLabel.text = "社团简介"
        backScrollView.addSubview(shetuanLabel)
        self.shetuanLabel = shetuanLabel
        shetuanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backScrollView).offset(20)
            make.top.equalTo(member.snp.bottom).offset(20)
        }

        // 简介label
        let describeLabel = UILabel()
        describeLabel.font = UIFont.systemFont(ofSize: 14)
        describeLabel.textColor = UIColor.black
        describeLabel.numberOfLines = 0
        backScrollView.addSubview(describeLabel)
        self.describeLabel = describeLabel
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shetuanLabel)
            make.top.equalTo(shetuanLabel.snp.bottom).offset(5)
            make.right.equalTo(backScrollView).offset(-20)
        }

        // 照片墙label
        let photoLabel = UILabel()
        photoLabel.text = "照片墙"
        photoLabel.font = UIFont.systemFont(ofSize: 18)
        photoLabel.textColor = UIColor.black
        backScrollView.addSubview(photoLabel)
        self.photoLabel = photoLabel
        photoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shetuanLabel)
            make.top.equalTo(describeLabel.snp.bottom).offset(20)
        }

        // 照片墙scrollview
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        backScrollView.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(describeLabel)
            make.top.equalTo(photoLabel.snp.bottom).offset(5)
            make.height.equalTo(80)
            make.width.equalTo(Constant.screenW-40)
        }

        // 社团活动label
        let activeLabel = UILabel()
        activeLabel.text = "社团活动"
        activeLabel.font = UIFont.systemFont(ofSize: 18)
        activeLabel.textColor = UIColor.black
        backScrollView.addSubview(activeLabel)
        self.activeLabel = activeLabel
        
        // 活动view
        let activeView = UIView()
        activeView.backgroundColor = UIColor.clear
        backScrollView.addSubview(activeView)
        self.activeView = activeView
    
    }
    
    // 获取详情
    func getDetail() {
        
        let params = NSMutableDictionary()
        params["tissue_id"] = tissue_id
        params["method"] = Api.tissueDetail
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let societyDetail = SocietyDetail(dict: response["data"].dictionaryObject! as [String : AnyObject])
                
                self.societyDetail = societyDetail
                SVProgressHUD.dismiss()
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }
    
    @objc func btnClick() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        //进入图片全屏展示
        let previewVC = ImagePreviewVC(images: images as! [String], index: index)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }

}
