//
//  NoticeFriendBottomView.swift
//  st
//
//  Created by 林劲民 on 2018/4/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NoticeFriendBottomView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // 同意按钮
        let agreeBtn = UIButton()
        agreeBtn.backgroundColor = Constant.viewColor
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.setTitleColor(.white, for: .normal)
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        agreeBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        agreeBtn.layer.cornerRadius = 21
        self.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(42)
            make.right.equalTo(self.snp.centerX).offset(-10)
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        // 拒绝按钮
        let refuseBtn = UIButton()
        refuseBtn.backgroundColor = .white
        refuseBtn.setTitle("拒绝", for: .normal)
        refuseBtn.setTitleColor(Constant.viewColor, for: .normal)
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        refuseBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        refuseBtn.layer.cornerRadius = 21
        self.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.height.equalTo(42)
            make.left.equalTo(self.snp.centerX).offset(10)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
    }
    
    
    @objc func agreeBtnClick() {
        
    }
    
    
    @objc func refuseBtnClick() {
        
    }
    
    
    
}
