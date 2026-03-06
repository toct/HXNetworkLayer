
public class LoginOutModel: Codable {
    public var hx_token: String?
    public var hx_userId: String?
    enum CodingKeys:String, CodingKey {
        case hx_token = "token"
        case hx_userId = "userId"
    }
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_token = try container.decodeIfPresent(String.self, forKey: .hx_token)
        self.hx_userId = try container.decodeIfPresent(String.self, forKey: .hx_userId)
        
        hx_setupProperties()
    }
    public init(){}
    
    private func hx_setupProperties() {
        if isLogin() {
            SharedModel.hx_submitAdid()
        }
    }
    public func isLogin() ->Bool {
        if let uid = hx_userId, let token = hx_token, !uid.isEmpty && !token.isEmpty {
            return true
        }
        return false
    }
}
