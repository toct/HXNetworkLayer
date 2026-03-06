public class EchoMapOutModel: Codable {
    public var hx_cardNo: String?
    public var hx_firstName: String?
    public var hx_lastName: String?
    public var hx_middleName: String?
    public var hx_name: String?
    public var hx_willExecuteStepNumber: String?

    enum CodingKeys: String, CodingKey {
        case hx_cardNo = "cardNo"
        case hx_firstName = "firstName"
        case hx_lastName = "lastName"
        case hx_middleName = "middleName"
        case hx_name = "name"
        case hx_willExecuteStepNumber = "willExecuteStepNumber"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_cardNo = try container.decodeIfPresent(String.self, forKey: .hx_cardNo)
        self.hx_firstName = try container.decodeIfPresent(String.self, forKey: .hx_firstName)
        self.hx_lastName = try container.decodeIfPresent(String.self, forKey: .hx_lastName)
        self.hx_middleName = try container.decodeIfPresent(String.self, forKey: .hx_middleName)
        self.hx_name = try container.decodeIfPresent(String.self, forKey: .hx_name)
        self.hx_willExecuteStepNumber = try container.decodeIfPresent(String.self, forKey: .hx_willExecuteStepNumber)
        
        hx_setupProperties()
    }
    
    private func hx_setupProperties() {
        if let hx_value = hx_willExecuteStepNumber {
            hx_willExecuteStepNumber = ["1":"personal","2":"work_questionnaire","3":"urgent_contact","4":"identity_liveness"][hx_value]
        }
    }
}
