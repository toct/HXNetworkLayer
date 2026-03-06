import Foundation

public class ProductApplyInModel: NSObject, Codable {
    public var hx_productId: String?
    public var hx_loanAmount: String?
    public var hx_bankCardBindId: String?
    public var hx_longitude: String?
    public var hx_latitude: String?
    public var hx_imei: String? = "null"
    public var hx_serialNo: String? = AmountOutModel.hx_UUID()
    public var hx_loanTerm: String?
    public var hx_orderType: String?
    enum CodingKeys: String, CodingKey {
        case hx_productId = "productId"
        case hx_loanAmount = "loanAmount"
        case hx_bankCardBindId = "bankCardBindId"
        case hx_longitude = "longitude"
        case hx_latitude = "latitude"
        case hx_imei = "imei"
        case hx_serialNo = "serialNo"
        case hx_orderType = "orderType"
        case hx_loanTerm = "loanTerm"
    }
    
    public init(_ hx_data: ProductDetailOutModel?) {
        hx_productId = hx_data?.hx_productId
        hx_loanTerm = hx_data?.hx_selectTerm.map { String($0) }
        hx_loanAmount = hx_data?.hx_selectAmount.map { String($0) }
        hx_bankCardBindId = hx_data?.hx_cardArr?.first?.hx_bindId
        hx_orderType = hx_data?.hx_orderType
    }
    
    public func hx_execute( closer: @escaping ((ApplyResultOutModel?) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        let signedKeys = ["productId","loanAmount","bankCardBindId","longitude","latitude","imei","serialNo"]
        NetworkTool().url(hx_productApply_url).params(hx_dict, signedKeys: signedKeys).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ApplyResultOutModel.self)
                    closer(hx_data)
                }
            } else {
                closer(nil)
            }
        }).request()
    }
}
