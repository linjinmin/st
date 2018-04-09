//
//  AccountTool.swift
//  st
//
//  Created by 林劲民 on 2018/3/8.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class AccountTool: NSObject {
    
    static let shareAccountTool = AccountTool()
    
    fileprivate var account: Account?
    
    fileprivate var user: User?
    
    class func setAccount(_ account: Account) {
        AccountTool.shareAccountTool.account = account
    }
    
    class func getAccount() -> Account? {
        return AccountTool.shareAccountTool.account
    }
    
    class func getUser() -> User? {
        return AccountTool.shareAccountTool.user
    }
    
    class func setUser(_ user: User) {
        AccountTool.shareAccountTool.user = user
    }
    
    class func isLogin() -> Bool {
        return AccountTool.shareAccountTool.account != nil
    }
    
    class func saveToken(dict: NSDictionary) {
        UserDefaults.standard.set(dict, forKey: "token")
    }
    
    class func saveUserInfo(dict: NSDictionary) {
        UserDefaults.standard.set(dict, forKey: "user")
    }
    
    class func getUserInfoLocal() {
        let dict = UserDefaults.standard.dictionary(forKey: "user")
        if dict == nil {
            return
        }
        let user = User(dict: dict! as [String : AnyObject])
        AccountTool.setUser(user)
    }
    
    class func saveAuth() {
        UserDefaults.standard.set("1", forKey: "auth")
    }
    
    class func getUserInfo() {
        let params = NSMutableDictionary()
        params["method"] = Api.getUserInfoMethod
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                let dict = response["data"].dictionaryObject! as [String : AnyObject]
                let user = User(dict: dict)
                AccountTool.setUser(user)
                // 保存数据到本地
                self.saveUserInfo(dict: dict as NSDictionary)
            } else {
                SVProgressHUD.showError(withStatus: "更新用户信息失败")
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
    }
    
    // 判断是否认证过
    class func checkAuth(window: UIWindow) {
        let check = UserDefaults.standard.string(forKey: "auth")
        if (check == nil) {
            
            // 请求接口判断是否认证过
            let params = NSMutableDictionary()
            params["token"] = getAccount()?.token
            params["method"] = Api.isAuthMethod
            Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
                let response = JSON(response as Any)
                if response["code"].floatValue == 200 {
                    // 认证过
                    self.saveAuth()
                } else {
                    // 弹窗
//                    let vc = ConfirmViewController()
//                    vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
//                    let nav = NavigationController(rootViewController: vc)
                    window.rootViewController = ConfirmViewController()
                }

            }, failure: nil)
        }
    }
    
    // 刷新token
    class func refreshToken() {
        
        if getAccount()?.token == nil {
            return
        }
        
        // 刷新token
        let params = NSMutableDictionary()
        params["method"] = Api.refreshTokenMethod
        params["token"] = getAccount()?.token!
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            let response = JSON(response as Any)
            if response["code"].intValue == 200 {
                let token = response["data"]["token"].stringValue
                // 保存token对象
                let dict = NSMutableDictionary()
                dict["token"] = token
                let date = NSDate()
                let timeInterval = Int(date.timeIntervalSince1970 * 1000)
                dict["time"] = timeInterval
                let account = Account(dict: dict as! [String : AnyObject])
                setAccount(account)
                saveToken(dict: dict)
                Networking.setHeader()
            }
            
        }) { (task, error) in
            
        }
        
    }
    
    // 判断是否有登录记录
    class func checkToken(window: UIWindow) {
        let tokenDict = UserDefaults.standard.dictionary(forKey: "token")
        if (tokenDict == nil || (tokenDict?.isEmpty)!) {
            let vc = LoginViewController()
//            vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
//            let navi = NavigationController(rootViewController:vc)
            window.rootViewController = vc
            
            return
        }
        
        // 获取本地用户信息
        getUserInfoLocal()
        let account = Account(dict: tokenDict! as [String : AnyObject])
        setAccount(account)
        Networking.setHeader()
        
        let vc = HomeViewController()
//        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.screenW, height: Constant.screenH)
//        let navi = NavigationController(rootViewController:vc)
        
        window.rootViewController = vc
    }
    
    class func clearUser() {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    class func clearAccount() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    class func judgeNeedLogin() -> Bool {
        
        if !isLogin() {
            SVProgressHUD.showError(withStatus: "请先登录")
            let vc = LoginViewController()
            vc.view.frame = CGRect(x:0, y:0, width:Constant.screenW, height: Constant.screenH)
            let nav = NavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
            return true
        }
        
        return false
    }
    
}


