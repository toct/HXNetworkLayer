import Foundation

class OrderReadyInModel: NSObject, Codable {
    var hx_orderId: String?
    var hx_allowContact: String?

    enum CodingKeys: String, CodingKey {
        case hx_orderId = "orderId"
        case hx_allowContact = "allowContact"
    }
    
    func hx_execute( closer: @escaping ((Bool)->Void)) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_orderReady_url).params(hx_dict, signedKeys: ["orderId"]).callback({ _, success, _ in
            closer(success)
        }).request()
    }
}
