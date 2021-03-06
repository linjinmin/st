//
//  HomeActive.swift
//  st
//
//  Created by 林劲民 on 2018/3/28.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class UserMessage: NSObject {
    
    // 消息id
    @objc var id: NSString!
    // 消息内容
    @objc var msg: NSString!
    // 是否已读状态
    @objc var status: NSString!
    // 类型
    @objc var type: NSString!
    // 标题
    @objc var title: NSString!
    // 创建时间
    @objc var create_time: NSString!
    // 用户id
    @objc var user_id: NSString!
    // 用户id two
    @objc var user_id_two: NSString!
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
