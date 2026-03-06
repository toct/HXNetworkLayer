import UIKit

public class FormCellOutModel: Codable, Identifiable {
    public var  hx_opions: [OptionOutModel]?
    public var  hx_required: Int = 1
    public var  hx_opionsCode: String
    public var  hx_opionsName: String
    public var  hx_opionsSort: Int
    public var  hx_opionsStatus: Int?
    public var  hx_opionsType: Int
    public var  hx_expression: String?
    public var  hx_optDisplay: String?
    public var  hx_optValue: String?
    public var  hx_optType: String?
    enum CodingKeys:String, CodingKey {
        case  hx_opions = "buttonList"
        case  hx_required = "isRequired"
        case  hx_opionsCode = "itemCode"
        case  hx_opionsName = "itemName"
        case  hx_opionsSort = "itemSort"
        case  hx_opionsStatus = "itemStatus"
        case  hx_opionsType = "itemType"
        case  hx_expression = "regularExpression"
    }
    
    public init(hx_opionsCode: String, hx_opionsName: String, hx_opionsSort: Int) {
        self.hx_opions = []
        self.hx_required = 1
        self.hx_opionsCode = hx_opionsCode
        self.hx_opionsName = hx_opionsName
        self.hx_opionsSort = hx_opionsSort
        self.hx_opionsStatus = nil
        self.hx_opionsType = -1
        self.hx_expression = nil
        self.hx_optValue = nil
        self.hx_optType = nil
    }
    
    public func hx_selectCell() -> Bool {
        if let hx_opions = hx_opions, !hx_opions.isEmpty || hx_opionsCode == "bank_code" {
            return true
        }
        return false
    }
    
    public func hx_keyboardType() -> UIKeyboardType {
        switch hx_opionsCode {
        case "child_count", "account_no", "confirm_account_no", "zip_code", "Telegram", "LINE", "identity_no", "account_phone":
            return .numberPad
        case "email":
            return .emailAddress
        default:
            return .default
        }
    }
    
    public func hx_textInput(_ input: String) -> String {
        var hx_value = input
        
        // 数字过滤
        if hx_keyboardType() == .numberPad {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            hx_value = hx_value.unicodeScalars
                .filter { allowedCharacters.contains($0) }
                .map { String($0) }
                .joined()
        }
        
        // 长度限制
        switch hx_opionsCode {
        case "child_count":
            if hx_value.count > 3 {
                hx_value = String(hx_value.prefix(3))
            }
        case  "Telegram", "LINE":
            let count = hx_value.hasPrefix("0") ? 10 : 9
            if hx_value.count > count {
                hx_value = String(hx_value.prefix(count))
            }
        case "account_no", "confirm_account_no":
            if hx_value.count > 10 {
                hx_value = String(hx_value.prefix(10))
            }
        case "account_phone":            
            let count = hx_value.hasPrefix("6309") ? 13 : (hx_value.hasPrefix("639") ? 12 : (hx_value.hasPrefix("09") ? 11 : 9))
            if hx_value.count > count {
                hx_value = String(hx_value.prefix(count))
            }
        case "identity_no":
            if hx_value.count > 13 {
                hx_value = String(hx_value.prefix(13))
            }
        case "zip_code":
            if hx_value.count > 16 {
                hx_value = String(hx_value.prefix(16))
            }
        case "facebook", "email":
            if hx_value.count > 128 {
                hx_value = String(hx_value.prefix(128))
            }
        case "address":
            if hx_value.count > 256 {
                hx_value = String(hx_value.prefix(256))
            }
        default:
            break
        }
        
        return hx_value
    }
}
