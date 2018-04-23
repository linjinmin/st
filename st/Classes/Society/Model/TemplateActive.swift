//
//  TemplateActive.swift
//  st
//
//  Created by 林劲民 on 2018/4/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class TemplateActive: NSObject{
    
    // id
    @objc var id: NSString!
    // 活动名称
    @objc var name: NSString!
    // 地址
    @objc var address: NSString!
    // 详情
    @objc var describe: NSString!
    // 社团名称
    @objc var tissue_name: NSString!
    // 照片
    @objc var photo: NSArray!

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
