import Foundation

class BankcardModifyInModel: NSObject, Codable {
    
    var hx_bankCode: String?
    var hx_accountNo: String?
    var hx_accountType: String?
    var hx_identityNo: String?
    var hx_accountPhone: String?
    
    enum CodingKeys: String, CodingKey {
        case hx_bankCode = "bankCode"
        case hx_accountNo = "accountNo"
        case hx_accountType = "accountType"
        case hx_identityNo = "identityNo"
        case hx_accountPhone = "accountPhone"
    }
    
    init(data:[FormCellOutModel]) {
        
        let hx_data = data.reduce(into: [String: String]()) { dict, hx_model in
            dict[hx_model.hx_opionsCode] = hx_model.hx_optValue
        }
        hx_bankCode = hx_data["bank_code"]
        hx_accountNo = hx_data["account_no"]
        hx_accountType = hx_data["account_type"] ?? ""
        hx_identityNo = hx_data["identity_no"]
        hx_accountPhone = hx_data["account_phone"]
    }
    
    func hx_execute( closer: @escaping ((Bool) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        
        NetworkTool().url(hx_bankCardModify_url).params(hx_dict, signedKeys: ["accountType","bankCode","accountNo"]).callback {  _, success, _ in
            closer(success)
        }.request()
    }
}
