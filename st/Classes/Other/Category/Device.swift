//
//  Device.swift
//  st
//
//  Created by 林劲民 on 2018/4/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
