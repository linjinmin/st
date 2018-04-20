//
//  MyTissue.swift
//  st
//
//  Created by 林劲民 on 2018/4/15.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class MyTissue: NSObject {
    
    //id
    @objc var id: NSString!
    // 社团昵称
    @objc var name: NSString!
    // 职位
    @objc var job: NSString!
    // 头像
    @objc var pic: NSString!
    
    
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
