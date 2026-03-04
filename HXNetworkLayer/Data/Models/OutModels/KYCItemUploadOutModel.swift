
class KYCItemUploadOutModel: Codable {
    var hx_echoMap: EchoMapOutModel?
    enum CodingKeys:String, CodingKey {
        case  hx_echoMap = "echoMap"
    }
}
