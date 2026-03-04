
class PayOutModel: Codable {
    var hx_connect: String?
    var hx_connectType: String?
    enum CodingKeys:String, CodingKey {
        case hx_connect = "connect"
        case hx_connectType = "connectType"
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_connect = try container.decodeIfPresent(String.self, forKey: .hx_connect)
        if let hx_value = try? container.decode(String.self, forKey: .hx_connectType) {
           self.hx_connectType = hx_value
       } else if let hx_value = try? container.decode(Int.self, forKey: .hx_connectType) {
           self.hx_connectType = String(hx_value)
       }
    }
}
