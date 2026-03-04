class ProductOutModel: Codable, Equatable {
    static func == (lhs: ProductOutModel, rhs: ProductOutModel) -> Bool {
        return lhs.hx_productLogo == rhs.hx_productLogo &&
               lhs.hx_productId == rhs.hx_productId &&
               lhs.hx_productName == rhs.hx_productName
    }
    var hx_highAmount: String?
    var hx_highestTerm: String?
    var hx_defaultLoanTerm: Int?
    var hx_lowAmount: String?
    var hx_lowestLoanInterestRate: String?
    var hx_productId: String?
    var hx_productLabel: String?
    var hx_productLogo: String?
    var hx_productName: String?
    
    var hx_showAmo: String?
    var hx_showRate: String?
    var hx_selected: Bool?
    
    enum CodingKeys:String, CodingKey {
        case hx_highAmount = "highAmount"
        case hx_highestTerm = "highestTerm"
        case hx_lowAmount = "lowAmount"
        case hx_lowestLoanInterestRate = "lowestLoanInterestRate"
        case hx_productId = "productId"
        case hx_productLabel = "productLabel"
        case hx_productLogo = "productLogo"
        case hx_productName = "productName"
        case hx_defaultLoanTerm = "defaultLoanTerm"
        
    }
    init(){}
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_highAmount = try container.decodeIfPresent(String.self, forKey: .hx_highAmount)
        self.hx_highestTerm = try container.decodeIfPresent(String.self, forKey: .hx_highestTerm)
        self.hx_lowAmount = try container.decodeIfPresent(String.self, forKey: .hx_lowAmount)
        self.hx_lowestLoanInterestRate = try container.decodeIfPresent(String.self, forKey: .hx_lowestLoanInterestRate)
        self.hx_productId = try container.decodeIfPresent(String.self, forKey: .hx_productId)
        self.hx_productLabel = try container.decodeIfPresent(String.self, forKey: .hx_productLabel)
        self.hx_productLogo = try container.decodeIfPresent(String.self, forKey: .hx_productLogo)
        self.hx_productName = try container.decodeIfPresent(String.self, forKey: .hx_productName)
        self.hx_defaultLoanTerm = try container.decodeIfPresent(Int.self, forKey: .hx_defaultLoanTerm)

        hx_setupProperties()
    }
    
    func hx_setupProperties(){
        if let hx_lowA = hx_lowAmount?.hx_numberFormat() {
            if let hx_heighA = hx_highAmount?.hx_numberFormat() {
                hx_showAmo = "฿" + hx_lowA + " ~ B" + hx_heighA
            }else{
                hx_showAmo = "฿" + hx_lowA
            }
        }else{
            if let hx_heighA = hx_highAmount?.hx_numberFormat()  {
                hx_showAmo = "฿" + hx_heighA
            }
        }
        
        if let hx_rateStr = hx_lowestLoanInterestRate, let hx_rate = Double(hx_rateStr) {
            let hx_percentRate = hx_rate * 100.0
            hx_showRate = String(format: "%.2f", hx_percentRate) + "%"
        }
    }
}
