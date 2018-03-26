//
//  User.swift
//  st
//
//  Created by 林劲民 on 2018/3/15.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class User: NSObject {
    
    @objc var id: NSString!
    @objc var name: NSString!
    @objc var mobile: NSString!
    // 省份名称
    @objc var province_name: NSString!
    // 省份id
    @objc var province: NSString!
    // 学校名称
    @objc var school_name: NSString!
    // 学校id
    @objc var school: NSString!
    // 系名称
    @objc var series_name: NSString!
    // 系id
    @objc var series: NSString!
    // 头像
    @objc var head_pic: NSString!
    
    
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
