// MARK: - DataClass
class AddressAssetsOutModel: Codable  {
    var hx_addressList: [OptionOutModel]?
    private var hx_cityList: [OptionOutModel]?
    enum CodingKeys:String, CodingKey {
        case  hx_cityList = "cityList"
        case  hx_addressList = "provinceList"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_addressList = try? container.decode([OptionOutModel].self, forKey: .hx_addressList)
        self.hx_cityList = try? container.decode([OptionOutModel].self, forKey: .hx_cityList)
        
        if let list = self.hx_cityList, !list.isEmpty {
            self.hx_addressList = list
        }
    }
}
