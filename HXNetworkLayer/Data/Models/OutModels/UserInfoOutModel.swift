public class UserInfoOutModel: Codable {
    public var  hx_userType: Int?
    public var  hx_desire: Int?
    public var  hx_existsMobileContact: String?
    public var  hx_incomeAmountMonthly: String?
    public var  hx_userName: String? = DeviceInfoInModel.hx_appName()
    public var  hx_cardEditSwitch: String?
    public var  hx_payDay: String?
    public var  hx_phone: String?
    public var  hx_reason: String?
    public var  hx_smsSwitch: String?
    public var  hx_userStatus: Int?

    public var hx_showReloanReason: Bool?
    public var hx_showReloanAgreement: Bool?
    enum CodingKeys: String, CodingKey {
        case  hx_desire = "desire"
        case  hx_userName = "name"
        case  hx_cardEditSwitch = "payAccountModifySwitch"
        case  hx_phone = "phone"
        case  hx_reason = "reason"
        case  hx_smsSwitch = "smsSwitch"
        case  hx_userStatus = "userStatus"
        case  hx_userType = "appUserType"
    }
    
    public required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_desire = try container.decodeIfPresent(Int.self, forKey: .hx_desire)
        self.hx_cardEditSwitch = try container.decodeIfPresent(String.self, forKey: .hx_cardEditSwitch)
        self.hx_phone = try container.decodeIfPresent(String.self, forKey: .hx_phone)
        self.hx_reason = try container.decodeIfPresent(String.self, forKey: .hx_reason)
        self.hx_smsSwitch = try container.decodeIfPresent(String.self, forKey: .hx_smsSwitch)
        self.hx_userStatus = try container.decodeIfPresent(Int.self, forKey: .hx_userStatus)
        self.hx_userType = try container.decodeIfPresent(Int.self, forKey: .hx_userType)
        let hx_value = try container.decodeIfPresent(String.self, forKey: .hx_userName)
        if let data = hx_value, !data.isEmpty {
            self.hx_userName = data
        }
        hx_setupProperties()
    }
    
    func hx_setupProperties() {
        hx_showReloanReason = false
        hx_showReloanAgreement = true
        if let noReloan = hx_reason, noReloan != "0" {
            hx_showReloanReason = true
        }
        
        if let isDesire = hx_desire, isDesire != 0 {
            hx_showReloanAgreement = false
        }
    }
}
