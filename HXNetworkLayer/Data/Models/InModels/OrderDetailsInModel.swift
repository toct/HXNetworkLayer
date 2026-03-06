import Foundation

public class OrderDetailsInModel: NSObject, Codable {
    public let hx_appType: String = "DC"
    public var hx_orderId: String?
    public var hx_productId: String?

    enum CodingKeys: String, CodingKey {
        case hx_appType = "appType"
        case hx_orderId = "orderId"
        case hx_productId = "productId"
    }
    
    public func hx_execute(closer: @escaping ((OrderDetailOutModel?)->Void)) {

        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        NetworkTool().url(hx_orderDetails_url).params(hx_dict, signedKeys: ["orderId"]).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: OrderDetailOutModel.self)
                    closer(hx_data)
                }
            }
        }).request()
    }
}
