
import Combine
class ProductDetailOutModel: Codable, ObservableObject {

    var hx_cardArr: [CardDetailOutModel]?
    var hx_amountOptions: [AmountOutModel]?
    var hx_message: String?
    var hx_conntent: String?
    var hx_hotline: String?
    var hx_productId: String?
    var hx_orderId: String?
    var hx_productLogo: String?
    var hx_productName: String?
    var hx_pTermUnit: Int?
    var hx_isOrderData = false
    var hx_orderType:String?
    var hx_oStatus: Int = 0

    @Published var hx_selectAmountIndex: Int? {
        didSet{
            hx_selectAmountAndTerm()
        }
    }
    @Published var hx_selectTermIndex: Int?{
        didSet{
            hx_selectAmountAndTerm()
        }
    }
    @Published var hx_selectAmount: Int?
    @Published var hx_selectTerm: Int?
    enum CodingKeys:String, CodingKey {
        case hx_amountOptions = "amountDetailList"
        case hx_cardArr = "bankCardList"
        case hx_message = "message"
        case hx_hotline = "productHotline"
        case hx_productId = "productId"
        case hx_orderId = "orderId"
        case hx_productLogo = "productLogo"
        case hx_productName = "productName"
        case hx_pTermUnit = "productTermUnit"
    }
    
    init() {}
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_amountOptions = try container.decodeIfPresent([AmountOutModel].self, forKey: .hx_amountOptions)
        self.hx_cardArr = try container.decodeIfPresent([CardDetailOutModel].self, forKey: .hx_cardArr)
        self.hx_message = try container.decodeIfPresent(String.self, forKey: .hx_message)
        self.hx_hotline = try container.decodeIfPresent(String.self, forKey: .hx_hotline)
        self.hx_productId = try container.decodeIfPresent(String.self, forKey: .hx_productId)
        self.hx_orderId = try container.decodeIfPresent(String.self, forKey: .hx_orderId)
        self.hx_productLogo = try container.decodeIfPresent(String.self, forKey: .hx_productLogo)
        self.hx_productName = try container.decodeIfPresent(String.self, forKey: .hx_productName)
        self.hx_pTermUnit = try container.decodeIfPresent(Int.self, forKey: .hx_pTermUnit)
        self.hx_conntent = hx_commonDoc("p26")
        hx_setupProperties()
    }
    
    func hx_setupProperties() {
        
        guard let hx_amounts = hx_amountOptions else { return }
        
        var hx_maxIndex = -1
        var hx_amountMax = -1
        
        hx_amounts.enumerated().forEach { index, item in
            if let amountStr = item.hx_loanAmount, let amount = Int(amountStr){
                if hx_amountMax < amount {
                    hx_amountMax = amount
                    hx_maxIndex = index
                }
            }
        }
        if hx_amountMax == -1 {
            return
        }
        hx_selectAmountIndex = hx_maxIndex
        hx_selectAmount = hx_amountMax
        
        if let hx_terms = hx_amounts[hx_maxIndex].hx_termOptions {
            var hx_minIndex = -1
            var hx_termMin = Int.max
            
            hx_terms.enumerated().forEach { index, item in
                if let term = item.hx_loanTerm {
                    if hx_termMin > term {
                        hx_termMin = term
                        hx_minIndex = index
                    }
                }
            }
            if hx_minIndex == -1 {
                return
            }
            hx_selectTermIndex = hx_minIndex
            hx_selectTerm = hx_termMin
        }
    }
        
    func hx_selectAmountAndTerm() {
        if let index = hx_selectAmountIndex, let amounts = hx_amountOptions, amounts.count > index {
            hx_selectAmount = Int(amounts[index].hx_loanAmount ?? "")
            let terms = amounts[index].hx_termOptions
            
            if let index = hx_selectTermIndex, let termcount = terms?.count, termcount > index {
                if let term = terms?[index].hx_loanTerm {
                    hx_selectTerm = term
                }
            }
        }
    }
    
    func hx_RepayPlans() -> [TermDetailOutModel]? {
        
        if let amountIndex = hx_selectAmountIndex, let termIndex = hx_selectTermIndex, let amounts = hx_amountOptions, amounts.count > amountIndex ,let termOption = amounts[amountIndex].hx_termOptions, termOption.count > termIndex, let termItems = termOption[termIndex].hx_pTermItems {
            return termItems
        }
        return nil
    }
    
    func hx_loanTerms() -> [TermOutModel]? {
        guard let amountIndex = hx_selectAmountIndex, let amounts = hx_amountOptions, amounts.count > amountIndex ,let termOption = amounts[amountIndex].hx_termOptions else {
            return nil
        }
        return termOption
    }
}
