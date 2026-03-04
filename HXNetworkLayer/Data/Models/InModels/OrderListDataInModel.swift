import Foundation

class OrderListDataInModel: NSObject, Codable {
    var hx_orderStatus: String?
    enum CodingKeys: String, CodingKey {
        case hx_orderStatus = "orderStatus"
    }
    
    func hx_execute( closer: @escaping ((OrdersOutModel?) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_getOrderListData_url).params(hx_dict).callback({_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType:OrdersOutModel.self)
                    closer(hx_data)
                }
            }
        }).request()
    }
}
