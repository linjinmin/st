//
//  MyActiveView.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class MyActiveView: UIView {
    
    // 活动id
    weak var active_id: NSString!
    // 活动名称
    weak var nameLabel: UILabel!
    // 报名时间
    weak var signTimeLabel: UILabel!
    // 活动时间
    weak var activeTimeLabel: UILabel!
    // 发起社团
    weak var tissueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // 活动名称
        let nameLabel = setupLabel(font: 22)
        addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
        }
        
        // 活动时间
        let activeTimeLabel = setupLabel(font: 16)
        addSubview(activeTimeLabel)
        self.activeTimeLabel = activeTimeLabel
        activeTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(self).offset(-10)
        }
        
        // 报名时间
        let signTimeLabel = setupLabel(font: 16)
        addSubview(signTimeLabel)
        self.signTimeLabel = signTimeLabel
        signTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(activeTimeLabel.snp.top).offset(5)
        }
        
        // 社团
        let tissueLabel = setupLabel(font: 16)
        addSubview(tissueLabel)
        self.tissueLabel = tissueLabel
        tissueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }
        
        // 点击btn
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.white
        return label
    }
    
    @objc func btnClick() {
        
        let vc = ActiveDetailViewController()
        vc.activeId = active_id
    UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.navigationController?.pushViewController(vc, animated: true)
    }

}
