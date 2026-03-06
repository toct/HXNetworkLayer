
public class ContactKYCOutModel: Codable {
    var  hx_kycId: String
    public var  hx_kycItemList: [FormCellOutModel]
    var  hx_kycType: String
    
    enum CodingKeys:String, CodingKey {
        
        case  hx_kycId = "kycId"
        case  hx_kycItemList = "kycItemList"
        case  hx_kycType = "kycType"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_kycId = try container.decode(String.self, forKey: .hx_kycId)
        let hx_values = try container.decode([FormCellOutModel].self, forKey: .hx_kycItemList)
        self.hx_kycItemList = hx_values.sorted(by: { $0.hx_opionsSort < $1.hx_opionsSort })
        self.hx_kycType = try container.decode(String.self, forKey: .hx_kycType)
    }
}
