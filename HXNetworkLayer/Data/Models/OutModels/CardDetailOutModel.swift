class CardDetailOutModel: Codable {
    var hx_accountName: String?
    var hx_accountNo: String?
    var hx_bankCode: String?
    var hx_bindId: String?
    var hx_bankName: String?
    var hx_creditCard: String?
    var hx_accountType: String?
    var hx_identityNo: String?
    var hx_accountPhone: String?
    enum CodingKeys:String, CodingKey {
        case hx_accountName = "accountName"
        case hx_accountNo = "accountNo"
        case hx_bankCode = "bankCode"
        case hx_bankName = "bankName"
        case hx_bindId = "bindId"
        case hx_accountType = "accountType"
        case  hx_creditCard = "creditCard"
        case hx_identityNo = "identityNo"
        case hx_accountPhone = "accountPhone"
    }
}
