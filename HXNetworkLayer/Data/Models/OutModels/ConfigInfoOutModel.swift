public class ConfigInfoOutModel: Codable {
    public var hx_email: String?
    public var hx_feedbackG: Int?
    public var hx_policyLk: String?
    public var hx_agreeMtLk: String?
    public var hx_officialLk: String?
    public var hx_desireLK: String?
    public var hx_loanLk: String?
    public var hx_feedbackLk: String?
    public var hx_conUsLk: String?
    public var hx_kycLk: String?
    public var hx_editBankLk: String?
    public var hx_pApplyLk: String?
    public var hx_oDetailsLk: String?
    public var hx_applySuccLk: String?
    public var hx_pMaxNum: Int?
    public var hx_pPerNum: Int?
    public var hx_forceRetrieve: Int?
    public var hx_dynamicParame: ConfigSubOutModel?
    public var hx_livenessDetection: String?
    enum CodingKeys:String, CodingKey {
        case hx_policyLk = "policyHref"
        case hx_agreeMtLk = "agreementHref"
        case hx_email = "appEmail"
        case hx_officialLk = "officialWebsiteUrl"
        case hx_pMaxNum = "pushMaxCount"
        case hx_pPerNum = "pushPerCount"
        case hx_forceRetrieve = "retrieveMobileContact"
        case hx_feedbackG = "feedbackGuidance"
        case hx_desireLK = "desireHref"
        case hx_loanLk = "conditionsHref"
        case hx_conUsLk = "contactHref"
        case hx_feedbackLk = "problemFeedbackLink"
        case hx_kycLk = "kycLink"
        case hx_editBankLk = "updateBankLink"
        case hx_pApplyLk = "productApplyLink"
        case hx_oDetailsLk = "orderDetailsLink"
        case hx_applySuccLk = "applicationSuccessLink"
        case hx_dynamicParame = "dynamicParameter"
        case hx_livenessDetection = "livenessDetectionMethod"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_policyLk = try container.decodeIfPresent(String.self, forKey: .hx_policyLk)
        self.hx_agreeMtLk = try container.decodeIfPresent(String.self, forKey: .hx_agreeMtLk)
        self.hx_email = try container.decodeIfPresent(String.self, forKey: .hx_email)
        self.hx_officialLk = try container.decodeIfPresent(String.self, forKey: .hx_officialLk)
        self.hx_pMaxNum = try container.decodeIfPresent(Int.self, forKey: .hx_pMaxNum)
        self.hx_pPerNum = try container.decodeIfPresent(Int.self, forKey: .hx_pPerNum)
        self.hx_forceRetrieve = try container.decodeIfPresent(Int.self, forKey: .hx_forceRetrieve)
        self.hx_feedbackG = try container.decodeIfPresent(Int.self, forKey: .hx_feedbackG)
        self.hx_desireLK = try container.decodeIfPresent(String.self, forKey: .hx_desireLK)
        self.hx_loanLk = try container.decodeIfPresent(String.self, forKey: .hx_loanLk)
        self.hx_conUsLk = try container.decodeIfPresent(String.self, forKey: .hx_conUsLk)
        self.hx_feedbackLk = try container.decodeIfPresent(String.self, forKey: .hx_feedbackLk)
        self.hx_kycLk = try container.decodeIfPresent(String.self, forKey: .hx_kycLk)
        self.hx_editBankLk = try container.decodeIfPresent(String.self, forKey: .hx_editBankLk)
        self.hx_pApplyLk = try container.decodeIfPresent(String.self, forKey: .hx_pApplyLk)
        self.hx_oDetailsLk = try container.decodeIfPresent(String.self, forKey: .hx_oDetailsLk)
        self.hx_applySuccLk = try container.decodeIfPresent(String.self, forKey: .hx_applySuccLk)
        self.hx_dynamicParame = try container.decodeIfPresent(ConfigSubOutModel.self, forKey: .hx_dynamicParame)
        self.hx_livenessDetection = try container.decodeIfPresent(String.self, forKey: .hx_livenessDetection)
    }
    
}

public class ConfigSubOutModel: Codable {
    public var hx_fjtip: String?
    public var hx_contactCount: String?
    public var hx_customerH5: String?
    enum CodingKeys:String, CodingKey {
        case hx_fjtip = "fjtip"
        case hx_contactCount = "contactCount"
        case hx_customerH5 = "CustomerH5"
    }
    
//    required init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.hx_fjtip = "on"
//        self.hx_contactCount = "10"
//        self.hx_invite_url = try container.decodeIfPresent(String.self, forKey: .hx_invite_url)
//        self.hx_invite_switch = try container.decodeIfPresent(String.self, forKey: .hx_invite_switch)
//        self.hx_AIService = try container.decodeIfPresent(String.self, forKey: .hx_AIService)
//    }
    // home page or user page
}
