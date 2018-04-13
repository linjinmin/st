//
//  ActiveDetailUser.swift
//  st
//
//  Created by 林劲民 on 2018/4/13.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ActiveDetailUser: NSObject {
    
    // 用户id
    @objc var id: NSString!
    // 用户昵称
    @objc var name: NSString!
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


