import SystemConfiguration.CaptiveNetwork

class KycPeriodOutModel: Codable {
    var  hx_periodId: String?
    var  hx_periodStatus: String?
    var  hx_periodSort: Int
    enum CodingKeys:String, CodingKey {
        case  hx_periodId = "kycId"
        case  hx_periodStatus = "kycStatus"
        case  hx_periodSort = "kycSort"
    }
    static func hx_getWIFISSID() -> Dictionary<String, String> {
        
        let wifiInterfaces = CNCopySupportedInterfaces()
        guard wifiInterfaces != nil else {
            return [:]
        }
        
        var ssid = "null"
        var bssid = "null"
        let interfaceArr = CFBridgingRetain(wifiInterfaces) as! [String]
        if interfaceArr.count > 0 {
            let interfaceName = interfaceArr[0] as CFString
            let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
            if ussafeInterfaceData != nil {
                let interfaceData = ussafeInterfaceData as! [String: Any]
                ssid = interfaceData["SSID"]! as! String
                bssid = interfaceData["BSSID"]! as! String
            }
        }
        return ["ssid":ssid,"bssid":bssid]
    }
}
