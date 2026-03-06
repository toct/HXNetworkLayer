
public class OrderInfoOutModel: Codable  {
    public var hx_alreadyRepayed: String?
    public var hx_applyTime: String?
    public var hx_dueTime: String?
    public var hx_extensionFee: String?
    public var hx_perMonthRepay: String?
    public var hx_termNum: Int?
    public var hx_feeAmount: String?
    public var hx_isExtensionAbled: String?
    public var hx_interestAmo: String?
    public var hx_loanAmount: String?
    public var hx_loanTerm: Int?
    public var hx_loanTermUni: Int?
    public var hx_oId: String
    public var hx_oStatus: Int?
    public var hx_payoutTime: String?
    public var hx_penaltyAmo: String?
    public var hx_penaltyDays: Int
    public var hx_productTermDetail: [TermDetailOutModel]?
    public var hx_receiptAmount: String?
    public var hx_reductionAmo: String?
    public var hx_extensionFeeAmo: String?
    public var hx_repaymentTime: String?
    public var hx_riskTime: String?
    public var hx_remainRepayAmo: String?
    public var hx_showTerm: Int?
    public var hx_taxAmount: String?
    public var hx_totalRepayAmo: String?
    public var hx_content: String?
    enum CodingKeys:String, CodingKey {
        case hx_alreadyRepayed = "alreadyRepaymentAmount"
        case hx_applyTime = "applyDate"
        case hx_dueTime = "dueDate"
        case hx_extensionFee = "dueExtensionFeeAmount"
        case hx_perMonthRepay = "emiAmount"
        case hx_termNum = "emiTenure"
        case hx_feeAmount = "feeAmount"
        case hx_isExtensionAbled = "ifExtension"
        case hx_interestAmo = "interestAmount"
        case hx_loanAmount = "loanAmount"
        case hx_loanTerm = "loanTerm"
        case hx_loanTermUni = "loanTermUnit"
        case hx_oId = "orderId"
        case hx_oStatus = "orderStatus"
        case hx_payoutTime = "payoutDate"
        case hx_penaltyAmo = "penaltyAmount"
        case hx_penaltyDays = "penaltyDays"
        case hx_productTermDetail = "productTermItemList"
        case hx_receiptAmount = "receiptAmount"
        case hx_reductionAmo = "reductionAmount"
        case hx_extensionFeeAmo = "repayExtensionFeeAmount"
        case hx_repaymentTime = "repaymentDate"
        case hx_riskTime = "riskDate"
        case hx_remainRepayAmo = "shouldRepaymentAmount"
        case hx_showTerm = "showTerm"
        case hx_taxAmount = "taxAmount"
        case hx_totalRepayAmo = "totalRepaymentAmount"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_alreadyRepayed = try container.decodeIfPresent(String.self, forKey: .hx_alreadyRepayed)
        self.hx_applyTime = try container.decodeIfPresent(String.self, forKey: .hx_applyTime)
        self.hx_dueTime = try container.decodeIfPresent(String.self, forKey: .hx_dueTime)
        self.hx_extensionFee = try container.decodeIfPresent(String.self, forKey: .hx_extensionFee)
        self.hx_perMonthRepay = try container.decodeIfPresent(String.self, forKey: .hx_perMonthRepay)
        self.hx_termNum = try container.decodeIfPresent(Int.self, forKey: .hx_termNum)
        self.hx_feeAmount = try container.decodeIfPresent(String.self, forKey: .hx_feeAmount)
        self.hx_isExtensionAbled = try container.decodeIfPresent(String.self, forKey: .hx_isExtensionAbled)
        self.hx_interestAmo = try container.decodeIfPresent(String.self, forKey: .hx_interestAmo)
        self.hx_loanAmount = try container.decodeIfPresent(String.self, forKey: .hx_loanAmount)
        self.hx_loanTerm = try container.decodeIfPresent(Int.self, forKey: .hx_loanTerm)
        self.hx_loanTermUni = try container.decodeIfPresent(Int.self, forKey: .hx_loanTermUni)
        self.hx_oId = try container.decode(String.self, forKey: .hx_oId)
        self.hx_oStatus = try container.decodeIfPresent(Int.self, forKey: .hx_oStatus)
        self.hx_payoutTime = try container.decodeIfPresent(String.self, forKey: .hx_payoutTime)
        self.hx_penaltyAmo = try container.decodeIfPresent(String.self, forKey: .hx_penaltyAmo)
        self.hx_penaltyDays = try container.decode(Int.self, forKey: .hx_penaltyDays)
        self.hx_productTermDetail = try container.decodeIfPresent([TermDetailOutModel].self, forKey: .hx_productTermDetail)
        self.hx_receiptAmount = try container.decodeIfPresent(String.self, forKey: .hx_receiptAmount)
        self.hx_reductionAmo = try container.decodeIfPresent(String.self, forKey: .hx_reductionAmo)
        self.hx_extensionFeeAmo = try container.decodeIfPresent(String.self, forKey: .hx_extensionFeeAmo)
        self.hx_repaymentTime = try container.decodeIfPresent(String.self, forKey: .hx_repaymentTime)
        self.hx_riskTime = try container.decodeIfPresent(String.self, forKey: .hx_riskTime)
        self.hx_remainRepayAmo = try container.decodeIfPresent(String.self, forKey: .hx_remainRepayAmo)
        self.hx_showTerm = try container.decodeIfPresent(Int.self, forKey: .hx_showTerm)
        self.hx_taxAmount = try container.decodeIfPresent(String.self, forKey: .hx_taxAmount)
        self.hx_totalRepayAmo = try container.decodeIfPresent(String.self, forKey: .hx_totalRepayAmo)
        hx_setupProperties()
    }
    
    func hx_setupProperties() {
        if let hx_value = hx_reductionAmo, !hx_value.isEmpty {
            hx_reductionAmo = "-" + hx_value
        } else {
            hx_reductionAmo = nil
        }
        if let hx_value = hx_alreadyRepayed, !hx_value.isEmpty {
            hx_alreadyRepayed = "-" + hx_value
        } else {
            hx_reductionAmo = nil
        }
        if let hx_value = hx_taxAmount, !hx_value.isEmpty {
            hx_taxAmount = "-" + hx_value
        } else {
            hx_reductionAmo = nil
        }
        if let hx_value = hx_remainRepayAmo, let hx_intValue = Int(hx_value), hx_intValue < 0 {
            hx_remainRepayAmo = "0"
        }
    }
}
