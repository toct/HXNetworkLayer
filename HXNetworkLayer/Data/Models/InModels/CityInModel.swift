import Foundation

class CityInModel: NSObject, Codable {
    var hx_countryId: String = hx_contryId
    var hx_provinceId: String?
    
    enum CodingKeys: String, CodingKey {
        case hx_countryId = "countryId"
        case hx_provinceId = "provinceId"
    }
    
    func hx_execute( closer: @escaping (([OptionOutModel]?)->())) {
        
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        
        NetworkTool().url(hx_city).params(hx_dict, signedKeys: ["countryId","provinceId"]).callback{ code, success, data in
            if success {
                if let hx_dict = data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: AddressAssetsOutModel.self)
                    closer(hx_data?.hx_addressList)
                }
            }else{
                closer(nil)
            }
        }.request()
    }
}
