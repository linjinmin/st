//
//  User.swift
//  st
//
//  Created by 林劲民 on 2018/3/15.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class User: NSObject {
    
    @objc var id: NSString!
    @objc var name: NSString!
    @objc var mobile: NSString!
    @objc var province: NSString!
    @objc var school: NSString!
    @objc var series: NSString!
    @objc var city: NSString!
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
//    required? init(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeObject(forKey: "id") as? NSString
//        name = aDecoder.decodeObject(forKey: "nickname") as? NSString
//        mobile = aDecoder.decodeObject(forKey: "mobile") as? NSString
//        province = aDecoder.decodeObject(forKey: "province") as? NSString
//        school = aDecoder.decodeObject(forKey: "school") as? NSString
//        series = aDecoder.decodeObject(forKey: "series") as? NSString
//        city = aDecoder.decodeObject(forKey: "city") as? NSString
//    }
//
//    func encodeWithCoder(aCoder:NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(mobile, forKey: "mobile")
//        aCoder.encode(province, forKey: "province")
//        aCoder.encode(school, forKey: "school")
//        aCoder.encode(series, forKey: "series")
//        aCoder.encode(city, forKey: "city")
//    }

}
