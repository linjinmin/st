//
//  HomeActive.swift
//  st
//
//  Created by 林劲民 on 2018/3/28.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class HomeActive: NSObject {
    
    // 活动id
    @objc var id: NSString!
    // 活动名称
    @objc var name: NSString!
    // 是否需要审核 0不需要 1需要
    @objc var need_examime: NSString!
    // 是否团队 0不是 1是
    @objc var is_team: NSString!
    // 团队最少人数
    @objc var min: NSString!
    // 团队最多人数
    @objc var max: NSString!
    // 活动开始时间
    @objc var begin: NSString!
    // 活动结束时间
    @objc var end: NSString!
    // 参与数量
    @objc var num: NSString!
    // 创建人名称
    @objc var user_name: NSString!
    // 活动所属社团
    @objc var tissue_name: NSString!
    // 已报名人数
    @objc var join_num: NSString!
    
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
