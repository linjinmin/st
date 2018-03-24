//
//  Account.swift
//  st
//
//  Created by 林劲民 on 2018/3/8.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class Account: NSObject {
    
    @objc var token: NSString!
    @objc var tokenTime: NSString!
    
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
