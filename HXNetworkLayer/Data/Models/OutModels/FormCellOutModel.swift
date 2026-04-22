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
    public var  hx_visible: Bool = true
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
    
    public init(hx_opions: [OptionOutModel]? = nil, hx_required: Int = 1, hx_opionsCode: String, hx_opionsName: String = "", hx_opionsSort: Int = 0, hx_optValue: String? = nil, hx_optType: String? = nil, hx_visible: Bool = true) {
        self.hx_opions = hx_opions
        self.hx_required = hx_required
        self.hx_opionsCode = hx_opionsCode
        self.hx_opionsName = hx_opionsName
        self.hx_opionsSort = hx_opionsSort
        self.hx_opionsStatus = nil
        self.hx_opionsType = -1
        self.hx_expression = nil
        self.hx_optDisplay = nil
        self.hx_optValue = hx_optValue
        self.hx_optType = hx_optType
        self.hx_visible = hx_visible
    }
    
    public var hx_isSelectedCell: Bool {
        if let hx_opions = hx_opions, !hx_opions.isEmpty || hx_opionsCode == "bank_code" || hx_opionsCode == "province" || hx_opionsCode == "city" || hx_opionsCode == "bank_name" {
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
        case "account_no", "confirm_account_no":
            if hx_value.count > 10 {
                hx_value = String(hx_value.prefix(10))
            }
        case "Telegram", "LINE", "account_phone":
            var count = 0
            if hx_value.hasPrefix(hx_contryId) && hx_opionsCode == "account_phone" {
                count += hx_contryId.count
            }
            count += (hx_value.hasPrefix("0") ? 10 : 9)
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
