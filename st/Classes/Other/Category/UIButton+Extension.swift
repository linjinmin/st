//
//  UIButton+Extension.swift
//  st
//
//  Created by 林劲民 on 2018/3/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBottom(){
        self.imageView?.contentMode = .center
        self.titleLabel?.textAlignment = .center
        self.imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        self.titleLabel?.frame = CGRect(x: 0, y: self.frame.width, width: self.frame.width, height: self.frame.height - self.frame.width)
        layoutIfNeeded()
    }
    
    
}
