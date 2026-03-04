class AmountOutModel: Codable {
    var  hx_loanAmount: String?
    var  hx_termOptions: [TermOutModel]?
    
    enum CodingKeys:String, CodingKey {
        case  hx_loanAmount = "loanAmount"
        case  hx_termOptions = "termDetailList"
    }
    
    
    static func hx_UUID() -> String {
        var uuid = self.hx_readKeychainQuery(service: DeviceInfoInModel.KEYCHAIN_UUID)
        if uuid as! String == "" {
            uuid = hx_IDFV()
            self.hx_writeKeychainQuery(service: DeviceInfoInModel.KEYCHAIN_UUID, data: uuid)
        }
        return uuid as! String
    }
    
    static func hx_IDFV() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    static func hx_getKeychainQuery(service: String) -> Dictionary<String, Any>{
        let secItem = [
            kSecClass as String:kSecClassGenericPassword as String,
            kSecAttrService as String : service,
            kSecAttrAccount as String : service,
            kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock as String
        ] as Dictionary<String, Any>
        return secItem
    }
    
    static func hx_writeKeychainQuery(service: String, data:Any) {
        var kcq = self.hx_getKeychainQuery(service: service)
        SecItemDelete(kcq as CFDictionary)
        kcq[kSecValueData as String] = data
        SecItemAdd(kcq as CFDictionary, nil)
    }
    static func hx_readKeychainQuery(service: String) -> Any {
        var ret: String = ""
        var kcq = self.hx_getKeychainQuery(service: service)
        kcq[kSecReturnData as String] = kCFBooleanTrue
        kcq[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var valueAttributes : AnyObject?
        let results = SecItemCopyMatching(kcq as CFDictionary, &valueAttributes)
        if results == Int(errSecSuccess) {
            if let resultsData = valueAttributes as? Data{
                ret = String(data: resultsData, encoding: String.Encoding.utf8) ?? ""
            }
        }
        return ret
    }
    
    static func hx_deleteKeychainQuery(service: String){
        let kcq = self.hx_getKeychainQuery(service: service)
        SecItemDelete(kcq as CFDictionary);
    }
}

