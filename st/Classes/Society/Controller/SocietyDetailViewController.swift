//
//  TeamDetailViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/24.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 社团头像
    weak var imageView: UIImageView!
    // 社团名称
    weak var nameLabel: UILabel!
    // 成员人数
    weak var memberLabel: UILabel!
    // 简介
    weak var describeLabel: UILabel!
    // 照片墙
    weak var photos: NSArray!
    // 照片墙scrollview
    weak var scrollView: UIScrollView!
    // 社团活动activeView
    weak var activeTableView: UITableView!
    // 社团活动
//    weak var active: []!
    
    // cellview的背景颜色 4色循环
    fileprivate lazy var cellColors: [UIColor] = [Constant.viewColor, UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 1), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 1)]
    // cellview的背景颜色， 透明度, 4色循环
    fileprivate lazy var cellColorsAlpha: [UIColor] = [ UIColor(red:87/255, green:113/255, blue:250/255, alpha:0.8), UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 0.8), UIColor(red: 255/255, green: 184/255, blue: 100/255, alpha: 0.8), UIColor(red: 255/255, green: 133/255, blue: 129/255, alpha: 0.8)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 初始化
        setup()
    }
    
    func setup() {
        
        // 社团头像
        let imageView = UIImageView()
        view.addSubview(imageView)
        self.imageView = imageView
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
            make.height.width.equalTo(100)
        }
        
        // 社团名称
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.black
        view.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        
        // 成员人数
        let memberLabel = UILabel()
        memberLabel.font = UIFont.systemFont(ofSize: 16)
        memberLabel.textColor = Constant.viewColor
        view.addSubview(memberLabel)
        self.memberLabel = memberLabel
        memberLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        
        // 社团简介label
        let shetuanLabel = UILabel()
        shetuanLabel.font = UIFont.systemFont(ofSize: 18)
        shetuanLabel.textColor = UIColor.black
        shetuanLabel.text = "社团简介"
        view.addSubview(shetuanLabel)
        shetuanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(memberLabel.snp.bottom).offset(20)
        }
        
        // 简介label
        let describeLabel = UILabel()
        describeLabel.font = UIFont.systemFont(ofSize: 16)
        describeLabel.textColor = UIColor.black
        describeLabel.numberOfLines = 0
        view.addSubview(describeLabel)
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shetuanLabel)
            make.top.equalTo(shetuanLabel.snp.bottom).offset(5)
            make.right.equalTo(view).offset(-20)
        }
        
        // 照片墙label
        let photoLabel = UILabel()
        photoLabel.text = "照片墙"
        photoLabel.font = UIFont.systemFont(ofSize: 18)
        photoLabel.textColor = UIColor.black
        view.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shetuanLabel)
            make.top.equalTo(describeLabel.snp.bottom).offset(20)
        }
        
        // 照片墙scrollview
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(describeLabel)
            make.top.equalTo(photoLabel.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        // 社团活动label
        let activeLabel = UILabel()
        activeLabel.text = "社团活动"
        activeLabel.font = UIFont.systemFont(ofSize: 18)
        activeLabel.textColor = UIColor.black
        view.addSubview(activeLabel)
        activeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shetuanLabel)
            make.top.equalTo(scrollView.snp.bottom).offset(20)
        }
        
        // 设置tableView
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        scrollView.addSubview(tableView)
        activeTableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(describeLabel)
            make.bottom.equalTo(view).offset(-5)
            make.top.equalTo(activeLabel.snp.bottom).offset(5)
        }
        
    }
    
//    func test() {
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActiveTableViewCell()
        let cellColorIndex = indexPath.row % 4
        let leftColor = cellColors[cellColorIndex]
        let rightColor = cellColorsAlpha[cellColorIndex]
        let gradientColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = cell.contentView.frame
        gradientLayer.frame.size.height = 100
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.type = kCAGradientLayerAxial;
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    
    

}
