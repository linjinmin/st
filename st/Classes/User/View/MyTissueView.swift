//
//  MyTissueView.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class MyTissueView: UIView {
    
    // 社团id
    weak var tissue_id: NSString!
    // 社团头像
    weak var tissueImageView: UIImageView!
    // 社团名称
    weak var tissueNameLabel: UILabel!
    // 职务label
    weak var jobLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        
        // 社团头像
        let tissueIamgeView = UIImageView()
        tissueIamgeView.layer.masksToBounds = true
        tissueImageView.layer.cornerRadius = 20
        addSubview(tissueImageView)
        tissueImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.height.width.equalTo(40)
        }
        
        // 社团label
        let tissueNameLabel = UILabel()
        tissueNameLabel.font = UIFont.systemFont(ofSize: 18)
        tissueNameLabel.textColor = UIColor.black
        addSubview(tissueNameLabel)
        tissueNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(tissueIamgeView.snp.right).offset(10)
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
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
