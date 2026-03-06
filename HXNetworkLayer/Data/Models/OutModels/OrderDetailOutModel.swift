
import Combine
public class OrderDetailOutModel: Codable, ObservableObject {
    public var hx_bankCard: CardDetailOutModel?
    public var hx_isWillingRepay: Int?
    public var hx_orderDetail: OrderInfoOutModel?
    public var hx_product: ProductOverOutModel?
    public var hx_message : String?
    @Published public var hx_productModel: ProductDetailOutModel?
    enum CodingKeys:String, CodingKey {
        case hx_bankCard = "bankCard"
        case hx_isWillingRepay = "isWillingRepay"
        case hx_orderDetail = "orderDetail"
        case hx_product = "product"
        case hx_message = "message"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_bankCard = try container.decodeIfPresent(CardDetailOutModel.self, forKey: .hx_bankCard)
        self.hx_isWillingRepay = try container.decodeIfPresent(Int.self, forKey: .hx_isWillingRepay)
        self.hx_orderDetail = try container.decodeIfPresent(OrderInfoOutModel.self, forKey: .hx_orderDetail)
        self.hx_product = try container.decodeIfPresent(ProductOverOutModel.self, forKey: .hx_product)
        self.hx_message = try container.decodeIfPresent(String.self, forKey: .hx_message)
        
        hx_setupProperties()
    }
    public init() {}
    
    func hx_setupProperties() {
        
        let hx_term = TermOutModel()
        hx_term.hx_arrivalAm = hx_orderDetail?.hx_receiptAmount
        hx_term.hx_borrowingDate = hx_orderDetail?.hx_applyTime
        hx_term.hx_feeAmount = "-" + (hx_orderDetail?.hx_feeAmount ?? "")
        hx_term.hx_pTermItems = hx_orderDetail?.hx_productTermDetail
        hx_term.hx_interestAm = hx_orderDetail?.hx_interestAmo
        hx_term.hx_showTerm = hx_orderDetail?.hx_showTerm
        hx_term.hx_taxAmount = hx_orderDetail?.hx_taxAmount
        hx_term.hx_totalRepayAmo = hx_orderDetail?.hx_totalRepayAmo
        hx_term.hx_reductionAmo = hx_orderDetail?.hx_reductionAmo
        hx_term.hx_alreadyRepayed = hx_orderDetail?.hx_alreadyRepayed
        hx_term.hx_remainRepayAmo = hx_orderDetail?.hx_remainRepayAmo
        hx_term.hx_penaltyAmo = hx_orderDetail?.hx_penaltyAmo
        hx_term.hx_oId = hx_orderDetail?.hx_oId
        hx_term.hx_loanTerm = hx_orderDetail?.hx_loanTerm
        hx_term.hx_isExtensionAbled = hx_orderDetail?.hx_isExtensionAbled
        hx_term.hx_repaymentTime = hx_orderDetail?.hx_repaymentTime
        hx_term.hx_exFeeAm = hx_orderDetail?.hx_extensionFee
        hx_term.hx_payoutTime = hx_orderDetail?.hx_payoutTime
        hx_term.hx_dueTime = "-"
        if let value = hx_orderDetail?.hx_dueTime, !value.isEmpty {
            hx_term.hx_dueTime = value
        }
        
        let hx_amount = AmountOutModel()
        hx_amount.hx_loanAmount = hx_orderDetail?.hx_loanAmount
        hx_amount.hx_termOptions = [hx_term]
        
        let hx_model = ProductDetailOutModel()
        hx_model.hx_isOrderData = true
        if let hx_bank = hx_bankCard {
            hx_model.hx_cardArr = [hx_bank]
        }
        hx_model.hx_oStatus = hx_orderDetail?.hx_oStatus ?? 0
        hx_model.hx_message = hx_message
        hx_model.hx_productId = hx_product?.hx_productId
        hx_model.hx_orderId = hx_orderDetail?.hx_oId
        hx_model.hx_productLogo = hx_product?.hx_productLogo
        hx_model.hx_productName = hx_product?.hx_productName
        hx_model.hx_amountOptions = [hx_amount]
        hx_model.hx_conntent = hx_orderDetail?.hx_content
        hx_model.hx_setupProperties()
        hx_productModel = hx_model
    }
}
