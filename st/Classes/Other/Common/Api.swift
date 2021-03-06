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
    // 上传头像
    static let uploadHeadPic = "User/User/uploadHeadPic"
    // 用户修改密码
    static let alterPassword = "User/User/alterPassword"
    // 我的社团活动 首页
    static let homeActive = "Active/User/myTissueActive"
    // 用户反馈
    static let feedback = "User/Config/feedBack"
    // 登出
    static let logout = "User/User/userLoginOut"
    // 社团模糊搜索
    static let tissueByName = "Tissue/Config/getTissueByName"
    // 我的社团列表
    static let myTissue = "Tissue/User/myTissue"
    // 我的活动
    static let myActive = "Active/User/getActiveByStatus"
    // 社团详情
    static let tissueDetail = "Tissue/School/getTissueDetail"
    // 活动详情
    static let ActiveDetail = "Active/Active/getActiveDetail"
    // 用户详情
    static let userDetail = "User/User/getUserShowDetail"
    // 申请查看手机号
    static let applyMobile = "Active/User/applyActiveUserMobile"
    // 获取消息的
    static let noticeList = "User/User/getUserMessage"
    // 获取模版活动详情
    static let activeTemplate = "Active/Active/getActiveTemplate"
    // 获取查看手机号列表
    static let applyMobileList = "User/User/mobileApplyList"
    // 手机号请求处理
    static let applyMobileCheck = "User/User/mobileApplyCheck"
    // 获取二维码
    static let getQrCode = "Active/Active/createQrCode"
    // 判断是否存在未读消息
    static let unreadMessage = "User/User/unReadMessage"
    // 设置消息已读
    static let updateMessage = "User/User/updateUserMessage"
    // 活动广场
    static let activeSquare = "Active/User/activeSquare"
    // 二维码扫描
    static let qrScan = "Active/Active/activeSign"
    // 手机号获取名称
    static let mobileName = "User/User/mobileName"
    // 获取活动签到人员列表
    static let activeSignMemberList = "Active/Active/getActiveSignPeople"
    // 社团成员列表
    static let tissueMember = "Tissue/User/getTissueMember"
    
}
