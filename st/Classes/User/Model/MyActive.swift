//
//  MyActive.swift
//  st
//
//  Created by 林劲民 on 2018/4/11.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class MyActive: NSObject {
    
    
    // 活动id
    @objc var id: NSString!
    // 活动名称
    @objc var active_name: NSString!
    // 活动地点
    @objc var address: NSString!
    // 活动发起社团
    @objc var tissue_name: NSString!
    // 活动详情
    @objc var detail: NSString!
    // 报名开始时间
    @objc var sign_begin: NSString!
    // 报名结束时间
    @objc var sign_end: NSString!
    // 活动开始时间
    @objc var active_begin: NSString!
    // 活动结束时间
    @objc var active_end: NSString!
    // 社团名称
    @objc var name: NSString!
    // 参加状态
    @objc var join_status: NSString!
    
    
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
