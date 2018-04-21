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

class SocietyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 社团id
    var tissue_id: NSString!
    // 社团头像
    weak var imageView: UIImageView!
    // 社团名称
    weak var nameLabel: UILabel!
    // 成员人数
    weak var memberLabel: UILabel!
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
    
    // 照片
    lazy var images = {() -> NSMutableArray in
        let arr = NSMutableArray()
        return arr
    }()
    
    
    // societydetail model
    var societyDetail: SocietyDetail! {
        
        didSet{
            
            nameLabel.text = "\(societyDetail.tissue_name ?? "")"
            memberLabel.text = "成员：\(societyDetail.member_count ?? "")"
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
            
            activeTableView.reloadData()
            
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
    }
    
    func setup() {
        
        // 大的scrollview
        let backScrollView = UIScrollView()
//        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.backgroundColor = UIColor.clear
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
        

        // 成员人数
        let memberLabel = UILabel()
        memberLabel.font = UIFont.systemFont(ofSize: 16)
        memberLabel.textColor = Constant.viewColor
        backScrollView.addSubview(memberLabel)
        self.memberLabel = memberLabel
        memberLabel.snp.makeConstraints { (make) in
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
            make.top.equalTo(memberLabel.snp.bottom).offset(20)
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
//        activeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(shetuanLabel)
//            make.top.equalTo(scrollView.snp.bottom).offset(20)
//        }

        // 设置tableView
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        backScrollView.addSubview(tableView)
        activeTableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(describeLabel)
            make.height.equalTo(350)
            make.width.equalTo(Constant.screenW-40)
            make.top.equalTo(activeLabel.snp.bottom).offset(5)
            make.bottom.equalTo(backScrollView)
        }
    }
    
    // 获取详情
    func getDetail() {
        
//        SVProgressHUD.showError(withStatus: Constant.loadingTitle)
        
        let params = NSMutableDictionary()
        params["tissue_id"] = tissue_id
        params["method"] = Api.tissueDetail
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                
                let societyDetail = SocietyDetail(dict: response["data"].dictionaryObject! as [String : AnyObject])
                
                self.societyDetail = societyDetail
                
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SocietyDetailActiveTableViewCell()
        let cellColorIndex = indexPath.row % 4
        let leftColor = cellColors[cellColorIndex]
        let rightColor = cellColorsAlpha[cellColorIndex]
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame.size.width = Constant.screenW - 40
        gradientLayer.frame.size.height = 180
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        let active = SocietyDetailActive(dict: activeArr[indexPath.row] as! [String : AnyObject])
        cell.active = active
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeArr != nil {
            return activeArr.count
        }
        
        return 0
    }

    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        //进入图片全屏展示
        let previewVC = ImagePreviewVC(images: images as! [String], index: index)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }

}
