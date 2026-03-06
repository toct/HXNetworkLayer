import Foundation

public class KycItemCommitInModel: NSObject, Codable {
    var hx_kycId: String?
    var hx_itemCode: String?
    var hx_itemValue: String?
    var hx_itemValueType: String?

    enum CodingKeys: String, CodingKey {
        case hx_kycId = "kycId"
        case hx_itemCode = "itemCode"
        case hx_itemValue = "itemValue"
        case hx_itemValueType = "itemValueType"
    }
    
    public init(data:FormCellOutModel, hx_id: String) {
        hx_itemCode = data.hx_opionsCode
        hx_itemValue = data.hx_optValue
        hx_itemValueType = data.hx_optType
        hx_kycId = hx_id
    }
    public func hx_execute(closer: @escaping ((Bool, KYCItemUploadOutModel?) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        NetworkTool().url(hx_kycItemCommit_url).params(hx_dict, signedKeys: ["kycId","itemCode","itemValueType","itemValue"]).callback { _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: KYCItemUploadOutModel.self)
                    closer(success ,hx_data)
                }
            }else{
                closer(success, nil)
            }
        }.request()
    }
}
