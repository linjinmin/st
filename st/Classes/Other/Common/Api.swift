//
//  Api.swift
//  st
//
//  Created by 林劲民 on 2018/2/28.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit


class Api {
    
    static let host = "http://api.tbk123.top/"
    
    // 发送验证码接口
    static let codeMethod = "User/User/sendCode"
    // 注册接口
    static let registerMethod = "User/User/register"
    // 登录接口
    static let loginMethod = "User/User/login"
    // 忘记密码短信验证码接口
    static let forgetCodeMethod = "User/User/resetSendCode"
    // 忘记密码重置接口
    static let forgetPwdMethod = "User/User/resetPassword"
    // token 刷新
    static let refreshTokenMethod = "User/User/refreshToken"
    // 是否认证
    static let isAuthMethod = "User/User/isAuthentication"
    // 获取省信息
    static let provinceMethod = "User/Config/getProvince"
    // 获取校信息
    static let schoolMethod = "User/Config/getSchoolAll"
    // 获取用户信息
    static let getUserInfoMethod = "User/User/getUserDetailInfo"
    // 修改用户信息
    static let editUserInfoMethod = "User/User/alterUserDetailInfo"
    // 添加系院
    static let addSeriesMethod = "User/Config/addSeries"
    // 获取系院信息
    static let seriesMethod = "User/Config/getSeriesByKeyWord"
    
    
}
