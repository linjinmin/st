//
//  MyTissueView.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SDWebImage

class MyTissueView: UIView {
    
    // 社团id
    weak var tissue_id: NSString!
    // 社团头像
    weak var tissueImageView: UIImageView!
    // 社团名称
    weak var tissueNameLabel: UILabel!
    // 职务label
    weak var jobLabel: UILabel!
    
    var myTissue: MyTissue! {
        
        didSet {
            tissue_id = myTissue.id
            tissueImageView.sd_setImage(with: URL(string: myTissue.pic! as String), placeholderImage: UIImage(named:"image_placeholder"))
            tissueNameLabel.text = "\(myTissue.name ?? "")"
            jobLabel.text = "\(myTissue.job ?? "")"
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        
        // 社团头像
        let tissueImageView = UIImageView()
        tissueImageView.layer.masksToBounds = true
        tissueImageView.layer.cornerRadius = 15
        addSubview(tissueImageView)
        self.tissueImageView = tissueImageView
        tissueImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.height.width.equalTo(30)
        }
        
        // 社团label
        let tissueNameLabel = UILabel()
        tissueNameLabel.font = UIFont.systemFont(ofSize: 18)
        tissueNameLabel.textColor = UIColor.black
        addSubview(tissueNameLabel)
        self.tissueNameLabel = tissueNameLabel
        tissueNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(tissueImageView.snp.right).offset(10)
        }
        
        // 职务label
        let jobLabel = UILabel()
        jobLabel.font = UIFont.systemFont(ofSize: 18)
        jobLabel.textColor = UIColor.lightGray
        addSubview(jobLabel)
        self.jobLabel = jobLabel
        jobLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        // btn
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
    }
    
    @objc func btnClick() {
        
        let vc = SocietyDetailViewController()
        vc.tissue_id = tissue_id
        
        var object = self.next
        while !(object?.isKind(of: UIViewController.classForCoder()))! && object != nil {
            object = object?.next
        }
        
        let superController = object as! UIViewController
        superController.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
