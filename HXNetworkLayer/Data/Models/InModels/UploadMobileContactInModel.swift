import Foundation
class UploadMobileContactInModel: NSObject, Codable {
    var hx_list: [ContactInModel]?
    var hx_orderId: String?

    enum CodingKeys: String, CodingKey {
        case hx_list = "list"
        case hx_orderId = "orderId"
    }
    
    func hx_execute( closer: @escaping ((Bool)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        NetworkTool().url(hx_uploadMobileContact_url).params(hx_dict, signedKeys: ["orderId"]).callback { _, success, _ in
            closer(success)
        }.request()
    }
}
