import Foundation

class KycPeriodDataInModel: NSObject, Codable {
    var hx_kycId: String?
    enum CodingKeys: String, CodingKey {
        case hx_kycId = "kycId"
    }
    
    func hx_execute(closer: @escaping ((ContactKYCOutModel?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }

        NetworkTool().url(hx_kycPeriodData_url).params(hx_dict, signedKeys: ["kycId"]).callback { _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ContactKYCOutModel.self)
                    if let hx_value = self.hx_kycId, hx_value == "pay_account" {
                        let hx_value = FormCellOutModel(hx_opionsCode: "confirm_account_no", hx_opionsName: hx_commonDoc("n51"), hx_opionsSort: 60)
                        hx_data?.hx_kycItemList.append(hx_value)
                    }
                    closer(hx_data)
                }
            }
        }.request()
    }
}
