//
//  ActiveDetail.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ActiveDetail: NSObject {
    
    // 活动名称
    @objc var active_name: NSString!
    // 活动简介
    @objc var describe: NSString!
    // 报名开始时间
    @objc var sign_begin: NSString!
    // 报名结束时间
    @objc var sign_end: NSString!
    // 活动开始时间
    @objc var active_begin: NSString!
    // 活动结束时间
    @objc var active_end: NSString!
    // 地址
    @objc var address: NSString!
    // 社团id
    @objc var tissue_id: NSString!
    // 社团名称
    @objc var tissue_name: NSString!
    // 用户组
    @objc var users: NSArray!
    // 照片
    @objc var photo: NSArray!
    // 参与人数
    @objc var member_join: NSString!
    // 总人数
    @objc var member_count: NSString!
    // 是否团队
    @objc var is_team: NSString!
    // 最少报名人数
    @objc var min: NSString!
    // 最多报名人数
    @objc var max: NSString!
    // 报名状态
    @objc var join_status: NSString!
    // 报名上限人数
    @objc var num: NSString!
    
    
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
