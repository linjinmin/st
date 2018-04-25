//
//  ActiveSquare.swift
//  st
//
//  Created by 林劲民 on 2018/4/24.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class ActiveSquare : NSObject {
    
    
    // 活动id
    @objc var id: NSString!
    // 报名开始时间
    @objc var sign_begin: NSString!
    // 报名结束时间
    @objc var sign_end: NSString!
    // 活动开始时间
    @objc var active_begin: NSString!
    // 活动结束时间
    @objc var active_end: NSString!
    // 活动昵称
    @objc var name: NSString!
    // 社团名称
    @objc var tissue_name: NSString!
    // 社团id
    @objc var tissue_id: NSString!
    // 地址
    @objc var address: NSString!
    // 参加状态
    @objc var join_status: NSString!
    // 当前报名人数
    @objc var join_num: NSString!
    // 报名人数上线
    @objc var max: NSString!
    
    
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
