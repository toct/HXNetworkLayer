//
//  HXNetworkLayerConstant.swift
//  HXNetworkLayer
//
//  Created by mc on 3/3/26.
//

enum CheckType {
    case authorization
    case inquire
}
enum PermissionStatus {
    case notDetermined
    case authorized
    case limited
    case restricted
    case denied
}

typealias CallBackType = ((CheckType, PermissionStatus, Any?) -> ())

let APPID = "liuyuzhetextph116"
let SALT = "SJDYhC05rsAvTnFv" // tai test salt

//let hostPrefix = "https://api."
let hostPrefix = "https://test-phl-api."

let hx_secretKey = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALHlrsKZ";
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

extension String {
    var hx_philippinePhone: String {
        let nums = filter(\.isNumber)
        guard nums.hx_isPhilippinePhone() else { return "" }
        if nums.hasPrefix("6309") && nums.count == 13 { return String(nums.dropFirst(3)) }
        if nums.hasPrefix("639") && nums.count == 12 { return String(nums.dropFirst(2)) }
        if nums.hasPrefix("09") && nums.count == 11 { return String(nums.dropFirst()) }
        if nums.hasPrefix("9") && nums.count == 10 { return String(nums) }
        return nums
    }
    
    func hx_isPhilippinePhone() -> Bool {
        guard let hx_pattern = SharedModel.shared.hx_constactValue?["philippine"] as? String else { return false }
        return self.hx_verify(with:hx_pattern)
    }
    func hx_otpVerify() -> Bool {
        let hx_pattern =  "^\\d{6}$"
        return self.hx_verify(with:hx_pattern)
    }
    func hx_verify(with predicate: String) -> Bool {
        let hx_predicate = NSPredicate(format: "SELF MATCHES %@", predicate)
        return hx_predicate.evaluate(with: self)
    }
    var hx_md5: String {
        Insecure.MD5.hash(data: Data(self.utf8)).map { String(format: "%02hhx", $0) }.joined()
    }
    func hx_SHA256 (key: String = hx_secretKey) -> String {
        var result = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, count, &result)
        return Data(result).lazy.map { String(format: "%02x", $0) }.joined()
    }
    func hx_numberFormat() -> String {
        let hx_formatter = NumberFormatter()
        hx_formatter.numberStyle = .decimal
        hx_formatter.minimumFractionDigits = 0
        hx_formatter.maximumFractionDigits = 0
        hx_formatter.locale = Locale(identifier: "en_US")
        guard let number = hx_formatter.number(from: self) else {
            return self
        }
        return hx_formatter.string(from: number) ?? ""
    }
}
