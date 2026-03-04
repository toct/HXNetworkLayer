class ParamInModel: NSObject, Codable {
    let hx_clientLanguage = "en"//"en" "th"
    let hx_os = "2"
    let hx_channel = "app_store"
    let hx_clientVersion = DeviceInfoInModel.hx_appVersion()
    let hx_userId = LocalizationData.shared.hx_tmpLoginData?.hx_userId ?? ""
    let hx_deviceId = AmountOutModel.hx_UUID()
    let hx_version = "2.0"
    var hx_clientTime = milliStamp
    var hx_nonce = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    let hx_token = LocalizationData.shared.hx_tmpLoginData?.hx_token ?? ""
    let hx_appId = APPID
    var hx_sign = ""
    var hx_data: [String: String]?
    var hx_requestParams: [String: Any] = [:]
    enum CodingKeys: String, CodingKey {
        case hx_clientLanguage = "clientLanguage"
        case hx_os = "os"
        case hx_channel = "channel"
        case hx_clientVersion = "clientVersion"
        case hx_userId = "userId"
        case hx_deviceId = "deviceId"
        case hx_version = "version"
        case hx_clientTime = "clientTime"
        case hx_nonce = "nonce"
        case hx_token = "token"
        case hx_appId = "appId"
        case hx_sign = "sign"
        case hx_data = "data"
    }
    override init() {
        super.init()
    }
    init(param: [String: Any] = [:], needSignedKey:[String] = []) {
        super.init()
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        hx_sign = hx_encryption2(param, hx_commonParams: hx_dict, needSignedKey)
        hx_requestParams = param
    }
    
    func hx_getJson() -> [String: Any]?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
             
            let jsonData = try encoder.encode(self)
            
            if var params = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                params[CodingKeys.hx_data.rawValue] = hx_requestParams
                return params
            }
        } catch {
            print("encryption failed:", error)
        }
        return nil
    }
    
    private var hx_commonSignedKeys: [String] {
        [CodingKeys.hx_appId.rawValue,CodingKeys.hx_deviceId.rawValue,CodingKeys.hx_channel.rawValue,CodingKeys.hx_nonce.rawValue,CodingKeys.hx_version.rawValue,CodingKeys.hx_clientTime.rawValue,CodingKeys.hx_os.rawValue]
    }
    
    private func hx_encryption1(_ params: [String: Any] = [:], hx_commonParams:[String:Any] = [:] , _ signedKeys:[String] = []) -> String{
        let mergedparams = params.merging(hx_commonParams) { (_, second) -> Any in return second }
        let combinedKeys = signedKeys + hx_commonSignedKeys
        var seenKeys = [String: Bool]()
        let signedKeys = combinedKeys.filter { seenKeys.updateValue(true, forKey: $0) == nil }
                 
        let signValues = signedKeys.compactMap { (mergedparams[$0]! as! String) }.sorted() as [String]
        let joinedStr = signValues.joined(separator: "&")
        let saltStr = joinedStr.hx_md5 + SALT

        let sign = saltStr.hx_md5

        return sign
    }
    
    private func hx_encryption2(_ params: [String: Any] = [:], hx_commonParams:[String:Any] = [:] , _ signedKeys:[String] = []) -> String{
        let mergedparams = params.merging(hx_commonParams) { (_, second) -> Any in return second }
        let combinedKeys = signedKeys + hx_commonSignedKeys
        var seenKeys = [String: Bool]()
        let signedKeys = combinedKeys.filter { seenKeys.updateValue(true, forKey: $0) == nil }
                 
        let signValues = signedKeys.compactMap { (mergedparams[$0]! as! String) }.sorted() as [String]
        
        let joinedStr = signValues.joined(separator: "&")
        let saltStr = joinedStr.hx_md5.uppercased() + SALT

        let shaStr = saltStr.hx_SHA256()

        let sign = (shaStr as NSString).substring(with: NSRange(location: 0, length: 32)).uppercased()
        
        return sign
    }
}
