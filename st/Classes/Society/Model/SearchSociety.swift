//
//  BriefSociety.swift
//  st
//
//  Created by 林劲民 on 2018/4/5.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SearchSociety: NSObject {
    
    // 社团id
    @objc var id: NSString!
    // 社团名称
    @objc var name: NSString!
    // 社团简介
    @objc var describe: NSString!
    
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

