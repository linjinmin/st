//
//  ApplyMobile.swift
//  st
//
//  Created by 林劲民 on 2018/4/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ApplyMobile: NSObject {
    
    // 消息id
    @objc var id: NSString!
    // 用户id
    @objc var user_id: NSString!
    // 用户id_two
    @objc var user_id_two: NSString!
    // 头像
    @objc var head_pic: NSString!
    // 状态
    @objc var status: NSString!
    // 内容
    @objc var msg: NSString!
    // 来源活动
    @objc var active: NSString!
    // 用户昵称
    @objc var name: NSString!
    // 活动id
    @objc var active_id: NSString!

    
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
