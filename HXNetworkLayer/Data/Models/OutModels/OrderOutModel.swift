public class OrderOutModel: Codable, Identifiable, Equatable{
    public var id = UUID()
    public var hx_applyTime: String?
    public var hx_dueTime: String?
    public var hx_loanAmount: String?
    public var hx_loanTime: String?
    public var hx_o_id: String?
    public var hx_orderStatus: Int?
    public var hx_p_id: String?
    public var hx_productName: String?
    public var hx_repayTime: String?
    public var hx_accountNo: String?

    enum CodingKeys:String, CodingKey {
        case hx_applyTime = "applyDate"
        case hx_dueTime = "dueDate"
        case hx_loanAmount = "loanAmount"
        case hx_loanTime = "loanDate"
        case hx_o_id = "orderId"
        case hx_orderStatus = "orderStatus"
        case hx_p_id = "productId"
        case hx_productName = "productName"
        case hx_repayTime = "repayDate"
    }
    public init(){}
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_applyTime = try container.decodeIfPresent(String.self, forKey: .hx_applyTime)
        self.hx_dueTime = try container.decodeIfPresent(String.self, forKey: .hx_dueTime)
        self.hx_loanAmount = try container.decodeIfPresent(String.self, forKey: .hx_loanAmount)
        self.hx_loanTime = try container.decodeIfPresent(String.self, forKey: .hx_loanTime)
        self.hx_o_id = try container.decodeIfPresent(String.self, forKey: .hx_o_id)
        self.hx_orderStatus = try container.decodeIfPresent(Int.self, forKey: .hx_orderStatus)
        self.hx_p_id = try container.decodeIfPresent(String.self, forKey: .hx_p_id)
        self.hx_productName = try container.decodeIfPresent(String.self, forKey: .hx_productName)
        self.hx_repayTime = try container.decodeIfPresent(String.self, forKey: .hx_repayTime)
    }
    public static func == (lhs: OrderOutModel, rhs: OrderOutModel) -> Bool {
        return lhs.id == rhs.id
    }
}


