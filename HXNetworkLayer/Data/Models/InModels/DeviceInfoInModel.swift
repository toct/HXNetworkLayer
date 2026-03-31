import UIKit

public class DeviceInfoInModel: Codable {
    let hx_uuid: String = AmountOutModel.hx_UUID()
    var hx_idfa: String = "null"
    let hx_idfv: String = AmountOutModel.hx_IDFV()
    
    let hx_phoneMark: String = ApplyResultOutModel.hx_iphoneName()
    let hx_phoneType: String = ApplyResultOutModel.hx_deviceCategoryName()
    let hx_systemVersions: String = hx_systemVersion()
    let hx_versionCode: String = hx_appVersion()
    let hx_sdkVersion: String = "null";
    let hx_screenResolution: String = hx_getScreenResolution()
    let hx_screenWidth: String =  String(format: "%d", UIScreen.main.bounds.width)
    let hx_screenHeight: String = String(format: "%d", UIScreen.main.bounds.height)
    let hx_cpuNum: String = hx_CUPCount()
    let hx_ramCanUse: String = ProductLabelOutModel.hx_ramAvailableSize()
    let hx_ramTotal: String = ProductLabelOutModel.hx_ramTotalMemory()
    let hx_cashCanUse: String = StatusesOutModel.hx_cashAvailableSize()
    let hx_cashTotal: String = StatusesOutModel.hx_cashTotalSize()
    let hx_batteryLevel: String = hx_batteryLevel()
    let hx_totalBootTime: String = ProductOverOutModel.hx_getUptimeWithResting()
    let hx_totalBootTimeWake: String =  String(format: "%d", ProcessInfo.processInfo.systemUptime * 1000)
    let hx_defaultLanguage: String = hx_getLanguage()
    let hx_defaultTimeZone: String = TimeZone.current.identifier

    let hx_network: String = hx_networkType
    var hx_wifiName: String = "null"
    var hx_wifiBssid: String = "null"
    let hx_rooted: String = hx_isJailbroken()
    let hx_debugged: String = OrdersOutModel.hx_isBeingDebugged()
    let hx_simulated: String = OrdersOutModel.hx_isSimulator()
    let hx_proxied: String = OrdersOutModel.hx_getProxyStatus()
    let hx_charged: String = hx_charging()

    let hx_lastBootTime: String = ProductOverOutModel.hx_getBootTime()
    let hx_screenBrightness: String = hx_getScreenBrightness()
    let hx_isvpn: String = ABPageOutModel.hx_isVPNOn()

    public var hx_orderId: String?
    enum CodingKeys: String, CodingKey {
        case hx_uuid = "uuid"
        case hx_idfa = "idfa"
        case hx_idfv = "idfv"
        case hx_phoneMark = "phoneMark"
        case hx_phoneType = "phoneType"
        case hx_systemVersions = "systemVersions"
        case hx_versionCode = "versionCode"
        case hx_sdkVersion = "sdkVersion"
        case hx_screenResolution = "screenResolution"
        case hx_screenWidth = "screenWidth"
        case hx_screenHeight = "screenHeight"
        case hx_cpuNum = "cpuNum"
        case hx_ramCanUse = "ramCanUse"
        case hx_ramTotal = "ramTotal"
        case hx_cashCanUse = "cashCanUse"
        case hx_cashTotal = "cashTotal"
        case hx_batteryLevel = "batteryLevel"
        case hx_totalBootTime = "totalBootTime"
        case hx_totalBootTimeWake = "totalBootTimeWake"
        case hx_defaultLanguage = "defaultLanguage"
        case hx_defaultTimeZone = "defaultTimeZone"
        case hx_network = "network"
        case hx_wifiName = "wifiName"
        case hx_wifiBssid = "wifiBssid"
        case hx_rooted = "rooted"
        case hx_debugged = "debugged"
        case hx_simulated = "simulated"
        case hx_proxied = "proxied"
        case hx_charged = "charged"
        case hx_lastBootTime = "lastBootTime"
        case hx_screenBrightness = "screenBrightness"
        case hx_isvpn = "isvpn"
        case hx_orderId = "orderId"
    }
    
    public init(){
        Idfa.hx_checkAuth { _, _, hx_data in
            self.hx_idfa = hx_data as? String ?? "null"
        }
        
        let wifiInfo = KycPeriodOutModel.hx_getWIFISSID()
        hx_wifiName = wifiInfo["ssid"] ?? "null"
        hx_wifiBssid = wifiInfo["bssid"] ?? "null"
    }
}
