//
//  CardInfoOutModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

public class CardInfoOutModel: Codable {
    /// 户名
    public var hx_accountName: String?
    /// 账号
    public var hx_accountNo: String?
    /// 账户验证
    public var hx_accountNoVerify: String?
    /// 手机号
    public var hx_accountPhone: String?
    /// 三方账户标识
    public var hx_accountToken: String?
    /// 账户类型
    public var hx_accountType: String?
    /// APP编号
    public var hx_appId: String?
    /// 银行Code
    public var hx_bankCode: String?
    /// 银行名称
    public var hx_bankName: String?
    /// 信用卡号
    public var hx_creditCard: String?
    /// 币种
    public var hx_currency: String?
    /// 默认卡标记：0否 1是
    public var hx_defaultFlag: String?
    /// 银行卡是否可以编辑，0否 1是
    public var hx_editFlag: String?
    /// 交易所
    public var hx_exchange: String?
    /// 名字
    public var hx_firstName: String?
    /// IFSC
    public var hx_ifsc: String?
    /// 父姓
    public var hx_lastName: String?
    /// 绑卡渠道
    public var hx_paymentType: String?
    /// 记录编号
    public var hx_recordId: String?
    
    public var hx_userId: String?
    
    public var hx_bankCardBindId: Int?

    enum CodingKeys:String, CodingKey {
        /// 户名
        case hx_accountName = "accountName"
        /// 账号
        case hx_accountNo = "accountNo"
        /// 账户验证
        case hx_accountNoVerify = "accountNoVerify"
        /// 手机号
        case hx_accountPhone = "accountPhone"
        /// 三方账户标识
        case hx_accountToken = "accountToken"
        /// 账户类型
        case hx_accountType = "accountType"
        /// APP编号
        case hx_appId = "appId"
        /// 银行Code
        case hx_bankCode = "bankCode"
        /// 银行名称
        case hx_bankName = "bankName"
        /// 信用卡号
        case hx_creditCard = "creditCard"
        /// 币种
        case hx_currency = "currency"
        /// 默认卡标记：0否 1是
        case hx_defaultFlag = "defaultFlag"
        /// 银行卡是否可以编辑，0否 1是
        case hx_editFlag = "editFlag"
        /// 交易所
        case hx_exchange = "exchange"
        /// 名字
        case hx_firstName = "firstName"
        /// IFSC
        case hx_ifsc = "ifsc"
        /// 父姓
        case hx_lastName = "lastName"
        /// 绑卡渠道
        case hx_paymentType = "paymentType"
        /// 记录编号
        case hx_recordId = "recordId"
        
        case hx_userId = "userId"
        
        case hx_bankCardBindId = "bankCardBindId"
    }
}

struct CardAssetOutModel: Codable  {
    var hx_payAccountInfoList: [CardInfoOutModel]?
    enum CodingKeys:String, CodingKey {
        case hx_payAccountInfoList = "payAccountInfoList"
    }
}

