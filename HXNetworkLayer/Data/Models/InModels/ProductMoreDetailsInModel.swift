import Foundation

public class ProductDetailInModel: NSObject, Codable {
    public var hx_productId: String?
    enum CodingKeys: String, CodingKey {
        case hx_productId = "productId"
    }
    
    public func hx_execute( closer: @escaping ((Int?, Any?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        
        NetworkTool().url(hx_term_url).params(hx_dict, signedKeys: ["productId"]).callback({hx_code, success, hx_data in
            var value: Any
            value = hx_data
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    value = JsonKit.hx_jsonToModel(hx_dict, modelType: ProductDetailOutModel.self) as Any
                }
            }
            closer(hx_code, value)
        }).request()
    }
}
