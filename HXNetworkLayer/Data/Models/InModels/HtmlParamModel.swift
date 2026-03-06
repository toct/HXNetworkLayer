import Foundation

public class HtmlParamModel: Codable {
    var hx_baseUrl: String? = SwitchHostAddress.shared.addresss()
    var hx_token: String? = LocalizationData.shared.hx_loginData.hx_token
    var hx_userId: String? = LocalizationData.shared.hx_loginData.hx_userId
    var hx_UA: String? = HtmlParamModel.hx_UA()
    var hx_phoneNum: String? = LocalizationData.shared.hx_userData?.hx_phone
    var hx_clientVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var hx_appId: String? = APPID
    var hx_salt: String? = SALT
    var hx_adContent: String? = LocalizationData.shared.hx_abTag
    var hx_deviceId: String? = AmountOutModel.hx_UUID()
    var hx_kycId: String?
    public var hx_productId: String?
    public var hx_orderId: String?
    var hx_bindId: String?
    public var hx_orderType: String?
    
    ///   - hx_orderType: 待提现订单为1，否则为nil
    public init(hx_kycId: String? = nil, hx_productId: String? = nil, hx_orderId: String? = nil, hx_orderType: String? = nil, hx_bindId: String? = nil) {
        self.hx_kycId = hx_kycId
        self.hx_productId = hx_productId
        self.hx_orderId = hx_orderId
        self.hx_orderType = hx_orderType
        self.hx_bindId = hx_bindId
    }
    
    enum CodingKeys: String, CodingKey {
        case hx_baseUrl = "baseUrl"
        case hx_token = "token"
        case hx_userId = "userId"
        case hx_UA = "UA"
        case hx_phoneNum = "phoneNum"
        case hx_clientVersion = "clientVersion"
        case hx_appId = "appId"
        case hx_salt = "salt"
        case hx_adContent = "adContent"
        case hx_deviceId = "deviceId"
        case hx_kycId = "kycId"
        case hx_productId = "productId"
        case hx_orderId = "orderId"
        case hx_bindId = "bindId"
        case hx_orderType = "orderType"
    }
    
    public static func hx_UA() -> String {
        let version = DeviceInfoInModel.hx_appVersion()
        let deviceType = ApplyResultOutModel.hx_deviceTypeString()
        let deviceModel = ApplyResultOutModel.hx_deviceCategoryName()
        let systemVersion = DeviceInfoInModel.hx_systemVersion()
        return "\(APPID)/\(version)(Apple;\(deviceType);\(deviceModel);iOS \(systemVersion);)"
    }
    
    public func hx_coverToString() -> String? {
        do{
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8)
        }catch{
            return nil
        }
    }
}
