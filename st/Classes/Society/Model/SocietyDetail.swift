//
//  SocietyDetail.swift
//  st
//
//  Created by 林劲民 on 2018/4/12.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyDetail: NSObject {
    
    // 社团名称
    @objc var tissue_name: NSString!
    // 社团简介
    @objc var tissue_describe: NSString!
    // 照片墙
    @objc var photos: NSArray!
    // 活动
    @objc var active: NSArray!
    // 成员总数
    @objc var member_count: NSString!
    
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
