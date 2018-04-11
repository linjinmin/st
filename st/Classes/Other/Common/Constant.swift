//
//  Constant.swift
//  st
//
//  Created by 林劲民 on 2018/2/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


struct Constant {
    // 访问失败
    static let loadFaildText = "服务器连接失败,请稍后再试"
    // 请求等待字体
    static let loadingTitle = "loading"
    // 屏宽
    static let screenH = UIScreen.main.bounds.size.height
    static let screenW = UIScreen.main.bounds.size.width
    // field placeholder color
    static let placeholderColor = UIColor(red:99/255, green:99/255, blue:99/255, alpha:0.8)
    static let placeholderFont = UIFont.systemFont(ofSize: 14)
    // 导航栏背景颜色
    static let globalBarTintColor = UIColor(red:248/255, green:248/255, blue:248/255, alpha:1)
    // 登录注册界面背景颜色
    static let loginOrRegisterBackgroundColor = UIColor(red:248/255, green:248/255, blue:248/255, alpha:1)
    // app 背景颜色
    static let viewBackgroundColor = UIColor(red:248/255, green:248/255, blue:248/255, alpha:1)
    // 登录注册界面字体颜色
    static let loginOrRegisterTitleColor = UIColor(red:87/255, green:113/255, blue:250/255, alpha:1)
    // 左侧功能条宽度
    static let functionListViewWidth = Constant.screenW * 0.6
    // 左侧功能条字体颜色
    static let functionListFontColor = UIColor.black
    // 功能条 按钮之间的距离
    static let functionListBtnOffset = 20
    // 主色调， 蓝色
    static let viewColor = UIColor(red:87/255, green:113/255, blue:250/255, alpha:1)
    // 每页数量
    static let size = 15
    
    
}
