//
//  SocietyMember.swift
//  st
//
//  Created by 林劲民 on 2018/4/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class SocietyMember : NSObject {
    
    
    // 用户id
    weak var id: NSString!
    // 头像
    weak var head_pic: NSString!
    // 昵称
    weak var name: NSString!
    
    
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
