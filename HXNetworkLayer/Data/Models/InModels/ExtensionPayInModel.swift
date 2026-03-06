import Foundation

public class ExtensionPayInModel: NSObject, Codable {
    public var hx_isPay = false
    public var hx_orderId: String?
    public var hx_payAccountNumber: String?
    public var hx_periodNoList = ["1"]
    enum CodingKeys: String, CodingKey {
        case hx_orderId = "orderId"
        case hx_payAccountNumber = "payAccountNumber"
        case hx_periodNoList = "periodNoList"
    }
    
    public func hx_execute(closer: @escaping ((PayOutModel?)->Void)) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        NetworkTool().url(hx_isPay ? hx_repay_rul : hx_extension_rul ).params(hx_dict, signedKeys: ["orderId"]).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: PayOutModel.self)
                    closer(hx_data)
                }
            }else{
                closer(nil)
            }
        }).request()
    }
}
