//
//  Networking.swift
//  st
//
//  Created by 林劲民 on 2018/3/5.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import SwiftyJSON

class Networking: AFHTTPSessionManager {
    
    static let tool: Networking = {
        let t = Networking()
        t.requestSerializer = AFHTTPRequestSerializer()
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/html", "text/json", "text/javascript") as? Set<String>
        return t
    }()
    
    class func share() -> Networking {
        return tool
    }
    
    class func setHeader() {
    Networking.share().requestSerializer.setValue(AccountTool.getAccount()?.token as String?, forHTTPHeaderField: "token")
        
    }
    
    class func setHeaderByToken(token: String) {
        Networking.share().requestSerializer.setValue(token, forHTTPHeaderField: "token")
    }
    
}

