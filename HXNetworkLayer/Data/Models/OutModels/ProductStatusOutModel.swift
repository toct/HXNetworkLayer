
public class ProductStatusOutModel: Codable {
    public var  hx_loanAmount: String?
    public var  hx_productId: String?
    public var  hx_productLogo: String?
    public var  hx_productName: String?
    public var  hx_reLoanStatus: Int?
    public var  hx_content: String?
    enum CodingKeys:String, CodingKey {
        case  hx_loanAmount = "loanAmount"
        case  hx_productId = "productId"
        case  hx_productLogo = "productLogo"
        case  hx_productName = "productName"
        case  hx_reLoanStatus = "userType"
    }
}
