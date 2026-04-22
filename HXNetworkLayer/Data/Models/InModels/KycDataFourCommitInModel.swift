import Foundation

public class KycDataFourCommitInModel: NSObject {
    
    public var hx_kycId: String? {
        didSet {
            switch hx_kycId {
            case "personal":
                hx_url = "/app/v3/kyc/four/personal"
            case "work_questionnaire":
                hx_url = "/app/v3/kyc/four/work"
            case "urgent_contact":
                hx_url = "/app/v3/kyc/four/contact"
            case "identity_liveness":
                hx_url = "/app/v3/kyc/four/liveness"
            default:
                hx_url = ""
            }
        }
    }
    
    private var hx_dict: [String: String] = [:]
    private var hx_url: String = ""

    public init(data:[FormCellOutModel]) {
        for model in data {
            if model.hx_required == 1 {
                hx_dict[model.hx_opionsCode] = model.hx_optValue
            } else {
                if let hx_value = model.hx_optValue {
                    hx_dict[model.hx_opionsCode] = hx_value
                }
            }
        }
    }
    
    public func hx_execute(closer: @escaping ((Bool, KYCItemUploadOutModel?, Int?) -> ())) {
        NetworkTool().url(hx_url).params(hx_dict).callback { code, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: KYCItemUploadOutModel.self)
                    closer(success ,hx_data, nil)
                    return
                }
            }
            closer(success,nil, code)
        }.request()
    }
}
