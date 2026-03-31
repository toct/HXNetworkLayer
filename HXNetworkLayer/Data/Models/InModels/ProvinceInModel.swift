import Foundation

class ProvinceInModel: NSObject, Codable {
    var hx_countryId: String = hx_contryId
    enum CodingKeys: String, CodingKey {
        case hx_countryId = "countryId"
    }
    
    func hx_execute(_ closer: @escaping (([OptionOutModel]?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_province).params(hx_dict, signedKeys: ["countryId"]).callback { code, success, data in
            if success {
                if let hx_dict = data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: AddressAssetsOutModel.self)
                    closer(hx_data?.hx_addressList)
                }
            } else {
                closer(nil)
            }
        }.request()
    }
}
