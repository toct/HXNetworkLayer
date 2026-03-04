//
//  ABPageOutModel.swift
//  pertainTurn
//
//  Created by Zhuanz密码0000 on 2025/6/6.
//

import Foundation

// MARK: - DataClass
struct ABPageOutModel: Codable {
    /// AB面开关，0是A面、1是B面
    var hx_adContent: String?
    
    enum CodingKeys:String, CodingKey {
        case hx_adContent = "adContent"
    }
    static func hx_isVPNOn() -> String {
        guard let cfDict = CFNetworkCopySystemProxySettings(), let keyValues = SharedModel.shared.hx_constactValue?["vpnMarks"] as? [String] else {
            return "false"
        }
        
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        
        guard let keys = nsDict["__SCOPED__"] as? [String:Any] else {
            return "false"
        }
        
        var result: Bool = false
        for key in keys.keys {
            keyValues.forEach { (value) in
                if key.contains(value) {
                    result = true
                }
            }
        }
        return result ? "true" : "false"
    }
}
