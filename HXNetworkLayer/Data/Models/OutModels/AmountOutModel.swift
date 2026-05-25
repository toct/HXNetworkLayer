public class AmountOutModel: Codable {
    public var  hx_loanAmount: String?
    public var  hx_termOptions: [TermOutModel]?
    
    enum CodingKeys:String, CodingKey {
        case  hx_loanAmount = "loanAmount"
        case  hx_termOptions = "termDetailList"
    }
    
    static func hx_UUID() -> String {
	let hx_identifier = Bundle.main.bundleIdentifier ?? "Bundle.main.bundleIdentifier"
        if let uuid = hx_getKeychainValue(hx_identifier), !uuid.isEmpty {
            return uuid
        }
        
        let newUuid = hx_IDFV()
        hx_saveKeychainValue(newUuid, key: hx_identifier)
        return hx_getKeychainValue(hx_identifier) ?? newUuid
    }

    private static func hx_getKeychainValue(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }

    private static func hx_saveKeychainValue(_ value: String, key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func hx_IDFV() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
}

