//
//  SignMember.swift
//  st
//
//  Created by 林劲民 on 2018/4/25.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SignMember: NSObject {
    
    
    // 头像
    @objc var pic: NSString!
    // 名称
    @objc var name: NSString!
    // 签到状态
    @objc var sign_status: NSString!
    
    
    
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
