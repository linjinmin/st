//
//  SocietyActive.swift
//  st
//
//  Created by 林劲民 on 2018/4/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyActiveView: UIView {
    
    // 活动名称
    weak var activeNameLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称
    weak var societyLabel: UILabel!
    // 活动详情
    weak var detailLabel: UILabel!
    
    var active: SocietyDetailActive! {
        didSet {
            
            activeNameLabel.text = "\(active.active_name ?? "")"
            addressLabel.text = "地点：\(active.address ?? "")"
            detailLabel.text = "详情：\(active.detail ?? "")"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // 社团名称
        let activeNameLabel = setupLabel(font: 20)
        self.addSubview(activeNameLabel)
        self.activeNameLabel = activeNameLabel
        activeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
        }
        
        // 活动详情
        let detailLabel = setupLabel(font: 16)
        self.addSubview(detailLabel)
        self.detailLabel = detailLabel
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }
        
        // 地点
        let addressLabel = setupLabel(font: 16)
        self.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(detailLabel.snp.top).offset(-3)
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
        let vc = TemplateActiveDetailViewController()
        vc.activeId = active.id
        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
        var object = self.next
        while !(object?.isKind(of: UIViewController.classForCoder()))! && object != nil {
            object = object?.next
        }
        
        let superController = object as! UIViewController
        superController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.white
        return label
    }

}
