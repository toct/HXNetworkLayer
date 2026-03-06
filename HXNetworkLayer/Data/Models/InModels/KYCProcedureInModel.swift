import Foundation

public class KYCProcedureInModel: NSObject {
    public func hx_execute(closer: @escaping ((KYCSOutModel?)->())) {
        NetworkTool().url(hx_getKYCProcedure_url).params().callback {_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: KYCSOutModel.self)
                    SharedModel.shared.hx_kyc = hx_data
                    closer(hx_data)
                }
            }else{
                closer(nil)
            }
        }.request()
    }
}
