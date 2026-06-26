//
//  HXNetworkLayerConstant.swift
//  HXNetworkLayer
//
//  Created by mc on 3/3/26.
//
public enum FormType {
    case none
    case kyc
    case bankCardModify
}

public enum CheckType {
    case authorization
    case inquire
}
public enum PermissionStatus {
    case notDetermined
    case authorized
    case limited
    case restricted
    case denied
}

public typealias CallBackType = ((CheckType, PermissionStatus, Any?) -> ())

//let APPID = "liguibin-phi"
//let SALT = "ABrZLnK0qHKCyqRc"
//let hostPrefix = "https://test-phl-api."
//public let hx_contryId = "63"

//let APPID = "liguibin_mex"
//let SALT = "NE3eqh8u0iZTmVxj"

let APPID = "liupeice4"
let SALT = "q5rnURR5mSwbLEPS"

let hostPrefix = "https://test-mxn-api."
public let hx_contryId = "52"

public let hx_secretKey = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALHlrsKZ";
var hx_networkType = "0"
//13 timestamp
var milliStamp : String {
    let data = NSDate()
    let timeInterval: TimeInterval = data.timeIntervalSince1970
    let millisecond = CLongLong(round(timeInterval*1000))
    return String(millisecond)
}

import CommonCrypto
import CryptoKit
import SwiftUI

public var hx_moneyKey: String {
    switch hx_contryId{
    case "63":
        return "₱"
    case "66":
        return "฿"
    case "91":
        return "₹"
    case "52":
        return "MXN"
    default:
        return ""
    }
}

public var hx_languageCode: String {
    switch hx_contryId{
    case "63", "91":
        return "en"
    case "66":
        return "th"
    case "52":
        return "es"
    default:
        return ""
    }
}


public func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1.0) -> Color {
    Color(.sRGB, red: r/255.0, green: g/255.0, blue: b/255.0, opacity: a)
}

public var hx_statusHeight: CGFloat {
    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first?.safeAreaInsets.top ?? 0
}
