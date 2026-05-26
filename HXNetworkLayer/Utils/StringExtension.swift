
import CommonCrypto
import CryptoKit

extension String {
    public var hx_formatPhone: String {
        var num = filter(\.isNumber)
        guard num.hx_isValidPhone() else { return "" }
        if num.hasPrefix(hx_contryId) {
            num = String(num.dropFirst(hx_contryId.count))
        }
        if hx_contryId == "63" {
            if num.hasPrefix("09") && num.count == 11 { num = String(num.dropFirst()) }
        }
        return num
    }
    
    public func hx_isValidPhone() -> Bool {
        guard let hx_pattern = SharedModel.shared.hx_constactValue?[hx_contryId] as? String else { return false }
        return self.hx_verify(with:hx_pattern)
    }
    func hx_otpVerify() -> Bool {
        let hx_pattern =  "^\\d{6}$"
        return self.hx_verify(with:hx_pattern)
    }
    public func hx_verify(with predicate: String) -> Bool {
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
    public func hx_formatNumber(_ count: Int = 0) -> String {
        let hx_formatter = NumberFormatter()
        hx_formatter.numberStyle = .decimal
        hx_formatter.minimumFractionDigits = count
        hx_formatter.maximumFractionDigits = count
        hx_formatter.locale = Locale(identifier: "en_US")
        guard let number = hx_formatter.number(from: self) else {
            return self
        }
        return hx_formatter.string(from: number) ?? ""
    }
    
    public func hx_formatNumberWithMoneyKey(_ count: Int = 0) -> String {
        let hx_formatter = NumberFormatter()
        hx_formatter.numberStyle = .decimal
        hx_formatter.minimumFractionDigits = count
        hx_formatter.maximumFractionDigits = count
        hx_formatter.locale = Locale(identifier: "en_US")
        guard let number = hx_formatter.number(from: self) else {
            return hx_moneyKey + self
        }
        return hx_moneyKey + (hx_formatter.string(from: number) ?? "")
    }
}
