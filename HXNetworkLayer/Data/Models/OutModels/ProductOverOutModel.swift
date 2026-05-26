
public class ProductOverOutModel: Codable {
    public var hx_productId: String?
    public var hx_productLogo: String?
    public var hx_productName: String?
        
    enum CodingKeys:String, CodingKey {
        case hx_productId = "productId"
        case hx_productLogo = "productLogo"
        case hx_productName = "productName"
    }
}
