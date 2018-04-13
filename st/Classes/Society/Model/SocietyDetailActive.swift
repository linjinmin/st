//
//  SocietyDetailActive.swift
//  st
//
//  Created by 林劲民 on 2018/4/12.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyDetailActive: NSObject {
    
    // 活动id
    @objc var id: NSString!
    // 活动昵称
    @objc var active_name: NSString!
    // 活动地点
    @objc var address: NSString!
    // 活动简介
    @objc var detail: NSString!
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
