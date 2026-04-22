//
//  HXNetworkLayerConstant.swift
//  HXNetworkLayer
//
//  Created by mc on 3/3/26.
//
public enum FormType {
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

let APPID = "liuyuzhetextph116"
let SALT = "SJDYhC05rsAvTnFv" // tai test salt

//let hostPrefix = "https://api."
let hostPrefix = "https://test-phl-api."

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


public let hx_contryId = "63"

public func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1.0) -> Color {
    Color(.sRGB, red: r/255.0, green: g/255.0, blue: b/255.0, opacity: a)
}
