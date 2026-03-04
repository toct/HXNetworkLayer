class TermOutModel: Codable {
    var  hx_arrivalAm: String?
    var  hx_borrowingDate: String?
    var  hx_emiAm: String?
    var  hx_emiTen: Int?
    var  hx_feeAmount: String?
    var  hx_interestAm: String?
    var  hx_loanTerm: Int?
    var  hx_pTermItems: [TermDetailOutModel]?
    var  hx_pTermUnit: Int?
    var  hx_repaymentAm: String?
    var  hx_repaymentTime: String?
    var  hx_showTerm: Int?
    var  hx_taxAmount: String?
    
    var  hx_dueTime: String?
    var  hx_totalRepayAmo: String?
    var  hx_reductionAmo: String?
    var  hx_alreadyRepayed: String?
    var  hx_remainRepayAmo: String?
    var  hx_penaltyAmo: String?
    var  hx_oId: String?
    var  hx_isExtensionAbled: String?
    var  hx_payoutTime: String?
    var  hx_exFeeAm: String?
    
    enum CodingKeys:String, CodingKey {
        case  hx_arrivalAm = "arrivalAmount"
        case  hx_borrowingDate = "borrowingDate"
        case  hx_emiAm = "emiAmount"
        case  hx_emiTen = "emiTenure"
        case  hx_feeAmount = "feeAmount"
        case  hx_interestAm = "interestAmount"
        case  hx_loanTerm = "loanTerm"
        case  hx_pTermItems = "productTermItemList"
        case  hx_pTermUnit = "productTermUnit"
        case  hx_repaymentAm = "repaymentAmount"
        case  hx_repaymentTime = "repaymentDate"
        case  hx_showTerm = "showTerm"
        case  hx_taxAmount = "taxAmount"
        case  hx_exFeeAm = "dueExtensionFeeAmount"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_arrivalAm = try container.decodeIfPresent(String.self, forKey: .hx_arrivalAm)
        self.hx_borrowingDate = try container.decodeIfPresent(String.self, forKey: .hx_borrowingDate)
        self.hx_emiAm = try container.decodeIfPresent(String.self, forKey: .hx_emiAm)
        self.hx_emiTen = try container.decodeIfPresent(Int.self, forKey: .hx_emiTen)
        self.hx_feeAmount = try container.decodeIfPresent(String.self, forKey: .hx_feeAmount)
        self.hx_interestAm = try container.decodeIfPresent(String.self, forKey: .hx_interestAm)
        self.hx_loanTerm = try container.decodeIfPresent(Int.self, forKey: .hx_loanTerm)
        self.hx_pTermItems = try container.decodeIfPresent([TermDetailOutModel].self, forKey: .hx_pTermItems)
        self.hx_pTermUnit = try container.decodeIfPresent(Int.self, forKey: .hx_pTermUnit)
        self.hx_repaymentAm = try container.decodeIfPresent(String.self, forKey: .hx_repaymentAm)
        self.hx_dueTime = try container.decodeIfPresent(String.self, forKey: .hx_repaymentTime)
        self.hx_showTerm = try container.decodeIfPresent(Int.self, forKey: .hx_showTerm)
        self.hx_taxAmount = try container.decodeIfPresent(String.self, forKey: .hx_taxAmount)
        self.hx_exFeeAm = try container.decodeIfPresent(String.self, forKey: .hx_exFeeAm)
    }
    init() {
    }
}
