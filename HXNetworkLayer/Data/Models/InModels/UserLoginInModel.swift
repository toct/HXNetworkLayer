import Foundation

public class UserLoginInModel: NSObject, Codable {
    public var hx_verifyCode: String?
    public var hx_mobile: String?
    var hx_serialNo: String? = AmountOutModel.hx_UUID()
    var hx_imei: String? = "null"
    var hx_longitude: String? = "-360"
    var hx_latitude: String? = "-360"
    
    enum CodingKeys: String, CodingKey {
        case hx_verifyCode = "verifyCode"
        case hx_mobile = "mobile"
        case hx_serialNo = "serialNo"
        case hx_imei = "imei"
        case hx_longitude = "longitude"
        case hx_latitude = "latitude"
    }
    
    public func hx_execute(closer: @escaping ((Bool) -> ())) {
        if !hx_checkParametersValid() {
            closer(false)
            return
        }
        
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        let hx_signedKeys = ["verifyCode","mobile","serialNo","imei","longitude","latitude"]
        NetworkTool().url(hx_userLogin_rul).params(hx_dict, signedKeys:hx_signedKeys).callback({_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: LoginOutModel.self)
                    LocalizationData.shared.hx_tmpLoginData = hx_data
                    closer(success)
                }
            }
        }).request()
    }
    
    private func hx_checkParametersValid() -> Bool {
        guard let phone = hx_mobile, !phone.isEmpty else {
            LoadingIndicator.hx_show(hx_commonDoc("c10"))
            return false
        }
        
        if !phone.hx_isPhilippinePhone() {
            LoadingIndicator.hx_show(hx_commonDoc("c12"))
            return false
        }
        
        guard let code = hx_verifyCode, !code.isEmpty else {
            LoadingIndicator.hx_show(hx_commonDoc("c11"))
            return false
        }
        
        if !code.hx_otpVerify() {
            LoadingIndicator.hx_show(hx_commonDoc("c13"))
            return false
        }
        return true
    }
}
