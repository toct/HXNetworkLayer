import Foundation

public class KycDataCommitInModel: NSObject, Codable {
    class CommitItem: NSObject, Codable {
        var hx_itemValueType: String?
        var hx_itemValue: String?
        var hx_itemCode: String?
        enum CodingKeys: String, CodingKey {
            case hx_itemValueType = "itemValueType"
            case hx_itemValue = "itemValue"
            case hx_itemCode = "itemCode"
        }
    }
    
    public var hx_kycId: String?
    var hx_kycCommitItemList: [CommitItem]?

    enum CodingKeys: String, CodingKey {
        case hx_kycId = "kycId"
        case hx_kycCommitItemList = "kycCommitItemList"
    }
    
    public init(data:[FormCellOutModel]) {
        var hx_models: [CommitItem] = []
        for model in data {
            if let _ = model.hx_optType {
                let hx_model = CommitItem()
                hx_model.hx_itemValueType = model.hx_optType
                hx_model.hx_itemValue = model.hx_optValue
                hx_model.hx_itemCode = model.hx_opionsCode
                if model.hx_opionsCode != "confirm_account_no" {
                    hx_models.append(hx_model)
                }
            }
        }
        hx_kycCommitItemList = hx_models
    }
    
    public func hx_execute(closer: @escaping ((Bool, KYCItemUploadOutModel?) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_kycDataCommit_url).params(hx_dict, signedKeys: ["kycId"]).callback { _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: KYCItemUploadOutModel.self)
                    closer(success ,hx_data)
                }
            }else{
                closer(success,nil)
            }
        }.request()
    }
}
