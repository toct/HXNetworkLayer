public class CardDetailOutModel: Codable {
    public var hx_accountName: String?
    public var hx_accountNo: String?
    public var hx_bankCode: String?
    public var hx_bindId: String?
    public var hx_bankName: String?
    public var hx_creditCard: String?
    public var hx_accountType: String?
    public var hx_identityNo: String?
    public var hx_accountPhone: String?
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
