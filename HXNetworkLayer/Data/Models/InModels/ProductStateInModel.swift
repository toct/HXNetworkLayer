import Foundation
public class ProductStateInModel: NSObject, Codable {
    public var hx_productId: String?

    enum CodingKeys: String, CodingKey {
        case hx_productId = "productId"
    }
    
    public func hx_execute( closer: @escaping ((ProductStatusOutModel?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_checkproductsState_url).params(hx_dict).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: StatusesOutModel.self)
                    if let reLoanProduct = hx_data?.hx_pStatusArr?.filter({ $0.hx_reLoanStatus == 2 }).first {
                        closer(reLoanProduct)
                        return
                    }
                }
            }
            closer(nil)
        }).request()
    }
}
