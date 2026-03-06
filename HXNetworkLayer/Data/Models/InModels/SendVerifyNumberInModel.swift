import Foundation

public class SendVerifyNumberInModel: NSObject, Codable {
    public var hx_mobile: String?
    public var hx_verifyType: String? = "1"

    enum CodingKeys: String, CodingKey {
        case hx_mobile = "mobile"
        case hx_verifyType = "verifyType"
    }
    
    public func hx_execute(closer: @escaping ((Bool) -> ())) {
        if !hx_checkParametersValid() {
            closer(false)
            return
        }
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_sendVerifyNumber_url).params(hx_dict, signedKeys: ["mobile","verifyType"]).callback({_, success, hx_data in
            if let msg = hx_data as? String, success {
                LoadingIndicator.hx_show(msg)
            }
            closer(success)
        }).request()
    }
    
    private func hx_checkParametersValid() -> Bool {
        
        guard let phone = hx_mobile, !phone.isEmpty  else {
            LoadingIndicator.hx_show(hx_commonDoc("c10"))
            return false
        }
        
        if !phone.hx_isPhilippinePhone() {
            LoadingIndicator.hx_show(hx_commonDoc("c12"))
            return false
        }
        return true
    }
}
