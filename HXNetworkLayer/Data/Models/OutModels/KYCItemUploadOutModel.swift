
public class KYCItemUploadOutModel: Codable {
    public var hx_echoMap: EchoMapOutModel?
    enum CodingKeys:String, CodingKey {
        case  hx_echoMap = "echoMap"
    }
}
