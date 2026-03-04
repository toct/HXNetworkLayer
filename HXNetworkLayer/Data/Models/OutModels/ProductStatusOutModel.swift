
class ProductStatusOutModel: Codable {
    var  hx_loanAmount: String?
    var  hx_productId: String?
    var  hx_productLogo: String?
    var  hx_productName: String?
    var  hx_reLoanStatus: Int?
    var  hx_content: String?
    enum CodingKeys:String, CodingKey {
        case  hx_loanAmount = "loanAmount"
        case  hx_productId = "productId"
        case  hx_productLogo = "productLogo"
        case  hx_productName = "productName"
        case  hx_reLoanStatus = "userType"
    }
}
