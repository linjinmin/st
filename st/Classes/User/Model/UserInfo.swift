//
//  UserInfo.swift
//  st
//
//  Created by 林劲民 on 2018/4/14.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    
    
    // 用户id
    @objc var id: NSString!
    // 用户昵称
    @objc var name: NSString!
    // 手机号
    @objc var mobile: NSString!
    // 头像
    @objc var head_pic: NSString!
    // 省份
    @objc var province: NSString!
    // 学校
    @objc var school: NSString!
    // 系
    @objc var series: NSString!
    // 性别
    @objc var sex: NSString!
    // 是否有权限查看手机号
    @objc var apply_mobile: NSString!
    // 社团
    @objc var tissue: NSArray!
    // 活动
    @objc var active: NSArray!
   
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
