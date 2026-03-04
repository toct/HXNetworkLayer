
// MARK: - DataClass
class WalletListOutModel: Codable {
    /// 电子钱包列表
    var hx_walletList: [OptionOutModel]?
    private let hx_bankList: [OptionOutModel]?

    enum CodingKeys:String, CodingKey {
        case  hx_walletList = "walletList"
        case  hx_bankList = "bankList"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_walletList = try container.decodeIfPresent([OptionOutModel].self, forKey: .hx_walletList)
        self.hx_bankList = try container.decodeIfPresent([OptionOutModel].self, forKey: .hx_bankList)
        
        if self.hx_walletList == nil {
            self.hx_walletList = hx_bankList
        }
    }
}


